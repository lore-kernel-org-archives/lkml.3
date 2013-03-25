Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab3CYTcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 15:32:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36672 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab3CYTb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 15:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <51502C87.8050902@digi.com>
References: <51502C87.8050902@digi.com>
Date: Mon, 25 Mar 2013 16:31:56 -0300
Message-ID: <CAOMZO5CWE-Q0Oh_LnP3ZOcnm5D68rJ6JGun=Tpq4EbS4TDQ+bw@mail.gmail.com>
Subject: Re: BUG: soft lockup when recording audio on MX28EVK with ASoC sgtl5000
From: Fabio Estevam <festevam@gmail.com>
To: Hector Palacios <hector.palacios@digi.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, alsa-devel@alsa-project.org,
        Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <b29396@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: multipart/mixed; boundary=089e01228e42a460d804d8c4db8f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01228e42a460d804d8c4db8f
Content-Type: text/plain; charset=UTF-8

Hi Hector,

On Mon, Mar 25, 2013 at 7:52 AM, Hector Palacios
<hector.palacios@digi.com> wrote:
> Hello,
>
> I just tried recording audio on Freescale's MX28EVK that uses ASoC sgtl5000
> (kernel v3.8) with:
>
>         arecord -M -f cd sound.wav --duration 10
>
> and got a scheduler message:
>
> [  789.041847] [sched_delayed] sched: RT throttling activated

I have just tested arecord on 3.8,4 and I haven't seen the 'soft lockup' bug.

However, I see that mxs saif gets busy after the record and any
attempt to do an 'aplay' after the first arecord fails.

With the attached patch applied I am able to do arecord/aplay sequence
several times.

I don't have a cable handy here to actually test if the sound is
recorded properly or not.

Could you please test it against 3.8.4?

Thanks,

Fabio Estevam

--089e01228e42a460d804d8c4db8f
Content-Type: application/octet-stream; name="0001-Do-not-check-busy.patch"
Content-Disposition: attachment; filename="0001-Do-not-check-busy.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_heq1708a0

RnJvbSBkZGU5OGJlZWMwZmZkZDg0ZDQ5N2I2MzkyM2NmMjZlOGM5YjBhNWM3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBGYWJpbyBFc3RldmFtIDxmYWJpby5lc3RldmFtQGZyZWVzY2Fs
ZS5jb20+CkRhdGU6IE1vbiwgMjUgTWFyIDIwMTMgMTY6MjM6MDQgLTAzMDAKU3ViamVjdDogW1BB
VENIXSBBU29DOiBteHMtc2FpZjogRG8gbm90IGNoZWNrIGZvciBCTV9TQUlGX1NUQVRfQlVTWQoK
U2lnbmVkLW9mZi1ieTogRmFiaW8gRXN0ZXZhbSA8ZmFiaW8uZXN0ZXZhbUBmcmVlc2NhbGUuY29t
PgotLS0KIHNvdW5kL3NvYy9teHMvbXhzLXNhaWYuYyB8ICAgMzAgKystLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyOCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9zb3VuZC9zb2MvbXhzL214cy1zYWlmLmMgYi9zb3VuZC9zb2Mv
bXhzL214cy1zYWlmLmMKaW5kZXggMzY1ZDlkMi4uMTk4NmRlYiAxMDA2NDQKLS0tIGEvc291bmQv
c29jL214cy9teHMtc2FpZi5jCisrKyBiL3NvdW5kL3NvYy9teHMvbXhzLXNhaWYuYwpAQCAtMjA3
LDE3ICsyMDcsMTAgQEAgc3RhdGljIGludCBteHNfc2FpZl9zZXRfY2xrKHN0cnVjdCBteHNfc2Fp
ZiAqc2FpZiwKIGludCBteHNfc2FpZl9wdXRfbWNsayh1bnNpZ25lZCBpbnQgc2FpZl9pZCkKIHsK
IAlzdHJ1Y3QgbXhzX3NhaWYgKnNhaWYgPSBteHNfc2FpZltzYWlmX2lkXTsKLQl1MzIgc3RhdDsK
IAogCWlmICghc2FpZikKIAkJcmV0dXJuIC1FSU5WQUw7CiAKLQlzdGF0ID0gX19yYXdfcmVhZGwo
c2FpZi0+YmFzZSArIFNBSUZfU1RBVCk7Ci0JaWYgKHN0YXQgJiBCTV9TQUlGX1NUQVRfQlVTWSkg
ewotCQlkZXZfZXJyKHNhaWYtPmRldiwgImVycm9yOiBidXN5XG4iKTsKLQkJcmV0dXJuIC1FQlVT
WTsKLQl9Ci0KIAljbGtfZGlzYWJsZV91bnByZXBhcmUoc2FpZi0+Y2xrKTsKIAogCS8qIGRpc2Fi
bGUgTUNMSyBvdXRwdXQgKi8KQEAgLTI0MSw3ICsyMzQsNiBAQCBpbnQgbXhzX3NhaWZfZ2V0X21j
bGsodW5zaWduZWQgaW50IHNhaWZfaWQsIHVuc2lnbmVkIGludCBtY2xrLAogCQkJCQl1bnNpZ25l
ZCBpbnQgcmF0ZSkKIHsKIAlzdHJ1Y3QgbXhzX3NhaWYgKnNhaWYgPSBteHNfc2FpZltzYWlmX2lk
XTsKLQl1MzIgc3RhdDsKIAlpbnQgcmV0OwogCXN0cnVjdCBteHNfc2FpZiAqbWFzdGVyX3NhaWY7
CiAKQEAgLTI2MiwxMiArMjU0LDYgQEAgaW50IG14c19zYWlmX2dldF9tY2xrKHVuc2lnbmVkIGlu
dCBzYWlmX2lkLCB1bnNpZ25lZCBpbnQgbWNsaywKIAkJcmV0dXJuIC1FSU5WQUw7CiAJfQogCi0J
c3RhdCA9IF9fcmF3X3JlYWRsKHNhaWYtPmJhc2UgKyBTQUlGX1NUQVQpOwotCWlmIChzdGF0ICYg
Qk1fU0FJRl9TVEFUX0JVU1kpIHsKLQkJZGV2X2VycihzYWlmLT5kZXYsICJlcnJvcjogYnVzeVxu
Iik7Ci0JCXJldHVybiAtRUJVU1k7Ci0JfQotCiAJc2FpZi0+bWNsa19pbl91c2UgPSAxOwogCXJl
dCA9IG14c19zYWlmX3NldF9jbGsoc2FpZiwgbWNsaywgcmF0ZSk7CiAJaWYgKHJldCkKQEAgLTI5
MSwxNiArMjc3LDEwIEBAIEVYUE9SVF9TWU1CT0xfR1BMKG14c19zYWlmX2dldF9tY2xrKTsKICAq
Lwogc3RhdGljIGludCBteHNfc2FpZl9zZXRfZGFpX2ZtdChzdHJ1Y3Qgc25kX3NvY19kYWkgKmNw
dV9kYWksIHVuc2lnbmVkIGludCBmbXQpCiB7Ci0JdTMyIHNjciwgc3RhdDsKKwl1MzIgc2NyOwog
CXUzMiBzY3IwOwogCXN0cnVjdCBteHNfc2FpZiAqc2FpZiA9IHNuZF9zb2NfZGFpX2dldF9kcnZk
YXRhKGNwdV9kYWkpOwogCi0Jc3RhdCA9IF9fcmF3X3JlYWRsKHNhaWYtPmJhc2UgKyBTQUlGX1NU
QVQpOwotCWlmIChzdGF0ICYgQk1fU0FJRl9TVEFUX0JVU1kpIHsKLQkJZGV2X2VycihjcHVfZGFp
LT5kZXYsICJlcnJvcjogYnVzeVxuIik7Ci0JCXJldHVybiAtRUJVU1k7Ci0JfQotCiAJc2NyMCA9
IF9fcmF3X3JlYWRsKHNhaWYtPmJhc2UgKyBTQUlGX0NUUkwpOwogCXNjcjAgPSBzY3IwICYgfkJN
X1NBSUZfQ1RSTF9CSVRDTEtfRURHRSAmIH5CTV9TQUlGX0NUUkxfTFJDTEtfUE9MQVJJVFkgXAog
CQkmIH5CTV9TQUlGX0NUUkxfSlVTVElGWSAmIH5CTV9TQUlGX0NUUkxfREVMQVk7CkBAIC0zOTcs
NyArMzc3LDcgQEAgc3RhdGljIGludCBteHNfc2FpZl9od19wYXJhbXMoc3RydWN0IHNuZF9wY21f
c3Vic3RyZWFtICpzdWJzdHJlYW0sCiB7CiAJc3RydWN0IG14c19zYWlmICpzYWlmID0gc25kX3Nv
Y19kYWlfZ2V0X2RydmRhdGEoY3B1X2RhaSk7CiAJc3RydWN0IG14c19zYWlmICptYXN0ZXJfc2Fp
ZjsKLQl1MzIgc2NyLCBzdGF0OworCXUzMiBzY3I7CiAJaW50IHJldDsKIAogCW1hc3Rlcl9zYWlm
ID0gbXhzX3NhaWZfZ2V0X21hc3RlcihzYWlmKTsKQEAgLTQxMCwxMiArMzkwLDYgQEAgc3RhdGlj
IGludCBteHNfc2FpZl9od19wYXJhbXMoc3RydWN0IHNuZF9wY21fc3Vic3RyZWFtICpzdWJzdHJl
YW0sCiAJCXJldHVybiAtRUlOVkFMOwogCX0KIAotCXN0YXQgPSBfX3Jhd19yZWFkbChzYWlmLT5i
YXNlICsgU0FJRl9TVEFUKTsKLQlpZiAoc3RhdCAmIEJNX1NBSUZfU1RBVF9CVVNZKSB7Ci0JCWRl
dl9lcnIoY3B1X2RhaS0+ZGV2LCAiZXJyb3I6IGJ1c3lcbiIpOwotCQlyZXR1cm4gLUVCVVNZOwot
CX0KLQogCS8qCiAJICogU2V0IHNhaWYgY2xrIGJhc2VkIG9uIHNhbXBsZSByYXRlLgogCSAqIElm
IG1jbGsgaXMgdXNlZCwgd2UgYWxzbyBzZXQgbWNsaywgaWYgbm90LCBzYWlmLT5tY2xrIGlzCi0t
IAoxLjcuOS41Cgo=
--089e01228e42a460d804d8c4db8f--
