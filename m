Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3ASQpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 11:45:55 -0500
Received: from [207.46.163.27] ([207.46.163.27]:38421 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751949Ab3ASQpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 11:45:54 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371Ic85fh542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd25hf0ah1288h12a5h12bdh137ah1441h1504h1537h153bh15d0h162dh1631h1758h34h1155h)
X-WSS-ID: 0MGVT6F-01-0BG-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Shuah Khan <shuahkhan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: Linux 3.8-rc4
Thread-Topic: Linux 3.8-rc4
Thread-Index: AQHN9cxhktnF6ESNpkuAIBoIzsaQJZhQNCEAgACn4tA=
Date: Sat, 19 Jan 2013 16:44:39 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7@sausexdag04.amd.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
	<CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
 <CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
In-Reply-To: <CAKocOOOpDb=0XgX-uhDbBjOF7qK_M5MA31q9ScD0yTat0QRquQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.226.128.4]
Content-Type: multipart/mixed;
	boundary="_002_A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7sausexdag04amdc_"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7sausexdag04amdc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Shuah Khan [mailto:shuahkhan@gmail.com]
> Sent: Friday, January 18, 2013 7:40 PM
> To: Linus Torvalds; Deucher, Alexander
> Cc: Linux Kernel Mailing List
> Subject: Re: Linux 3.8-rc4
>=20
> On Fri, Jan 18, 2013 at 3:37 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
> > On Fri, Jan 18, 2013 at 10:51 AM, Shuah Khan <shuahkhan@gmail.com>
> wrote:
>=20
> >
> > ok. I bisected the DMAR faults and it points to the following commit:
> >
> > 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb
> >
> > This commit as I recall, fixed the crash problem I was seeing back in
> > 3.8-rc1. Reverting to see if crash problem reappears.
>=20
> Confirming that with this commit reverted crash problem re-appeared.
> With this commit, DMAR faults show up.

I'm not quite sure what's going on with your system.   At this point it's p=
robably best to just disable the DMA ring on these cards until we sort out =
what's going on.  The attached patch disables the use of the DMA ring.  Let=
 me know if it fixes the issues you are seeing.

Alex


--_002_A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7sausexdag04amdc_
Content-Type: application/octet-stream; name="disable_dma_ring_on_6xx.diff"
Content-Description: disable_dma_ring_on_6xx.diff
Content-Disposition: attachment; filename="disable_dma_ring_on_6xx.diff";
	size=1549; creation-date="Sat, 19 Jan 2013 16:43:44 GMT";
	modification-date="Sat, 19 Jan 2013 16:40:55 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2FzaWMuYyBiL2RyaXZl
cnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2FzaWMuYwppbmRleCA5MDU2ZmFmLi5iMGNjNDZkIDEw
MDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9hc2ljLmMKKysrIGIvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fYXNpYy5jCkBAIC05NzQsOCArOTc0LDggQEAgc3Rh
dGljIHN0cnVjdCByYWRlb25fYXNpYyByNjAwX2FzaWMgPSB7CiAJCS5ibGl0X3JpbmdfaW5kZXgg
PSBSQURFT05fUklOR19UWVBFX0dGWF9JTkRFWCwKIAkJLmRtYSA9ICZyNjAwX2NvcHlfZG1hLAog
CQkuZG1hX3JpbmdfaW5kZXggPSBSNjAwX1JJTkdfVFlQRV9ETUFfSU5ERVgsCi0JCS5jb3B5ID0g
JnI2MDBfY29weV9kbWEsCi0JCS5jb3B5X3JpbmdfaW5kZXggPSBSNjAwX1JJTkdfVFlQRV9ETUFf
SU5ERVgsCisJCS5jb3B5ID0gJnI2MDBfY29weV9ibGl0LAorCQkuY29weV9yaW5nX2luZGV4ID0g
UkFERU9OX1JJTkdfVFlQRV9HRlhfSU5ERVgsCiAJfSwKIAkuc3VyZmFjZSA9IHsKIAkJLnNldF9y
ZWcgPSByNjAwX3NldF9zdXJmYWNlX3JlZywKQEAgLTEwNTgsOCArMTA1OCw4IEBAIHN0YXRpYyBz
dHJ1Y3QgcmFkZW9uX2FzaWMgcnM3ODBfYXNpYyA9IHsKIAkJLmJsaXRfcmluZ19pbmRleCA9IFJB
REVPTl9SSU5HX1RZUEVfR0ZYX0lOREVYLAogCQkuZG1hID0gJnI2MDBfY29weV9kbWEsCiAJCS5k
bWFfcmluZ19pbmRleCA9IFI2MDBfUklOR19UWVBFX0RNQV9JTkRFWCwKLQkJLmNvcHkgPSAmcjYw
MF9jb3B5X2RtYSwKLQkJLmNvcHlfcmluZ19pbmRleCA9IFI2MDBfUklOR19UWVBFX0RNQV9JTkRF
WCwKKwkJLmNvcHkgPSAmcjYwMF9jb3B5X2JsaXQsCisJCS5jb3B5X3JpbmdfaW5kZXggPSBSQURF
T05fUklOR19UWVBFX0dGWF9JTkRFWCwKIAl9LAogCS5zdXJmYWNlID0gewogCQkuc2V0X3JlZyA9
IHI2MDBfc2V0X3N1cmZhY2VfcmVnLApkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVv
bi9yYWRlb25fY3MuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2NzLmMKaW5kZXgg
NDY5NjYxZi4uZmE3ZjM3NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRl
b25fY3MuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9jcy5jCkBAIC0xMTgs
NyArMTE4LDcgQEAgc3RhdGljIGludCByYWRlb25fY3NfZ2V0X3Jpbmcoc3RydWN0IHJhZGVvbl9j
c19wYXJzZXIgKnAsIHUzMiByaW5nLCBzMzIgcHJpb3JpdHkKIAkJCQlwLT5yaW5nID0gUjYwMF9S
SU5HX1RZUEVfRE1BX0lOREVYOwogCQkJZWxzZQogCQkJCXAtPnJpbmcgPSBDQVlNQU5fUklOR19U
WVBFX0RNQTFfSU5ERVg7Ci0JCX0gZWxzZSBpZiAocC0+cmRldi0+ZmFtaWx5ID49IENISVBfUjYw
MCkgeworCQl9IGVsc2UgaWYgKHAtPnJkZXYtPmZhbWlseSA+PSBDSElQX1JWNzcwKSB7CiAJCQlw
LT5yaW5nID0gUjYwMF9SSU5HX1RZUEVfRE1BX0lOREVYOwogCQl9IGVsc2UgewogCQkJcmV0dXJu
IC1FSU5WQUw7Cg==

--_002_A3397C8B8B789E45844E7EC5DEAD89D02DC30FE7sausexdag04amdc_--
