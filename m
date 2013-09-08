Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab3IHVdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 17:33:06 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:58097 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3IHVdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 17:33:04 -0400
MIME-Version: 1.0
In-Reply-To: <1378675264-3005-1-git-send-email-tobias.johannes.klausmann@mni.thm.de>
References: <CAKb7UviRb_ao_nB8Q3pa9ePm+yUGd8u7PDREv5wNfCheyGTZjQ@mail.gmail.com>
	<1378675264-3005-1-git-send-email-tobias.johannes.klausmann@mni.thm.de>
Date: Mon, 9 Sep 2013 07:33:02 +1000
Message-ID: <CAPM=9tyCOdzC1NYy7jt+zh3WOuzubaO3b8vwFVast9ec=BWOkA@mail.gmail.com>
Subject: Re: [Nouveau] 3.12rc1-pre Nouveau? oops
From: Dave Airlie <airlied@gmail.com>
To: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, Dave Airlie <airlied@linux.ie>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c379ec32522b04e5e60426
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c379ec32522b04e5e60426
Content-Type: text/plain; charset=ISO-8859-1

>> Looks like you have Optimus (intel + nvidia), and the backtrace has
>> runtime pm in it, which is something new Dave added for 3.12, adding
>> him in explicitly. The simplest explanation is that disp->init is
>> NULL. And it seems like there are no outputs from the earlier nouveau
>> init prints. I guess that the call to nouveau_display_resume from
>> nouveau_pmops_runtime_resume should be guarded by a if
>> (dev->mode_config.num_crtc) like it is everywhere else.
>>
>>   -ilia
>
> Your guess was right, this (hopefully attached patch) fixes it for me!

Does it look like this one?

Dave.

--001a11c379ec32522b04e5e60426
Content-Type: application/octet-stream; 
	name="0001-drm-nouveau-fix-oops-on-runtime-suspend-resume.patch"
Content-Disposition: attachment; 
	filename="0001-drm-nouveau-fix-oops-on-runtime-suspend-resume.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlcs2cpf0

RnJvbSA3NWRmMmFjZTc3MGY5YzE2MjliZjUyZGRlYTQyOGM0MWY0YWRiNDFjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEBnbWFpbC5jb20+CkRhdGU6
IE1vbiwgOSBTZXAgMjAxMyAwNzozMDo1NiArMTAwMApTdWJqZWN0OiBbUEFUQ0hdIGRybS9ub3V2
ZWF1OiBmaXggb29wcyBvbiBydW50aW1lIHN1c3BlbmQvcmVzdW1lCgppZiB3ZSBoYXZlIG5vIGNy
dGNzIHdlIG5lZWQgdG8gbm90IGNhbGwgdGhlIGRpc3BsYXkgcmVzdW1lIGNvZGUuCgpSZXBvcnRl
ZC1ieTogVG9iaWFzIEtsYXVzbWFubiA8dG9iaWFzLmpvaGFubmVzLmtsYXVzbWFubkBtbmkudGht
LmRlPgpTaWduZWQtb2ZmLWJ5OiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgotLS0K
IGRyaXZlcnMvZ3B1L2RybS9ub3V2ZWF1L25vdXZlYXVfZHJtLmMgfCA5ICsrKysrKy0tLQogMSBm
aWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2dwdS9kcm0vbm91dmVhdS9ub3V2ZWF1X2RybS5jIGIvZHJpdmVycy9ncHUvZHJt
L25vdXZlYXUvbm91dmVhdV9kcm0uYwppbmRleCA4ODYzNjQ0Li5lODkzYzUzIDEwMDY0NAotLS0g
YS9kcml2ZXJzL2dwdS9kcm0vbm91dmVhdS9ub3V2ZWF1X2RybS5jCisrKyBiL2RyaXZlcnMvZ3B1
L2RybS9ub3V2ZWF1L25vdXZlYXVfZHJtLmMKQEAgLTYzNiw3ICs2MzYsOCBAQCBpbnQgbm91dmVh
dV9wbW9wc19yZXN1bWUoc3RydWN0IGRldmljZSAqZGV2KQogCQlub3V2ZWF1X2ZiY29uX3NldF9z
dXNwZW5kKGRybV9kZXYsIDApOwogCiAJbm91dmVhdV9mYmNvbl96ZmlsbF9hbGwoZHJtX2Rldik7
Ci0Jbm91dmVhdV9kaXNwbGF5X3Jlc3VtZShkcm1fZGV2KTsKKwlpZiAoZHJtX2Rldi0+bW9kZV9j
b25maWcubnVtX2NydGMpCisJCW5vdXZlYXVfZGlzcGxheV9yZXN1bWUoZHJtX2Rldik7CiAJbnZf
c3VzcGVuZF9zZXRfcHJpbnRrX2xldmVsKE5WX0RCR19ERUJVRyk7CiAJcmV0dXJuIDA7CiB9CkBA
IC02NzEsNyArNjcyLDggQEAgc3RhdGljIGludCBub3V2ZWF1X3Btb3BzX3RoYXcoc3RydWN0IGRl
dmljZSAqZGV2KQogCWlmIChkcm1fZGV2LT5tb2RlX2NvbmZpZy5udW1fY3J0YykKIAkJbm91dmVh
dV9mYmNvbl9zZXRfc3VzcGVuZChkcm1fZGV2LCAwKTsKIAlub3V2ZWF1X2ZiY29uX3pmaWxsX2Fs
bChkcm1fZGV2KTsKLQlub3V2ZWF1X2Rpc3BsYXlfcmVzdW1lKGRybV9kZXYpOworCWlmIChkcm1f
ZGV2LT5tb2RlX2NvbmZpZy5udW1fY3J0YykKKwkJbm91dmVhdV9kaXNwbGF5X3Jlc3VtZShkcm1f
ZGV2KTsKIAludl9zdXNwZW5kX3NldF9wcmludGtfbGV2ZWwoTlZfREJHX0RFQlVHKTsKIAlyZXR1
cm4gMDsKIH0KQEAgLTkwNiw3ICs5MDgsOCBAQCBzdGF0aWMgaW50IG5vdXZlYXVfcG1vcHNfcnVu
dGltZV9yZXN1bWUoc3RydWN0IGRldmljZSAqZGV2KQogCXBjaV9zZXRfbWFzdGVyKHBkZXYpOwog
CiAJcmV0ID0gbm91dmVhdV9kb19yZXN1bWUoZHJtX2Rldik7Ci0Jbm91dmVhdV9kaXNwbGF5X3Jl
c3VtZShkcm1fZGV2KTsKKwlpZiAoZHJtX2Rldi0+bW9kZV9jb25maWcubnVtX2NydGMpCisJCW5v
dXZlYXVfZGlzcGxheV9yZXN1bWUoZHJtX2Rldik7CiAJZHJtX2ttc19oZWxwZXJfcG9sbF9lbmFi
bGUoZHJtX2Rldik7CiAJLyogZG8gbWFnaWMgKi8KIAludl9tYXNrKGRldmljZSwgMHg4ODQ4OCwg
KDEgPDwgMjUpLCAoMSA8PCAyNSkpOwotLSAKMS44LjEuNAoK
--001a11c379ec32522b04e5e60426--
