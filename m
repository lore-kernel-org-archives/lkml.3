Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3JSLc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 07:32:56 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18421 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3JSLcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 07:32:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 19 Oct 2013 04:28:22 -0700
From: Vishal Annapurve <vannapurve@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Date: Sat, 19 Oct 2013 17:02:40 +0530
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result
Thread-Topic: [PATCH] usb-storage: scsiglue: Changing the command result
Thread-Index: Ac7MC8ZxJAgu6RB7TuebryWb8hTwlgArp5YQ
Message-ID: <113ACA888B71994BB56E5CF3704953486D65F419AE@BGMAIL02.nvidia.com>
References: <113ACA888B71994BB56E5CF3704953486D65F41715@BGMAIL02.nvidia.com>
 <Pine.LNX.4.44L0.1310181002190.1164-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1310181002190.1164-100000@iolanthe.rowland.org>
Accept-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/mixed;
	boundary="_002_113ACA888B71994BB56E5CF3704953486D65F419AEBGMAIL02nvidi_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_113ACA888B71994BB56E5CF3704953486D65F419AEBGMAIL02nvidi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

Attaching the new patch which will replace all the occurrences of DID_ABORT
with DID_TIMOUT in USB Storage whenever it sees US_FLIDX_TIMED_OUT bit
is set.
=20
Regards,
Vishal

-----Original Message-----
From: Alan Stern [mailto:stern@rowland.harvard.edu]=20
Sent: Friday, October 18, 2013 4:10 PM
To: Vishal Annapurve
Cc: Ming Lei; Linux Kernel Mailing List; linux-usb
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result

On Fri, 18 Oct 2013, Vishal Annapurve wrote:

> Hi Alan,
>=20
> What I wanted to say was If the bit US_FLIDX_TIMED_OUT can have more=20
> meanings than timed out then maybe it would be best to override the=20
> results after usb-storage is done with the command maybe in scsi layer=20
> itself who aborted it in the first place.

US_FLIDX_TIMED_OUT has one very specific meaning: command_abort() was calle=
d.

Since command_abort() is the .eh_abort_handler routine, US_FLIDX_TIMED_OUT =
means that the SCSI layer decided to abort the command.

Does the SCSI layer ever abort a command for any reason other than a timeou=
t?  If not, you may conclude that US_FLIDX_TIMED_OUT indicates a timeout.  =
But if it does, you should not make this conclusion.

> My concern was that overriding the result in usb storage or scsi=20
> layers will have more side effects than doing it in scsiglue.c.
> And by scsi-usb storage bridge what I meant was specifically the code=20
> in scsiglue.
>=20
> Question about your last mail, do you want to change all the=20
> occurrences of DID_ABORT from usb-storage to DID_TIMEOUT?

Put it this way: There's no good reason for changing some of them but not a=
ll of them.

And if you're going to change them at all, it makes no sense to first set t=
he result to DID_ABORT and then change it to DID_TIMEOUT.  You should simpl=
y set it to DID_TIMEOUT in the first place.

Alan Stern


--_002_113ACA888B71994BB56E5CF3704953486D65F419AEBGMAIL02nvidi_
Content-Type: application/octet-stream;
	name="usb_storage_change_abort_to_timeout.patch"
Content-Description: usb_storage_change_abort_to_timeout.patch
Content-Disposition: attachment;
	modification-date="Sat, 19 Oct 2013 11:31:24 GMT";
	creation-date="Sat, 19 Oct 2013 10:52:10 GMT"; size=2754;
	filename="usb_storage_change_abort_to_timeout.patch"
Content-Transfer-Encoding: base64

RnJvbTogVmlzaGFsIEFubmFwdXJ2ZSA8dmFubmFwdXJ2ZUBudmlkaWEuY29tPgpTdWJqZWN0OiBb
UEFUQ0hdIHVzYjogc3RvcmFnZTogUHJvcGVyIGNtZCByZXN1bHQgYXNzaWdubWVudAoKVGhpcyBj
aGFuZ2UgcmVwbGFjZXMgRElEX0FCT1JUIHdpdGggRElEX1RJTUVPVVQgZnJvbQp1c2Igc3RvcmFn
ZSBhc3N1bWluZyB0aGF0IHRoZSBjb21tYW5kIHdpbGwgZ2V0IGFib3J0ZWQKb25seSBpbiBjYXNl
IG9mIHRpbWVvdXQuCgpTaWduZWQtb2ZmLWJ5OiBWaXNoYWwgQW5uYXB1cnZlIDx2YW5uYXB1cnZl
QG52aWRpYS5jb20+Ci0tLQogZHJpdmVycy91c2Ivc3RvcmFnZS90cmFuc3BvcnQuYyB8IDggKysr
Ky0tLS0KIGRyaXZlcnMvdXNiL3N0b3JhZ2UvdXNiLmMgICAgICAgfCA4ICsrKystLS0tCiAyIGZp
bGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3VzYi9zdG9yYWdlL3RyYW5zcG9ydC5jIGIvZHJpdmVycy91c2Ivc3RvcmFnZS90
cmFuc3BvcnQuYwppbmRleCBiMjY5N2RjLi5mNjhlNGM2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Vz
Yi9zdG9yYWdlL3RyYW5zcG9ydC5jCisrKyBiL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdHJhbnNwb3J0
LmMKQEAgLTYwOCw4ICs2MDgsOCBAQCB2b2lkIHVzYl9zdG9yX2ludm9rZV90cmFuc3BvcnQoc3Ry
dWN0IHNjc2lfY21uZCAqc3JiLCBzdHJ1Y3QgdXNfZGF0YSAqdXMpCiAJICogc2hvcnQtY2lyY3Vp
dCBhbGwgb3RoZXIgcHJvY2Vzc2luZwogCSAqLwogCWlmICh0ZXN0X2JpdChVU19GTElEWF9USU1F
RF9PVVQsICZ1cy0+ZGZsYWdzKSkgewotCQlVU19ERUJVR1AoIi0tIGNvbW1hbmQgd2FzIGFib3J0
ZWRcbiIpOwotCQlzcmItPnJlc3VsdCA9IERJRF9BQk9SVCA8PCAxNjsKKwkJVVNfREVCVUdQKCIt
LSBjb21tYW5kIHdhcyBhYm9ydGVkIGJlY2F1c2Ugb2YgdGltZW91dFxuIik7CisJCXNyYi0+cmVz
dWx0ID0gRElEX1RJTUVfT1VUIDw8IDE2OwogCQlnb3RvIEhhbmRsZV9FcnJvcnM7CiAJfQogCkBA
IC03MjEsOCArNzIxLDggQEAgUmV0cnlfU2Vuc2U6CiAJCXNjc2lfZWhfcmVzdG9yZV9jbW5kKHNy
YiwgJnNlcyk7CiAKIAkJaWYgKHRlc3RfYml0KFVTX0ZMSURYX1RJTUVEX09VVCwgJnVzLT5kZmxh
Z3MpKSB7Ci0JCQlVU19ERUJVR1AoIi0tIGF1dG8tc2Vuc2UgYWJvcnRlZFxuIik7Ci0JCQlzcmIt
PnJlc3VsdCA9IERJRF9BQk9SVCA8PCAxNjsKKwkJCVVTX0RFQlVHUCgiLS0gYXV0by1zZW5zZSBh
Ym9ydGVkIGR1ZSB0byB0aW1lb3V0XG4iKTsKKwkJCXNyYi0+cmVzdWx0ID0gRElEX1RJTUVfT1VU
IDw8IDE2OwogCiAJCQkvKiBJZiBTQU5FX1NFTlNFIGNhdXNlZCB0aGlzIHByb2JsZW0sIGRpc2Fi
bGUgaXQgKi8KIAkJCWlmIChzZW5zZV9zaXplICE9IFVTX1NFTlNFX1NJWkUpIHsKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdXNiL3N0b3JhZ2UvdXNiLmMgYi9kcml2ZXJzL3VzYi9zdG9yYWdlL3VzYi5j
CmluZGV4IGMwZDA5MTUuLjI2MzEyM2IgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdXNiL3N0b3JhZ2Uv
dXNiLmMKKysrIGIvZHJpdmVycy91c2Ivc3RvcmFnZS91c2IuYwpAQCAtMjkwLDcgKzI5MCw3IEBA
IHN0YXRpYyBpbnQgdXNiX3N0b3JfY29udHJvbF90aHJlYWQodm9pZCAqIF9fdXMpCiAKIAkJLyog
aGFzIHRoZSBjb21tYW5kIHRpbWVkIG91dCAqYWxyZWFkeSogPyAqLwogCQlpZiAodGVzdF9iaXQo
VVNfRkxJRFhfVElNRURfT1VULCAmdXMtPmRmbGFncykpIHsKLQkJCXVzLT5zcmItPnJlc3VsdCA9
IERJRF9BQk9SVCA8PCAxNjsKKwkJCXVzLT5zcmItPnJlc3VsdCA9IERJRF9USU1FX09VVCA8PCAx
NjsKIAkJCWdvdG8gU2tpcEZvckFib3J0OwogCQl9CiAKQEAgLTM0NCwxOCArMzQ0LDE4IEBAIHN0
YXRpYyBpbnQgdXNiX3N0b3JfY29udHJvbF90aHJlYWQodm9pZCAqIF9fdXMpCiAJCXNjc2lfbG9j
ayhob3N0KTsKIAogCQkvKiBpbmRpY2F0ZSB0aGF0IHRoZSBjb21tYW5kIGlzIGRvbmUgKi8KLQkJ
aWYgKHVzLT5zcmItPnJlc3VsdCAhPSBESURfQUJPUlQgPDwgMTYpIHsKKwkJaWYgKHVzLT5zcmIt
PnJlc3VsdCAhPSBESURfVElNRV9PVVQgPDwgMTYpIHsKIAkJCVVTX0RFQlVHUCgic2NzaSBjbWQg
ZG9uZSwgcmVzdWx0PTB4JXhcbiIsIAogCQkJCSAgIHVzLT5zcmItPnJlc3VsdCk7CiAJCQl1cy0+
c3JiLT5zY3NpX2RvbmUodXMtPnNyYik7CiAJCX0gZWxzZSB7CiBTa2lwRm9yQWJvcnQ6Ci0JCQlV
U19ERUJVR1AoInNjc2kgY29tbWFuZCBhYm9ydGVkXG4iKTsKKwkJCVVTX0RFQlVHUCgic2NzaSBj
b21tYW5kIGFib3J0ZWQgZHVlIHRvIHRpbWVvdXRcbiIpOwogCQl9CiAKIAkJLyogSWYgYW4gYWJv
cnQgcmVxdWVzdCB3YXMgcmVjZWl2ZWQgd2UgbmVlZCB0byBzaWduYWwgdGhhdAogCQkgKiB0aGUg
YWJvcnQgaGFzIGZpbmlzaGVkLiAgVGhlIHByb3BlciB0ZXN0IGZvciB0aGlzIGlzCi0JCSAqIHRo
ZSBUSU1FRF9PVVQgZmxhZywgbm90IHNyYi0+cmVzdWx0ID09IERJRF9BQk9SVCwgYmVjYXVzZQor
CQkgKiB0aGUgVElNRURfT1VUIGZsYWcsIG5vdCBzcmItPnJlc3VsdCA9PSBESURfVElNRV9PVVQs
IGJlY2F1c2UKIAkJICogdGhlIHRpbWVvdXQgbWlnaHQgaGF2ZSBvY2N1cnJlZCBhZnRlciB0aGUg
Y29tbWFuZCBoYWQKIAkJICogYWxyZWFkeSBjb21wbGV0ZWQgd2l0aCBhIGRpZmZlcmVudCByZXN1
bHQgY29kZS4gKi8KIAkJaWYgKHRlc3RfYml0KFVTX0ZMSURYX1RJTUVEX09VVCwgJnVzLT5kZmxh
Z3MpKSB7Ci0tIAoxLjguNAoK

--_002_113ACA888B71994BB56E5CF3704953486D65F419AEBGMAIL02nvidi_--
