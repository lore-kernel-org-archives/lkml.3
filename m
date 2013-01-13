Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3AMOj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 09:39:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33668 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754994Ab3AMOj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 09:39:56 -0500
Message-ID: <1358087991.4514.81.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 192/241] GFS2: Test bufdata with buffer locked and
 gfs2_log_lock held
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Sun, 13 Jan 2013 14:39:51 +0000
In-Reply-To: <1355407206-17100-193-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
	 <1355407206-17100-193-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RM4IOEnIueECv9qfdSxM"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RM4IOEnIueECv9qfdSxM
Content-Type: multipart/mixed; boundary="=-SdmwbAn6MH8F5Yu8rlhX"


--=-SdmwbAn6MH8F5Yu8rlhX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-12-13 at 11:59 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7.2 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Benjamin Marzinski <bmarzins@redhat.com>
>=20
> commit 96e5d1d3adf56f1c7eeb07258f6a1a0a7ae9c489 upstream.
>=20
> In gfs2_trans_add_bh(), gfs2 was testing if a there was a bd attached to =
the
> buffer without having the gfs2_log_lock held. It was then assuming it wou=
ld
> stay attached for the rest of the function. However, without either the l=
og
> lock being held of the buffer locked, __gfs2_ail_flush() could detach bd =
at any
> time.  This patch moves the locking before the test.  If there isn't a bd
> already attached, gfs2 can safely allocate one and attach it before locki=
ng.
> There is no way that the newly allocated bd could be on the ail list,
> and thus no way for __gfs2_ail_flush() to detach it.
[...]

Greg, this is missing from 3.0 and 3.4.  I'm attaching the version I
used for 3.2 which might be applicable.

Ben.

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-SdmwbAn6MH8F5Yu8rlhX
Content-Disposition: attachment;
	filename*0=gfs2-test-bufdata-with-buffer-locked-and-gfs2_log_lock-held.p;
	filename*1=atch
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="gfs2-test-bufdata-with-buffer-locked-and-gfs2_log_lock-held.patch";
	charset="UTF-8"

RnJvbTogQmVuamFtaW4gTWFyemluc2tpIDxibWFyemluc0ByZWRoYXQuY29tPg0KRGF0ZTogV2Vk
LCA3IE5vdiAyMDEyIDAwOjM4OjA2IC0wNjAwDQpTdWJqZWN0OiBHRlMyOiBUZXN0IGJ1ZmRhdGEg
d2l0aCBidWZmZXIgbG9ja2VkIGFuZCBnZnMyX2xvZ19sb2NrIGhlbGQNCg0KY29tbWl0IDk2ZTVk
MWQzYWRmNTZmMWM3ZWViMDcyNThmNmExYTBhN2FlOWM0ODkgdXBzdHJlYW0uDQoNCkluIGdmczJf
dHJhbnNfYWRkX2JoKCksIGdmczIgd2FzIHRlc3RpbmcgaWYgYSB0aGVyZSB3YXMgYSBiZCBhdHRh
Y2hlZCB0byB0aGUNCmJ1ZmZlciB3aXRob3V0IGhhdmluZyB0aGUgZ2ZzMl9sb2dfbG9jayBoZWxk
LiBJdCB3YXMgdGhlbiBhc3N1bWluZyBpdCB3b3VsZA0Kc3RheSBhdHRhY2hlZCBmb3IgdGhlIHJl
c3Qgb2YgdGhlIGZ1bmN0aW9uLiBIb3dldmVyLCB3aXRob3V0IGVpdGhlciB0aGUgbG9nDQpsb2Nr
IGJlaW5nIGhlbGQgb2YgdGhlIGJ1ZmZlciBsb2NrZWQsIF9fZ2ZzMl9haWxfZmx1c2goKSBjb3Vs
ZCBkZXRhY2ggYmQgYXQgYW55DQp0aW1lLiAgVGhpcyBwYXRjaCBtb3ZlcyB0aGUgbG9ja2luZyBi
ZWZvcmUgdGhlIHRlc3QuICBJZiB0aGVyZSBpc24ndCBhIGJkDQphbHJlYWR5IGF0dGFjaGVkLCBn
ZnMyIGNhbiBzYWZlbHkgYWxsb2NhdGUgb25lIGFuZCBhdHRhY2ggaXQgYmVmb3JlIGxvY2tpbmcu
DQpUaGVyZSBpcyBubyB3YXkgdGhhdCB0aGUgbmV3bHkgYWxsb2NhdGVkIGJkIGNvdWxkIGJlIG9u
IHRoZSBhaWwgbGlzdCwNCmFuZCB0aHVzIG5vIHdheSBmb3IgX19nZnMyX2FpbF9mbHVzaCgpIHRv
IGRldGFjaCBpdC4NCg0KU2lnbmVkLW9mZi1ieTogQmVuamFtaW4gTWFyemluc2tpIDxibWFyemlu
c0ByZWRoYXQuY29tPg0KU2lnbmVkLW9mZi1ieTogU3RldmVuIFdoaXRlaG91c2UgPHN3aGl0ZWhv
QHJlZGhhdC5jb20+DQpbYndoOiBCYWNrcG9ydGVkIHRvIDMuMjogYWRqdXN0IGNvbnRleHRdDQpT
aWduZWQtb2ZmLWJ5OiBCZW4gSHV0Y2hpbmdzIDxiZW5AZGVjYWRlbnQub3JnLnVrPg0KLS0tDQog
ZnMvZ2ZzMi9sb3BzLmMgIHwgICAxNCArKy0tLS0tLS0tLS0tLQ0KIGZzL2dmczIvdHJhbnMuYyB8
ICAgIDggKysrKysrKysNCiAyIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDEyIGRl
bGV0aW9ucygtKQ0KDQotLS0gYS9mcy9nZnMyL2xvcHMuYw0KKysrIGIvZnMvZ2ZzMi9sb3BzLmMN
CkBAIC0xNjUsMTYgKzE2NSwxNCBAQCBzdGF0aWMgdm9pZCBidWZfbG9fYWRkKHN0cnVjdCBnZnMy
X3NiZCAqDQogCXN0cnVjdCBnZnMyX21ldGFfaGVhZGVyICptaDsNCiAJc3RydWN0IGdmczJfdHJh
bnMgKnRyOw0KIA0KLQlsb2NrX2J1ZmZlcihiZC0+YmRfYmgpOw0KLQlnZnMyX2xvZ19sb2NrKHNk
cCk7DQogCWlmICghbGlzdF9lbXB0eSgmYmQtPmJkX2xpc3RfdHIpKQ0KLQkJZ290byBvdXQ7DQor
CQlyZXR1cm47DQogCXRyID0gY3VycmVudC0+am91cm5hbF9pbmZvOw0KIAl0ci0+dHJfdG91Y2hl
ZCA9IDE7DQogCXRyLT50cl9udW1fYnVmKys7DQogCWxpc3RfYWRkKCZiZC0+YmRfbGlzdF90ciwg
JnRyLT50cl9saXN0X2J1Zik7DQogCWlmICghbGlzdF9lbXB0eSgmbGUtPmxlX2xpc3QpKQ0KLQkJ
Z290byBvdXQ7DQorCQlyZXR1cm47DQogCXNldF9iaXQoR0xGX0xGTFVTSCwgJmJkLT5iZF9nbC0+
Z2xfZmxhZ3MpOw0KIAlzZXRfYml0KEdMRl9ESVJUWSwgJmJkLT5iZF9nbC0+Z2xfZmxhZ3MpOw0K
IAlnZnMyX21ldGFfY2hlY2soc2RwLCBiZC0+YmRfYmgpOw0KQEAgLTE4NSw5ICsxODMsNiBAQCBz
dGF0aWMgdm9pZCBidWZfbG9fYWRkKHN0cnVjdCBnZnMyX3NiZCAqDQogCXNkcC0+c2RfbG9nX251
bV9idWYrKzsNCiAJbGlzdF9hZGQoJmxlLT5sZV9saXN0LCAmc2RwLT5zZF9sb2dfbGVfYnVmKTsN
CiAJdHItPnRyX251bV9idWZfbmV3Kys7DQotb3V0Og0KLQlnZnMyX2xvZ191bmxvY2soc2RwKTsN
Ci0JdW5sb2NrX2J1ZmZlcihiZC0+YmRfYmgpOw0KIH0NCiANCiBzdGF0aWMgdm9pZCBidWZfbG9f
YmVmb3JlX2NvbW1pdChzdHJ1Y3QgZ2ZzMl9zYmQgKnNkcCkNCkBAIC01MTgsMTEgKzUxMyw5IEBA
IHN0YXRpYyB2b2lkIGRhdGFidWZfbG9fYWRkKHN0cnVjdCBnZnMyX3MNCiAJc3RydWN0IGFkZHJl
c3Nfc3BhY2UgKm1hcHBpbmcgPSBiZC0+YmRfYmgtPmJfcGFnZS0+bWFwcGluZzsNCiAJc3RydWN0
IGdmczJfaW5vZGUgKmlwID0gR0ZTMl9JKG1hcHBpbmctPmhvc3QpOw0KIA0KLQlsb2NrX2J1ZmZl
cihiZC0+YmRfYmgpOw0KLQlnZnMyX2xvZ19sb2NrKHNkcCk7DQogCWlmICh0cikgew0KIAkJaWYg
KCFsaXN0X2VtcHR5KCZiZC0+YmRfbGlzdF90cikpDQotCQkJZ290byBvdXQ7DQorCQkJcmV0dXJu
Ow0KIAkJdHItPnRyX3RvdWNoZWQgPSAxOw0KIAkJaWYgKGdmczJfaXNfamRhdGEoaXApKSB7DQog
CQkJdHItPnRyX251bV9idWYrKzsNCkBAIC01MzAsNyArNTIzLDcgQEAgc3RhdGljIHZvaWQgZGF0
YWJ1Zl9sb19hZGQoc3RydWN0IGdmczJfcw0KIAkJfQ0KIAl9DQogCWlmICghbGlzdF9lbXB0eSgm
bGUtPmxlX2xpc3QpKQ0KLQkJZ290byBvdXQ7DQorCQlyZXR1cm47DQogDQogCXNldF9iaXQoR0xG
X0xGTFVTSCwgJmJkLT5iZF9nbC0+Z2xfZmxhZ3MpOw0KIAlzZXRfYml0KEdMRl9ESVJUWSwgJmJk
LT5iZF9nbC0+Z2xfZmxhZ3MpOw0KQEAgLTU0Miw5ICs1MzUsNiBAQCBzdGF0aWMgdm9pZCBkYXRh
YnVmX2xvX2FkZChzdHJ1Y3QgZ2ZzMl9zDQogCX0gZWxzZSB7DQogCQlsaXN0X2FkZF90YWlsKCZs
ZS0+bGVfbGlzdCwgJnNkcC0+c2RfbG9nX2xlX29yZGVyZWQpOw0KIAl9DQotb3V0Og0KLQlnZnMy
X2xvZ191bmxvY2soc2RwKTsNCi0JdW5sb2NrX2J1ZmZlcihiZC0+YmRfYmgpOw0KIH0NCiANCiBz
dGF0aWMgdm9pZCBnZnMyX2NoZWNrX21hZ2ljKHN0cnVjdCBidWZmZXJfaGVhZCAqYmgpDQotLS0g
YS9mcy9nZnMyL3RyYW5zLmMNCisrKyBiL2ZzL2dmczIvdHJhbnMuYw0KQEAgLTE0NSwxNCArMTQ1
LDIyIEBAIHZvaWQgZ2ZzMl90cmFuc19hZGRfYmgoc3RydWN0IGdmczJfZ2xvY2sNCiAJc3RydWN0
IGdmczJfc2JkICpzZHAgPSBnbC0+Z2xfc2JkOw0KIAlzdHJ1Y3QgZ2ZzMl9idWZkYXRhICpiZDsN
CiANCisJbG9ja19idWZmZXIoYmgpOw0KKwlnZnMyX2xvZ19sb2NrKHNkcCk7DQogCWJkID0gYmgt
PmJfcHJpdmF0ZTsNCiAJaWYgKGJkKQ0KIAkJZ2ZzMl9hc3NlcnQoc2RwLCBiZC0+YmRfZ2wgPT0g
Z2wpOw0KIAllbHNlIHsNCisJCWdmczJfbG9nX3VubG9jayhzZHApOw0KKwkJdW5sb2NrX2J1ZmZl
cihiaCk7DQogCQlnZnMyX2F0dGFjaF9idWZkYXRhKGdsLCBiaCwgbWV0YSk7DQogCQliZCA9IGJo
LT5iX3ByaXZhdGU7DQorCQlsb2NrX2J1ZmZlcihiaCk7DQorCQlnZnMyX2xvZ19sb2NrKHNkcCk7
DQogCX0NCiAJbG9wc19hZGQoc2RwLCAmYmQtPmJkX2xlKTsNCisJZ2ZzMl9sb2dfdW5sb2NrKHNk
cCk7DQorCXVubG9ja19idWZmZXIoYmgpOw0KIH0NCiANCiB2b2lkIGdmczJfdHJhbnNfYWRkX3Jl
dm9rZShzdHJ1Y3QgZ2ZzMl9zYmQgKnNkcCwgc3RydWN0IGdmczJfYnVmZGF0YSAqYmQpDQo=


--=-SdmwbAn6MH8F5Yu8rlhX--

--=-RM4IOEnIueECv9qfdSxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPLHOOe/yOyVhhEJAQosng//R0ocY/LJPVbNhWXsKZNX1JZxoFj5AlzY
F/111z/YWJaYS7DnrQtipJ6CQMiUA5a9QyC+F/fuSTLzqAYgZmDiezBU+WauNWLm
qF0FnKzJvDs1RfsP1Z8oUmF8HOsypQ4a/FlGlBUkbQNGqEHn1zvbjLgwCs+5TdA3
1OjxwAFRGkZ2UkET7g/PBdVSiIKmQ9vHM8vGYDfpviefjqNy/PfL0kkxFJ+ijsz3
lbAmfdWxjSOX6dBaqYc3CN4Vo/fCXXqsB29YpED73nrqQDRAtpZt3R9CIDhIlhJV
hmB3dHyTbe6A//c/kt6GFyX8j6rkEcx3Iv5JsyGF+O3N4xyfKQYvOgk0lV5Lur+n
t7IDI4zrzNZZKOZoZP23kjpf1doOAAoSsKET2ZwTMFx91WF6EVhdBiQ6f+L1TlPF
1XDiy3ZuCH5hluz4FbIWdNUOd2fP+C8o9WQhvfLLFGwBS0amdMq29cUDAjLj/ALa
E/gnbG0cyNpKpt5G8+9ReVPCIPfje3ZxZjVK4OHdZqjJm7LhjCNI8ooYXKeX5zR+
C5s+5/kObnkscVWXRqtbMkxL0KbnptRhMV/naXKETmdotyl8J5pT2o24PxUbmltz
WHMd7k3G2+NxBK/NfeCtitrwaTulXOwBA2WDeANXvY0GrJCbTwGcwn2hKDKmEfbc
/NP4e8H3fR4=
=fzBK
-----END PGP SIGNATURE-----

--=-RM4IOEnIueECv9qfdSxM--
