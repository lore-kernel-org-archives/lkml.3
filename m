Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3IJUqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:46:07 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:25989
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505Ab3IJUqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:46:05 -0400
X-Forefront-Antispam-Report: CIP:192.65.42.19;KIP:(null);UIP:(null);IPV:NLI;H:mx.danahertm.com;RD:mx2.danahertm.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z21eIz98dI9371I936eIc85fh542I1432I1418Ide40h2f1anzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz4ejz1de098h17326ah1de097h186068h8275dhz2dh2a8h839h8e3hd25hf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1bceh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h34h1155h)
From: "Rich, Jason" <jason.rich@tekcomms.com>
To: Willy Tarreau <w@1wt.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Panic at _blk_run_queue on 2.6.32
Thread-Topic: Panic at _blk_run_queue on 2.6.32
Thread-Index: Ac58y6RwiDajJiLlQbi1pm9xZ49xQgBCipKADB29+2AABlcz4A==
Date: Tue, 10 Sep 2013 20:45:50 +0000
Message-ID: <636295BFF4A001418A00F46569A2CD2B1624BBCE@US-PLNO-EXM01-P.global.tektronix.net>
References: <636295BFF4A001418A00F46569A2CD2B161CE88B@US-PLNO-EXM01-P.global.tektronix.net>
 <20130710202729.GA18877@1wt.eu> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [192.158.160.99]
Content-Type: multipart/mixed;
	boundary="_002_636295BFF4A001418A00F46569A2CD2B1624BBCEUSPLNOEXM01Pglo_"
MIME-Version: 1.0
X-OriginatorOrg: tekcomms.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_636295BFF4A001418A00F46569A2CD2B1624BBCEUSPLNOEXM01Pglo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Rich, Jason
> Sent: Tuesday, September 10, 2013 1:04 PM
> To: 'Willy Tarreau'
> Cc: linux-kernel@vger.kernel.org
> Subject: RE: Panic at _blk_run_queue on 2.6.32
>=20
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Willy Tarreau
> > Sent: Wednesday, July 10, 2013 3:27 PM
> > To: Rich, Jason
> > Cc: linux-kernel@vger.kernel.org
> > Subject: Re: Panic at _blk_run_queue on 2.6.32
> >
> > Hi Jason,
> >
> > On Tue, Jul 09, 2013 at 05:42:29PM +0000, Rich, Jason wrote:
> > > Greetings,
> > > I've recently encountered an issue where multiple hosts are failing
> > > to boot up about 1/5 of the time.  So far I have confirmed this
> > > issue on three
> > seperate host machines.  The issue presents itself after updating
> > 2.6.32.39 to patch 50 and patch 61.
> > > Both patch levels result in the failure described below.  Since this
> > > occurs on
> > multiple hosts, I feel I can safely rule out hardware.
> >
> > First, thank you for your very detailed report. Do you think you could
> > narrow this down to a specific kernel version ? Given that there are
> > exactly 10 versions between .39 and .50, I think that a version-level
> > bisect would take
> > 3 or 4 builds (so probably around 20 reboots).
> >
> > It would help us spot the faulty patch. Right now, there are 546
> > patches between .39 and .50 so it's quite hard to find the culprit,
> > even with your full trace. That does not mean we'll immediately spot
> > it, maybe a deeper bisect will be needed, but it should be easier.
> >
> > > It is also of note that I have not seen this behavior on the 3.4.26
> > > kernel, or
> > on any of my 32bit hosts.
> >
> > This is a good news, because we're probably missing one fix from a
> > more recent version that addressed a similar regression and that we
> > might backport into 2.6.32.62.
> >
> > > That said, I have to support this software release (which runs on
> > > the 2.6
> > kernel) for at least another two years.
> >
> > Be careful on this point, 2.6.32 is planned for EOL next year :
> >
> >    https://www.kernel.org/category/releases.html
> >
> > You might want to consider migrating to a supported distro kernel or
> > to 3.2 instead. That said, if you follow carefully the updates from
> > later kernels, you might prefer to maintain your own backports of the
> > patches that are relevant to your usage.
> >
> > Best regards,
> > Willy
> >
>=20
> Greeting Willy,
> You helped me out with this particular issue about 2 months ago.  What we
> found is that my particular panic appears to be addressed by a specific
> commit you referred me to:
> b485462 [SCSI] Stop accepting SCSI requests before removing a device
>=20
> Without going into too much detail, I'm not able to jump directly to that=
 hash
> because I have about 7 different drivers failing to compile due to other
> changes between 2.6.32.61 and that hash.  In particular, some header file=
s
> were renamed, others deleted and replaced by newer features.  To go
> through and update my proprietary drivers is as big of a headache as just
> getting this scsi panic fixed on top of patch 61.
>=20
> I've spent the last couple of weeks playing with getting the scsi fix app=
lied on
> top of patch 61 and am having a very difficult time.  There are so many
> dependencies from prior commits to the scsi code it is making it quite di=
fficult
> to determine what exactly I need.
>=20
> I'm hoping you might be able to help me out with some advice or perhaps
> you are familiar enough with the scsi code as to help me apply the concep=
t of
> the fix to the top of patch 61.  I have attached the patch I've come up w=
ith so
> far, but this is obviously missing other dependencies as I keep ending up=
 with
> panics.  It goes without saying that this code is very foreign to me and =
I don't
> completely understand what it is doing.
>=20
> I know your time is valuable so I've attached the patch I've been working=
 on
> so far, however, this code causes its own kernel panic and should not be =
run
> on a live system.  That said, perhaps it will give you a baseline as to w=
hat I'm
> trying to do.  Again, this patch is based off on the official 2.6.32.61 t=
ag.
>=20
> Thanks for any help,
> Jason Rich

Apologies, I had been tweaking that patch file and didn't realize I corrupt=
ed it.  I deleted a line in the scsi_sysfs.c area of the diff and forgot to=
 update the line numbers.  Should be +912,24 (not 25) :
+++ linux-2.6.32.new/drivers/scsi/scsi_sysfs.c	2013-09-09 14:01:38.24910469=
0 -0500
@@ -912,16 +912,24 @@

I have attached the corrected patch file.  Don't want to waste your time wi=
th the old one.  Again, apologies.
>=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


--_002_636295BFF4A001418A00F46569A2CD2B1624BBCEUSPLNOEXM01Pglo_
Content-Type: application/octet-stream; name="0001-scsi_panic.patch"
Content-Description: 0001-scsi_panic.patch
Content-Disposition: attachment; filename="0001-scsi_panic.patch"; size=9576;
	creation-date="Tue, 10 Sep 2013 20:45:17 GMT";
	modification-date="Tue, 10 Sep 2013 20:44:43 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtTnJ1IGxpbnV4LTIuNi4zMi9kcml2ZXJzL3Njc2kvaG9zdHMuYyBsaW51eC0yLjYuMzIu
bmV3L2RyaXZlcnMvc2NzaS9ob3N0cy5jCi0tLSBsaW51eC0yLjYuMzIvZHJpdmVycy9zY3NpL2hv
c3RzLmMJMjAxMy0wOS0wOSAxNDoxMjoxMC41MDkzMzkyMTcgLTA1MDAKKysrIGxpbnV4LTIuNi4z
Mi5uZXcvZHJpdmVycy9zY3NpL2hvc3RzLmMJMjAxMy0wOS0wOSAxNDowMTozOC4yMjAxMDQyNjcg
LTA1MDAKQEAgLTI3Niw2ICsyNzYsNyBAQAogCXN0cnVjdCBTY3NpX0hvc3QgKnNob3N0ID0gZGV2
X3RvX3Nob3N0KGRldik7CiAJc3RydWN0IGRldmljZSAqcGFyZW50ID0gZGV2LT5wYXJlbnQ7CiAJ
c3RydWN0IHJlcXVlc3RfcXVldWUgKnE7CisJdm9pZCAqcXVldWVkYXRhOyAgLy9KUmljaCAtIGFk
ZGVkIGJ5IHBhdGNoIGI0ODU0NjIKIAogCXNjc2lfcHJvY19ob3N0ZGlyX3JtKHNob3N0LT5ob3N0
dCk7CiAKQEAgLTI4NSw5ICsyODYsMTMgQEAKIAkJZGVzdHJveV93b3JrcXVldWUoc2hvc3QtPndv
cmtfcSk7CiAJcSA9IHNob3N0LT51c3BhY2VfcmVxX3E7CiAJaWYgKHEpIHsKLQkJa2ZyZWUocS0+
cXVldWVkYXRhKTsKLQkJcS0+cXVldWVkYXRhID0gTlVMTDsKLQkJc2NzaV9mcmVlX3F1ZXVlKHEp
OworCQkvL2tmcmVlKHEtPnF1ZXVlZGF0YSk7ICAJLy9KUmljaCAtIHJlbW92ZWQgYnkgcGF0Y2gg
YjQ4NTQ2MiAKKwkJLy9xLT5xdWV1ZWRhdGEgPSBOVUxMOyAgCS8vSlJpY2ggLSByZW1vdmVkIGJ5
IHBhdGNoIGI0ODU0NjIKKwkJcXVldWVkYXRhID0gcS0+cXVldWVkYXRhOyAJLy9KUmljaCAtIGFk
ZGVkIGJ5IHBhdGNoIGI0ODU0NjIKKwkJLy9zY3NpX2ZyZWVfcXVldWUocSk7ICAgCS8vSlJpY2gg
LSBpbXBsaWNpdCByZW1vdmUgYnkgcGF0Y2ggYjQ4NTQ2MgorCQlibGtfY2xlYW51cF9xdWV1ZShx
KTsJCS8vSlJpY2ggLSBpbXBsaWNpdCBhZGQgYnkgcGF0Y2ggYjQ4NTQ2MgorCQlrZnJlZShxLT5x
dWV1ZWRhdGEpOwkJLy9KUmljaCAtIGFkZGVkIGJ5IHBhdGNoIGI0ODU0NjIKKwkJLy9xLT5xdWV1
ZWRhdGEgPSBOVUxMOyAgCS8vSlJpY2ggLSByZW1vdmVkIGJ5IHBhdGNoIGI0ODU0NjIKIAl9CiAK
IAlzY3NpX2Rlc3Ryb3lfY29tbWFuZF9mcmVlbGlzdChzaG9zdCk7CgpkaWZmIC1OcnUgbGludXgt
Mi42LjMyL2RyaXZlcnMvc2NzaS9zY3NpX2xpYi5jIGxpbnV4LTIuNi4zMi5uZXcvZHJpdmVycy9z
Y3NpL3Njc2lfbGliLmMKLS0tIGxpbnV4LTIuNi4zMi9kcml2ZXJzL3Njc2kvc2NzaV9saWIuYwky
MDEzLTA5LTA5IDE0OjEyOjEwLjUxMjMzOTI2MCAtMDUwMAorKysgbGludXgtMi42LjMyLm5ldy9k
cml2ZXJzL3Njc2kvc2NzaV9saWIuYwkyMDEzLTA5LTA5IDE0OjAxOjM2LjU2ODA4MDEzNSAtMDUw
MApAQCAtNjcsNyArNjcsNyBAQAogCiBzdHJ1Y3Qga21lbV9jYWNoZSAqc2NzaV9zZGJfY2FjaGU7
CiAKLXN0YXRpYyB2b2lkIHNjc2lfcnVuX3F1ZXVlKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxKTsK
Ky8vc3RhdGljIHZvaWQgc2NzaV9ydW5fcXVldWUoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEpOyAg
Ly9KUmljaCAtIFJlbW92ZWQgYnkgOTkzN2E1ZTJmIAogCiAvKgogICogRnVuY3Rpb246CXNjc2lf
dW5wcmVwX3JlcXVlc3QoKQpAQCAtMTAzLDcgKzEwMyw3IEBACiAgKiBmb3IgYSByZXF1ZXVlIGFm
dGVyIGNvbXBsZXRpb24sIHdoaWNoIHNob3VsZCBvbmx5IG9jY3VyIGluIHRoaXMKICAqIGZpbGUu
CiAgKi8KLXN0YXRpYyBpbnQgX19zY3NpX3F1ZXVlX2luc2VydChzdHJ1Y3Qgc2NzaV9jbW5kICpj
bWQsIGludCByZWFzb24sIGludCB1bmJ1c3kpCitzdGF0aWMgdm9pZCBfX3Njc2lfcXVldWVfaW5z
ZXJ0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCwgaW50IHJlYXNvbiwgaW50IHVuYnVzeSkgLy9KUmlj
aCBjaGFuZ2VkIHRvIHZvaWQgYnkgcGF0Y2ggYjQ4NTQ2MgogewogCXN0cnVjdCBTY3NpX0hvc3Qg
Kmhvc3QgPSBjbWQtPmRldmljZS0+aG9zdDsKIAlzdHJ1Y3Qgc2NzaV9kZXZpY2UgKmRldmljZSA9
IGNtZC0+ZGV2aWNlOwpAQCAtMTQ4LDIyICsxNDgsMTggQEAKIAogCS8qCiAJICogUmVxdWV1ZSB0
aGlzIGNvbW1hbmQuICBJdCB3aWxsIGdvIGJlZm9yZSBhbGwgb3RoZXIgY29tbWFuZHMKLQkgKiB0
aGF0IGFyZSBhbHJlYWR5IGluIHRoZSBxdWV1ZS4KLQkgKgotCSAqIE5PVEU6IHRoZXJlIGlzIG1h
Z2ljIGhlcmUgYWJvdXQgdGhlIHdheSB0aGUgcXVldWUgaXMgcGx1Z2dlZCBpZgotCSAqIHdlIGhh
dmUgbm8gb3V0c3RhbmRpbmcgY29tbWFuZHMuCi0JICogCi0JICogQWx0aG91Z2ggd2UgKmRvbid0
KiBwbHVnIHRoZSBxdWV1ZSwgd2UgY2FsbCB0aGUgcmVxdWVzdAotCSAqIGZ1bmN0aW9uLiAgVGhl
IFNDU0kgcmVxdWVzdCBmdW5jdGlvbiBkZXRlY3RzIHRoZSBibG9ja2VkIGNvbmRpdGlvbgotCSAq
IGFuZCBwbHVncyB0aGUgcXVldWUgYXBwcm9wcmlhdGVseS4KKwkgKiB0aGF0IGFyZSBhbHJlYWR5
IGluIHRoZSBxdWV1ZS4gU2NoZWR1bGUgcmVxdWV1ZSB3b3JrIHVuZGVyCisJICogbG9jayBzdWNo
IHRoYXQgdGhlIGtibG9ja2Rfc2NoZWR1bGVfd29yaygpIGNhbGwgaGFwcGVucyAgLy9KUmljaCAt
IGNvbW1lbnRzIG1vZGlmaWVkIGJ5IHBhdGNoIGI0ODU0NjIKKwkgKiBiZWZvcmUgYmxrX2NsZWFu
dXBfcXVldWUoKSBmaW5pc2hlcy4KICAgICAgICAgICovCiAJc3Bpbl9sb2NrX2lycXNhdmUocS0+
cXVldWVfbG9jaywgZmxhZ3MpOwogCWJsa19yZXF1ZXVlX3JlcXVlc3QocSwgY21kLT5yZXF1ZXN0
KTsKLQlzcGluX3VubG9ja19pcnFyZXN0b3JlKHEtPnF1ZXVlX2xvY2ssIGZsYWdzKTsKLQotCXNj
c2lfcnVuX3F1ZXVlKHEpOworCS8vc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShxLT5xdWV1ZV9sb2Nr
LCBmbGFncyk7IAkvL0pSaWNoIC0gcmVtb3ZlZCBieSBwYXRjaCBiNDg1NDYyCisJLy9zY3NpX3J1
bl9xdWV1ZShxKTsJCQkJCQkJCS8vSlJpY2ggLSBpbXBsaWNpdCByZW1vdmUgYnkgcGF0Y2ggYjQ4
NTQ2MiAtIChyZW1vdmVkIGJ5IDk5MzdhNWUyZikKKwlrYmxvY2tkX3NjaGVkdWxlX3dvcmsocSwg
JmRldmljZS0+cmVxdWV1ZV93b3JrKTsJLy9KUmljaCAtIGltcGxpY2l0IGFkZCBieSBwYXRjaCBi
NDg1NDYyIC0gKEFEREVEIGJ5IDk5MzdhNWUyZikKKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKHEt
PnF1ZXVlX2xvY2ssIGZsYWdzKTsJCS8vSlJpY2ggLSBhZGRlZCBieSBwYXRjaCBiNDg1NDYyCiAK
LQlyZXR1cm4gMDsKKwkvL3JldHVybiAwOyAgCQkJCQkJCQkJCS8vSlJpY2ggLSByZW1vdmVkIGJ5
IHBhdGNoIGI0ODU0NjIKIH0KIAogLyoKQEAgLTE4NSw5ICsxODEsOSBAQAogICogTm90ZXM6ICAg
ICAgIFRoaXMgY291bGQgYmUgY2FsbGVkIGVpdGhlciBmcm9tIGFuIGludGVycnVwdCBjb250ZXh0
IG9yIGEKICAqICAgICAgICAgICAgICBub3JtYWwgcHJvY2VzcyBjb250ZXh0LgogICovCi1pbnQg
c2NzaV9xdWV1ZV9pbnNlcnQoc3RydWN0IHNjc2lfY21uZCAqY21kLCBpbnQgcmVhc29uKQordm9p
ZCBzY3NpX3F1ZXVlX2luc2VydChzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQsIGludCByZWFzb24pICAv
L0pSaWNoIC0gdm9pZCBieSBwYXRjaCBiNDg1NDYyCiB7Ci0JcmV0dXJuIF9fc2NzaV9xdWV1ZV9p
bnNlcnQoY21kLCByZWFzb24sIDEpOworCV9fc2NzaV9xdWV1ZV9pbnNlcnQoY21kLCByZWFzb24s
IDEpOyAgCQkJCQkvL0pSaWNoIC0gdm9pZCBieSBwYXRjaCBiNDg1NDYyCiB9CiAvKioKICAqIHNj
c2lfZXhlY3V0ZSAtIGluc2VydCByZXF1ZXN0IGFuZCB3YWl0IGZvciB0aGUgcmVzdWx0CkBAIC00
NDMsMTggKzQzOSwxNiBAQAogCQl9CiAKIAkJc3Bpbl91bmxvY2soc2hvc3QtPmhvc3RfbG9jayk7
Ci0KIAkJc3Bpbl9sb2NrKHNkZXYtPnJlcXVlc3RfcXVldWUtPnF1ZXVlX2xvY2spOwotCQlmbGFn
c2V0ID0gdGVzdF9iaXQoUVVFVUVfRkxBR19SRUVOVEVSLCAmcS0+cXVldWVfZmxhZ3MpICYmCi0J
CQkJIXRlc3RfYml0KFFVRVVFX0ZMQUdfUkVFTlRFUiwKLQkJCQkJJnNkZXYtPnJlcXVlc3RfcXVl
dWUtPnF1ZXVlX2ZsYWdzKTsKLQkJaWYgKGZsYWdzZXQpCi0JCQlxdWV1ZV9mbGFnX3NldChRVUVV
RV9GTEFHX1JFRU5URVIsIHNkZXYtPnJlcXVlc3RfcXVldWUpOworCQkvL2ZsYWdzZXQgPSB0ZXN0
X2JpdChRVUVVRV9GTEFHX1JFRU5URVIsICZxLT5xdWV1ZV9mbGFncykgJiYKKwkJLy8JCSF0ZXN0
X2JpdChRVUVVRV9GTEFHX1JFRU5URVIsCisJCS8vCQkmc2Rldi0+cmVxdWVzdF9xdWV1ZS0+cXVl
dWVfZmxhZ3MpOyAJCQkJCS8vSlJpY2ggLSBJbXBsaWNpdCByZW1vdmUgYnkgcGF0Y2ggOTkzN2E1
ZTJmIAorCQkvL2lmIChmbGFnc2V0KQorCQkJLy9xdWV1ZV9mbGFnX3NldChRVUVVRV9GTEFHX1JF
RU5URVIsIHNkZXYtPnJlcXVlc3RfcXVldWUpOwkvL0pSaWNoIC0gSW1wbGljaXQgcmVtb3ZlIGJ5
IHBhdGNoIDk5MzdhNWUyZiAKIAkJX19ibGtfcnVuX3F1ZXVlKHNkZXYtPnJlcXVlc3RfcXVldWUp
OwotCQlpZiAoZmxhZ3NldCkKLQkJCXF1ZXVlX2ZsYWdfY2xlYXIoUVVFVUVfRkxBR19SRUVOVEVS
LCBzZGV2LT5yZXF1ZXN0X3F1ZXVlKTsKKwkJLy9pZiAoZmxhZ3NldCkKKwkJCS8vcXVldWVfZmxh
Z19jbGVhcihRVUVVRV9GTEFHX1JFRU5URVIsIHNkZXYtPnJlcXVlc3RfcXVldWUpOy8vSlJpY2gg
LSBJbXBsaWNpdCByZW1vdmUgYnkgcGF0Y2ggOTkzN2E1ZTJmIAogCQlzcGluX3VubG9jayhzZGV2
LT5yZXF1ZXN0X3F1ZXVlLT5xdWV1ZV9sb2NrKTsKLQogCQlzcGluX2xvY2soc2hvc3QtPmhvc3Rf
bG9jayk7CiAJfQogCS8qIHB1dCBhbnkgdW5wcm9jZXNzZWQgZW50cmllcyBiYWNrICovCkBAIC00
NjQsNiArNDU4LDE2IEBACiAJYmxrX3J1bl9xdWV1ZShxKTsKIH0KIAordm9pZCBzY3NpX3JlcXVl
dWVfcnVuX3F1ZXVlKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykgIC8vSlJpY2ggLSBBZGRlZCBl
bnRpcmUgZnVuY3Rpb24gcGF0Y2ggOTkzN2E1ZTJmIAoreworICAgICAgIHN0cnVjdCBzY3NpX2Rl
dmljZSAqc2RldjsKKyAgICAgICBzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcTsKKworICAgICAgIHNk
ZXYgPSBjb250YWluZXJfb2Yod29yaywgc3RydWN0IHNjc2lfZGV2aWNlLCByZXF1ZXVlX3dvcmsp
OworICAgICAgIHEgPSBzZGV2LT5yZXF1ZXN0X3F1ZXVlOworICAgICAgIHNjc2lfcnVuX3F1ZXVl
KHEpOworfQorCiAvKgogICogRnVuY3Rpb246CXNjc2lfcmVxdWV1ZV9jb21tYW5kKCkKICAqCkBA
IC00ODQsNyArNDg4LDcgQEAKICAqLwogc3RhdGljIHZvaWQgc2NzaV9yZXF1ZXVlX2NvbW1hbmQo
c3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkKIHsKLQlzdHJ1
Y3Qgc2NzaV9kZXZpY2UgKnNkZXYgPSBjbWQtPmRldmljZTsKKwlzdHJ1Y3Qgc2NzaV9kZXZpY2Ug
KnNkZXYgPSBjbWQtPmRldmljZTsgIC8vSlJpY2ggLSBubyBjaGFuZ2UgbmVlZGVkIHRob3VnaCBw
YXRjaCBiNDg1NDYyIHNob3dzIGl0IHdhcyByZW1vdmVkIGF0IHNvbWUgcG9pbnQKIAlzdHJ1Y3Qg
cmVxdWVzdCAqcmVxID0gY21kLT5yZXF1ZXN0OwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAKQEAg
LTQ5NCw3ICs0OTgsNyBAQAogCSAqIG1heSBoYXBwZW4gYmVjYXVzZSBzY3NpX3VucHJlcF9yZXF1
ZXN0KCkgcHV0cyB0aGUgY29tbWFuZCB3aGljaAogCSAqIHJlbGVhc2VzIGl0cyByZWZlcmVuY2Ug
b24gdGhlIGRldmljZS4KIAkgKi8KLQlnZXRfZGV2aWNlKCZzZGV2LT5zZGV2X2dlbmRldik7CisJ
Z2V0X2RldmljZSgmc2Rldi0+c2Rldl9nZW5kZXYpOyAgLy9KUmljaCAtIG5vIGNoYW5nZSBuZWVk
ZWQgdGhvdWdoIHBhdGNoIGI0ODU0NjIgc2hvd3MgaXQgd2FzIHJlbW92ZWQgYXQgc29tZSBwb2lu
dAogCiAJc3Bpbl9sb2NrX2lycXNhdmUocS0+cXVldWVfbG9jaywgZmxhZ3MpOwogCXNjc2lfdW5w
cmVwX3JlcXVlc3QocmVxKTsKQEAgLTUwMyw3ICs1MDcsNyBAQAogCiAJc2NzaV9ydW5fcXVldWUo
cSk7CiAKLQlwdXRfZGV2aWNlKCZzZGV2LT5zZGV2X2dlbmRldik7CisJcHV0X2RldmljZSgmc2Rl
di0+c2Rldl9nZW5kZXYpOyAvL0pSaWNoIC0gbm8gY2hhbmdlIG5lZWRlZCB0aG91Z2ggcGF0Y2gg
YjQ4NTQ2MiBzaG93cyBpdCB3YXMgcmVtb3ZlZCBhdCBzb21lIHBvaW50CiB9CiAKIHZvaWQgc2Nz
aV9uZXh0X2NvbW1hbmQoc3RydWN0IHNjc2lfY21uZCAqY21kKQpkaWZmIC1OcnUgbGludXgtMi42
LjMyL2RyaXZlcnMvc2NzaS9zY3NpX3ByaXYuaCBsaW51eC0yLjYuMzIubmV3L2RyaXZlcnMvc2Nz
aS9zY3NpX3ByaXYuaAotLS0gbGludXgtMi42LjMyL2RyaXZlcnMvc2NzaS9zY3NpX3ByaXYuaAky
MDEzLTA5LTA5IDE0OjEyOjEwLjUxMjMzOTI2MCAtMDUwMAorKysgbGludXgtMi42LjMyLm5ldy9k
cml2ZXJzL3Njc2kvc2NzaV9wcml2LmgJMjAxMy0wOS0wOSAxNDowMTozNi4yMjgwNzUxNjcgLTA1
MDAKQEAgLTc3LDcgKzc3LDcgQEAKIC8qIHNjc2lfbGliLmMgKi8KIGV4dGVybiBpbnQgc2NzaV9t
YXliZV91bmJsb2NrX2hvc3Qoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2KTsKIGV4dGVybiB2b2lk
IHNjc2lfZGV2aWNlX3VuYnVzeShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpOwotZXh0ZXJuIGlu
dCBzY3NpX3F1ZXVlX2luc2VydChzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQsIGludCByZWFzb24pOwor
ZXh0ZXJuIHZvaWQgc2NzaV9xdWV1ZV9pbnNlcnQoc3RydWN0IHNjc2lfY21uZCAqY21kLCBpbnQg
cmVhc29uKTsgIC8vSlJpY2ggY2hhbmdlZCB0byB2b2lkIGJ5IHBhdGNoIGI0ODU0NjIKIGV4dGVy
biB2b2lkIHNjc2lfbmV4dF9jb21tYW5kKHN0cnVjdCBzY3NpX2NtbmQgKmNtZCk7CiBleHRlcm4g
dm9pZCBzY3NpX2lvX2NvbXBsZXRpb24oc3RydWN0IHNjc2lfY21uZCAqLCB1bnNpZ25lZCBpbnQp
OwogZXh0ZXJuIHZvaWQgc2NzaV9ydW5faG9zdF9xdWV1ZXMoc3RydWN0IFNjc2lfSG9zdCAqc2hv
c3QpOwpkaWZmIC1OcnUgbGludXgtMi42LjMyL2RyaXZlcnMvc2NzaS9zY3NpX3NjYW4uYyBsaW51
eC0yLjYuMzIubmV3L2RyaXZlcnMvc2NzaS9zY3NpX3NjYW4uYwotLS0gbGludXgtMi42LjMyL2Ry
aXZlcnMvc2NzaS9zY3NpX3NjYW4uYwkyMDEzLTA5LTA5IDE0OjEyOjEwLjUxMjMzOTI2MCAtMDUw
MAorKysgbGludXgtMi42LjMyLm5ldy9kcml2ZXJzL3Njc2kvc2NzaV9zY2FuLmMJMjAxMy0wOS0w
OSAxNDowMTozOC40MTcxMDcxNDUgLTA1MDAKQEAgLTI0MSw2ICsyNDEsNyBAQAogCWludCBkaXNw
bGF5X2ZhaWx1cmVfbXNnID0gMSwgcmV0OwogCXN0cnVjdCBTY3NpX0hvc3QgKnNob3N0ID0gZGV2
X3RvX3Nob3N0KHN0YXJnZXQtPmRldi5wYXJlbnQpOwogCWV4dGVybiB2b2lkIHNjc2lfZXZ0X3Ro
cmVhZChzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOworCWV4dGVybiB2b2lkIHNjc2lfcmVxdWV1
ZV9ydW5fcXVldWUoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsgIC8vSlJpY2ggLSBBZGRlZCBi
eSBwYXRjaCA5OTM3YTVlMmYKIAogCXNkZXYgPSBremFsbG9jKHNpemVvZigqc2RldikgKyBzaG9z
dC0+dHJhbnNwb3J0dC0+ZGV2aWNlX3NpemUsCiAJCSAgICAgICBHRlBfQVRPTUlDKTsKQEAgLTI2
Miw2ICsyNjMsNyBAQAogCUlOSVRfTElTVF9IRUFEKCZzZGV2LT5ldmVudF9saXN0KTsKIAlzcGlu
X2xvY2tfaW5pdCgmc2Rldi0+bGlzdF9sb2NrKTsKIAlJTklUX1dPUksoJnNkZXYtPmV2ZW50X3dv
cmssIHNjc2lfZXZ0X3RocmVhZCk7CisJSU5JVF9XT1JLKCZzZGV2LT5yZXF1ZXVlX3dvcmssIHNj
c2lfcmVxdWV1ZV9ydW5fcXVldWUpOyAgLy9KUmljaCAtIEFkZGVkIGJ5IHBhdGNoIDk5MzdhNWUy
ZgogCiAJc2Rldi0+c2Rldl9nZW5kZXYucGFyZW50ID0gZ2V0X2RldmljZSgmc3RhcmdldC0+ZGV2
KTsKIAlzZGV2LT5zZGV2X3RhcmdldCA9IHN0YXJnZXQ7CmRpZmYgLU5ydSBsaW51eC0yLjYuMzIv
ZHJpdmVycy9zY3NpL3Njc2lfc3lzZnMuYyBsaW51eC0yLjYuMzIubmV3L2RyaXZlcnMvc2NzaS9z
Y3NpX3N5c2ZzLmMKLS0tIGxpbnV4LTIuNi4zMi9kcml2ZXJzL3Njc2kvc2NzaV9zeXNmcy5jCTIw
MTMtMDktMDkgMTQ6MTI6MTAuNTEyMzM5MjYwIC0wNTAwCisrKyBsaW51eC0yLjYuMzIubmV3L2Ry
aXZlcnMvc2NzaS9zY3NpX3N5c2ZzLmMJMjAxMy0wOS0wOSAxNDowMTozOC4yNDkxMDQ2OTAgLTA1
MDAKQEAgLTkxMiwxNiArOTEyLDI0IEBACiAJCWRldmljZV9kZWwoZGV2KTsKIAl9IGVsc2UKIAkJ
cHV0X2RldmljZSgmc2Rldi0+c2Rldl9kZXYpOworIAkvKgorCSAqIFN0b3AgYWNjZXB0aW5nIG5l
dyByZXF1ZXN0cyBhbmQgd2FpdCB1bnRpbCBhbGwgcXVldWVjb21tYW5kKCkgYW5kCisJICogc2Nz
aV9ydW5fcXVldWUoKSBpbnZvY2F0aW9ucyBoYXZlIGZpbmlzaGVkIGJlZm9yZSB0ZWFyaW5nIGRv
d24gdGhlCisJICogZGV2aWNlLgorCSAqLwogCXNjc2lfZGV2aWNlX3NldF9zdGF0ZShzZGV2LCBT
REVWX0RFTCk7CisKKwlibGtfY2xlYW51cF9xdWV1ZShzZGV2LT5yZXF1ZXN0X3F1ZXVlKTsgCS8v
SlJpY2ggLSBhZGRlZCBieSBwYXRjaCBiNDg1NDYyCisJY2FuY2VsX3dvcmtfc3luYygmc2Rldi0+
cmVxdWV1ZV93b3JrKTsJCS8vSlJpY2ggLSBhZGRlZCBieSBwYXRjaCBiNDg1NDYyCiAJaWYgKHNk
ZXYtPmhvc3QtPmhvc3R0LT5zbGF2ZV9kZXN0cm95KQogCQlzZGV2LT5ob3N0LT5ob3N0dC0+c2xh
dmVfZGVzdHJveShzZGV2KTsKIAl0cmFuc3BvcnRfZGVzdHJveV9kZXZpY2UoZGV2KTsKIAogCS8q
IGNhdXNlIHRoZSByZXF1ZXN0IGZ1bmN0aW9uIHRvIHJlamVjdCBhbGwgSS9PIHJlcXVlc3RzICov
Ci0Jc2Rldi0+cmVxdWVzdF9xdWV1ZS0+cXVldWVkYXRhID0gTlVMTDsKKwkvL3NkZXYtPnJlcXVl
c3RfcXVldWUtPnF1ZXVlZGF0YSA9IE5VTEw7ICAJLy9KUmljaCAtIGltcGxpY2l0IHJlbW92ZSBi
eSBwYXRjaCBiNDg1NDYyCiAKIAkvKiBGcmVlaW5nIHRoZSBxdWV1ZSBzaWduYWxzIHRvIGJsb2Nr
IHRoYXQgd2UncmUgZG9uZSAqLwotCXNjc2lfZnJlZV9xdWV1ZShzZGV2LT5yZXF1ZXN0X3F1ZXVl
KTsKKwkvL3Njc2lfZnJlZV9xdWV1ZShzZGV2LT5yZXF1ZXN0X3F1ZXVlKTsgCS8vSlJpY2ggLSBp
bXBsaWNpdCByZW1vdmUgYnkgcGF0Y2ggYjQ4NTQ2MgogCXB1dF9kZXZpY2UoZGV2KTsKIH0KIApk
aWZmIC1OcnUgbGludXgtMi42LjMyL2luY2x1ZGUvc2NzaS9zY3NpX2RldmljZS5oIGxpbnV4LTIu
Ni4zMi5uZXcvaW5jbHVkZS9zY3NpL3Njc2lfZGV2aWNlLmgKLS0tIGxpbnV4LTIuNi4zMi9pbmNs
dWRlL3Njc2kvc2NzaV9kZXZpY2UuaAkyMDEzLTA5LTA5IDE0OjEyOjEwLjU0MjMzOTY5OCAtMDUw
MAorKysgbGludXgtMi42LjMyLm5ldy9pbmNsdWRlL3Njc2kvc2NzaV9kZXZpY2UuaAkyMDEzLTA5
LTA5IDE0OjAwOjE0LjU1NDg4MjAyMiAtMDUwMApAQCAtMTY0LDYgKzE2NCw3IEBACiAJCQkJc2Rl
dl9kZXY7CiAKIAlzdHJ1Y3QgZXhlY3V0ZV93b3JrCWV3OyAvKiB1c2VkIHRvIGdldCBwcm9jZXNz
IGNvbnRleHQgb24gcHV0ICovCisJc3RydWN0IHdvcmtfc3RydWN0ICAgICAgcmVxdWV1ZV93b3Jr
OyAgLy9KUmljaCAtIEFkZGVkIGJ5IFBhdGNoIDk5MzdhNWUyZgogCiAJc3RydWN0IHNjc2lfZGhf
ZGF0YQkqc2NzaV9kaF9kYXRhOwogCWVudW0gc2NzaV9kZXZpY2Vfc3RhdGUgc2Rldl9zdGF0ZTsK

--_002_636295BFF4A001418A00F46569A2CD2B1624BBCEUSPLNOEXM01Pglo_--
