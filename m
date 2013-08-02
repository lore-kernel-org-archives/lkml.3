Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3HBOjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:39:00 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:45596 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab3HBOi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:38:58 -0400
MIME-Version: 1.0
In-Reply-To: <5361062.ChI1FUI32W@vostro.rjw.lan>
References: <2362640.pUofnXyzOi@vostro.rjw.lan>
	<CAKohponru8Z1fod43dVtAODmYuMTGX70+73b8wk4wuGN=Vuh-w@mail.gmail.com>
	<CAKohpon7jyJWhf+j-M6Nuqy-AaY73YUpBpt-1uh12e_SYRv2bQ@mail.gmail.com>
	<5361062.ChI1FUI32W@vostro.rjw.lan>
Date: Fri, 2 Aug 2013 20:08:56 +0530
Message-ID: <CAKohpo=KhzFiiihCPfZ9kAm4rx1ZUfgWDJPQkhCgM5u2Gj3+uA@mail.gmail.com>
Subject: Re: [Update][PATCH] cpufreq: Do not hold driver module references for
 additional policy CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: multipart/mixed; boundary=089e0149d17a2cb8a804e2f7eb01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0149d17a2cb8a804e2f7eb01
Content-Type: text/plain; charset=ISO-8859-1

On 2 August 2013 19:01, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Care to add a changelog?
>
> I'll apply this on top of my $subject patch, then.

I thought you will merge this one with your patch, but there is no
harm in getting one more on my name :)

Changelog is (patch attached):

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Fri, 2 Aug 2013 16:17:33 +0530
Subject: [PATCH] cpufreq: Pass policy to cpufreq_add_policy_cpu()

Caller of cpufreq_add_policy_cpu() already has pointer to policy structure and
so there is no need to find it again in cpufreq_add_policy_cpu(). Lets pass it
directly.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--089e0149d17a2cb8a804e2f7eb01
Content-Type: application/octet-stream; 
	name="0001-cpufreq-Pass-policy-to-cpufreq_add_policy_cpu.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-Pass-policy-to-cpufreq_add_policy_cpu.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjvhzr4n0

RnJvbSBlNDJmY2VkNTA3NzJjZDI4OTNjY2NjNDg5OTBkZTEyM2U4MmZhOWJhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZTQyZmNlZDUwNzcyY2QyODkzY2NjYzQ4OTkwZGUx
MjNlODJmYTliYS4xMzc1NDU0Mjk4LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogRnJpLCAyIEF1ZyAy
MDEzIDE2OjE3OjMzICswNTMwClN1YmplY3Q6IFtQQVRDSF0gY3B1ZnJlcTogUGFzcyBwb2xpY3kg
dG8gY3B1ZnJlcV9hZGRfcG9saWN5X2NwdSgpCgpDYWxsZXIgb2YgY3B1ZnJlcV9hZGRfcG9saWN5
X2NwdSgpIGFscmVhZHkgaGFzIHBvaW50ZXIgdG8gcG9saWN5IHN0cnVjdHVyZSBhbmQKc28gdGhl
cmUgaXMgbm8gbmVlZCB0byBmaW5kIGl0IGFnYWluIGluIGNwdWZyZXFfYWRkX3BvbGljeV9jcHUo
KS4gTGV0cyBwYXNzIGl0CmRpcmVjdGx5LgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2
aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KLS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIHwg
MTggKysrKysrLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAx
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIGIv
ZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwppbmRleCA0NmU3MGFlLi40N2YyYTZlIDEwMDY0NAot
LS0gYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCisrKyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVm
cmVxLmMKQEAgLTg4OSwyMSArODg5LDE3IEBAIHN0YXRpYyB2b2lkIGNwdWZyZXFfaW5pdF9wb2xp
Y3koc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3kpCiB9CiAKICNpZmRlZiBDT05GSUdfSE9U
UExVR19DUFUKLXN0YXRpYyBpbnQgY3B1ZnJlcV9hZGRfcG9saWN5X2NwdSh1bnNpZ25lZCBpbnQg
Y3B1LCB1bnNpZ25lZCBpbnQgc2libGluZywKLQkJCQkgIHN0cnVjdCBkZXZpY2UgKmRldiwgYm9v
bCBmcm96ZW4pCitzdGF0aWMgaW50IGNwdWZyZXFfYWRkX3BvbGljeV9jcHUoc3RydWN0IGNwdWZy
ZXFfcG9saWN5ICpwb2xpY3ksCisJCQkJICB1bnNpZ25lZCBpbnQgY3B1LCBzdHJ1Y3QgZGV2aWNl
ICpkZXYsCisJCQkJICBib29sIGZyb3plbikKIHsKLQlzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBv
bGljeTsKIAlpbnQgcmV0ID0gMCwgaGFzX3RhcmdldCA9ICEhY3B1ZnJlcV9kcml2ZXItPnRhcmdl
dDsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwogCi0JcG9saWN5ID0gY3B1ZnJlcV9jcHVfZ2V0KHNp
YmxpbmcpOwotCWlmIChXQVJOX09OX09OQ0UoIXBvbGljeSkpCi0JCXJldHVybiAtRU5PREFUQTsK
LQogCWlmIChoYXNfdGFyZ2V0KQogCQlfX2NwdWZyZXFfZ292ZXJub3IocG9saWN5LCBDUFVGUkVR
X0dPVl9TVE9QKTsKIAotCWxvY2tfcG9saWN5X3J3c2VtX3dyaXRlKHNpYmxpbmcpOworCWxvY2tf
cG9saWN5X3J3c2VtX3dyaXRlKHBvbGljeS0+Y3B1KTsKIAogCXdyaXRlX2xvY2tfaXJxc2F2ZSgm
Y3B1ZnJlcV9kcml2ZXJfbG9jaywgZmxhZ3MpOwogCkBAIC05MTIsNyArOTA4LDcgQEAgc3RhdGlj
IGludCBjcHVmcmVxX2FkZF9wb2xpY3lfY3B1KHVuc2lnbmVkIGludCBjcHUsIHVuc2lnbmVkIGlu
dCBzaWJsaW5nLAogCXBlcl9jcHUoY3B1ZnJlcV9jcHVfZGF0YSwgY3B1KSA9IHBvbGljeTsKIAl3
cml0ZV91bmxvY2tfaXJxcmVzdG9yZSgmY3B1ZnJlcV9kcml2ZXJfbG9jaywgZmxhZ3MpOwogCi0J
dW5sb2NrX3BvbGljeV9yd3NlbV93cml0ZShzaWJsaW5nKTsKKwl1bmxvY2tfcG9saWN5X3J3c2Vt
X3dyaXRlKHBvbGljeS0+Y3B1KTsKIAogCWlmIChoYXNfdGFyZ2V0KSB7CiAJCV9fY3B1ZnJlcV9n
b3Zlcm5vcihwb2xpY3ksIENQVUZSRVFfR09WX1NUQVJUKTsKQEAgLTkyMyw3ICs5MTksNiBAQCBz
dGF0aWMgaW50IGNwdWZyZXFfYWRkX3BvbGljeV9jcHUodW5zaWduZWQgaW50IGNwdSwgdW5zaWdu
ZWQgaW50IHNpYmxpbmcsCiAJaWYgKCFmcm96ZW4pCiAJCXJldCA9IHN5c2ZzX2NyZWF0ZV9saW5r
KCZkZXYtPmtvYmosICZwb2xpY3ktPmtvYmosICJjcHVmcmVxIik7CiAKLQljcHVmcmVxX2NwdV9w
dXQocG9saWN5KTsKIAlyZXR1cm4gcmV0OwogfQogI2VuZGlmCkBAIC0xMDA2LDggKzEwMDEsNyBA
QCBzdGF0aWMgaW50IF9fY3B1ZnJlcV9hZGRfZGV2KHN0cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0
IHN1YnN5c19pbnRlcmZhY2UgKnNpZiwKIAkJc3RydWN0IGNwdWZyZXFfcG9saWN5ICpjcCA9IHBl
cl9jcHUoY3B1ZnJlcV9jcHVfZGF0YSwgc2libGluZyk7CiAJCWlmIChjcCAmJiBjcHVtYXNrX3Rl
c3RfY3B1KGNwdSwgY3AtPnJlbGF0ZWRfY3B1cykpIHsKIAkJCXJlYWRfdW5sb2NrX2lycXJlc3Rv
cmUoJmNwdWZyZXFfZHJpdmVyX2xvY2ssIGZsYWdzKTsKLQkJCXJldHVybiBjcHVmcmVxX2FkZF9w
b2xpY3lfY3B1KGNwdSwgc2libGluZywgZGV2LAotCQkJCQkJICAgICAgZnJvemVuKTsKKwkJCXJl
dHVybiBjcHVmcmVxX2FkZF9wb2xpY3lfY3B1KGNwLCBjcHUsIGRldiwgZnJvemVuKTsKIAkJfQog
CX0KIAlyZWFkX3VubG9ja19pcnFyZXN0b3JlKCZjcHVmcmVxX2RyaXZlcl9sb2NrLCBmbGFncyk7
Ci0tIAoxLjcuMTIucmMyLjE4Lmc2MWI0NzJlCgo=
--089e0149d17a2cb8a804e2f7eb01--
