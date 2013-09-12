Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3ILJWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 05:22:01 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:57270 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3ILJV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 05:21:59 -0400
MIME-Version: 1.0
In-Reply-To: <52316A40.4050600@linux.vnet.ibm.com>
References: <cover.1378963070.git.viresh.kumar@linaro.org>
	<8f777cc6b41b2fed4bf71ce2adc36800353d5738.1378963070.git.viresh.kumar@linaro.org>
	<523161D1.9040005@linux.vnet.ibm.com>
	<CAKohpomz-EDbRNqv58zn6B+kC1jdjrxx68hoDrAj==+YbeTj=g@mail.gmail.com>
	<CAKohpomCXoO20cQyCrWtN0WgWnzvVmEqFxuwTU8V0GpXsQxgHw@mail.gmail.com>
	<52316A40.4050600@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 14:51:58 +0530
Message-ID: <CAKohponzohnOL4Y81Q1W4Yg=paRO46c-gY=HMbkFUqgrjsT+xw@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8ff1ceb61053c404e62c45cb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8ff1ceb61053c404e62c45cb
Content-Type: text/plain; charset=ISO-8859-1

On 12 September 2013 12:46, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> That sounds good! Even the naming is much better, it conveys the intent
> clearly.

Folded below change in my patch (attached):

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index b556d46..23f5845 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1111,7 +1111,7 @@ static int
cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
        int ret;

        /* first sibling now owns the new sysfs dir */
-       cpu_dev = get_cpu_device(cpumask_first(policy->cpus));
+       cpu_dev = get_cpu_device(cpumask_any_but(policy->cpus, old_cpu));

        /* Don't touch sysfs files during light-weight tear-down */
        if (frozen)

--
thanks

--e89a8ff1ceb61053c404e62c45cb
Content-Type: application/octet-stream; 
	name="0001-cpufreq-use-correct-values-of-cpus-in-__cpufreq_remo.patch"
Content-Disposition: attachment; 
	filename="0001-cpufreq-use-correct-values-of-cpus-in-__cpufreq_remo.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlhrq4xs0

RnJvbSBhNjdiMGRhYWFiZDBlMThlMWE5MTJhMTY1MjFjNDA1YmMxN2JkZWQ5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8YTY3YjBkYWFhYmQwZTE4ZTFhOTEyYTE2NTIxYzQw
NWJjMTdiZGVkOS4xMzc4OTc3Njg5LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogVGh1LCAxMiBTZXAg
MjAxMyAxMDoyNTowMCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGNwdWZyZXE6IHVzZSBjb3JyZWN0
IHZhbHVlcyBvZiBjcHVzIGluCiBfX2NwdWZyZXFfcmVtb3ZlX2Rldl9maW5pc2goKQoKVGhpcyBi
cm9rZSBhZnRlciBhIHJlY2VudCBjaGFuZ2UgImNlZGI3MGEgY3B1ZnJlcTogU3BsaXQgX19jcHVm
cmVxX3JlbW92ZV9kZXYoKQppbnRvIHR3byBwYXJ0cyIgZnJvbSBTcml2YXRzYS4uCgpDb25zaWRl
ciBhIHNjZW5hcmlvIHdoZXJlIHdlIGhhdmUgdHdvIENQVXMgaW4gYSBwb2xpY3kgKDAgJiAxKSBh
bmQgd2UgYXJlCnJlbW92aW5nIGNwdSAxLiBPbiB0aGUgY2FsbCB0byBfX2NwdWZyZXFfcmVtb3Zl
X2Rldl9wcmVwYXJlKCkgd2UgaGF2ZSBjbGVhcmVkIDEKZnJvbSBwb2xpY3ktPmNwdXMgYW5kIG5v
dyBvbiBhIGNhbGwgdG8gX19jcHVmcmVxX3JlbW92ZV9kZXZfZmluaXNoKCkgd2UgcmVhZApjcHVt
YXNrX3dlaWdodCBvZiBwb2xpY3ktPmNwdXMsIHdoaWNoIHdpbGwgY29tZSBhcyAxIGFuZCB0aGlz
IGNvZGUgd2lsbCBiZWhhdmUKYXMgaWYgd2UgYXJlIHJlbW92aW5nIHRoZSBsYXN0IGNwdSBmcm9t
IHBvbGljeSA6KQoKRml4IGl0IGJ5IGNsZWFyaW5nIGNwdSBtYXNrIGluIF9fY3B1ZnJlcV9yZW1v
dmVfZGV2X2ZpbmlzaCgpIGluc3RlYWQgb2YKX19jcHVmcmVxX3JlbW92ZV9kZXZfcHJlcGFyZSgp
LgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4K
LS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIHwgMTYgKysrKysrKystLS0tLS0tLQogMSBm
aWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwpp
bmRleCAwZTExZmNiLi4yM2Y1ODQ1IDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJl
cS5jCisrKyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMKQEAgLTExMTEsNyArMTExMSw3IEBA
IHN0YXRpYyBpbnQgY3B1ZnJlcV9ub21pbmF0ZV9uZXdfcG9saWN5X2NwdShzdHJ1Y3QgY3B1ZnJl
cV9wb2xpY3kgKnBvbGljeSwKIAlpbnQgcmV0OwogCiAJLyogZmlyc3Qgc2libGluZyBub3cgb3du
cyB0aGUgbmV3IHN5c2ZzIGRpciAqLwotCWNwdV9kZXYgPSBnZXRfY3B1X2RldmljZShjcHVtYXNr
X2ZpcnN0KHBvbGljeS0+Y3B1cykpOworCWNwdV9kZXYgPSBnZXRfY3B1X2RldmljZShjcHVtYXNr
X2FueV9idXQocG9saWN5LT5jcHVzLCBvbGRfY3B1KSk7CiAKIAkvKiBEb24ndCB0b3VjaCBzeXNm
cyBmaWxlcyBkdXJpbmcgbGlnaHQtd2VpZ2h0IHRlYXItZG93biAqLwogCWlmIChmcm96ZW4pCkBA
IC0xMTc1LDEyICsxMTc1LDkgQEAgc3RhdGljIGludCBfX2NwdWZyZXFfcmVtb3ZlX2Rldl9wcmVw
YXJlKHN0cnVjdCBkZXZpY2UgKmRldiwKIAkJCXBvbGljeS0+Z292ZXJub3ItPm5hbWUsIENQVUZS
RVFfTkFNRV9MRU4pOwogI2VuZGlmCiAKLQlXQVJOX09OKGxvY2tfcG9saWN5X3J3c2VtX3dyaXRl
KGNwdSkpOworCWxvY2tfcG9saWN5X3J3c2VtX3JlYWQoY3B1KTsKIAljcHVzID0gY3B1bWFza193
ZWlnaHQocG9saWN5LT5jcHVzKTsKLQotCWlmIChjcHVzID4gMSkKLQkJY3B1bWFza19jbGVhcl9j
cHUoY3B1LCBwb2xpY3ktPmNwdXMpOwotCXVubG9ja19wb2xpY3lfcndzZW1fd3JpdGUoY3B1KTsK
Kwl1bmxvY2tfcG9saWN5X3J3c2VtX3JlYWQoY3B1KTsKIAogCWlmIChjcHUgIT0gcG9saWN5LT5j
cHUpIHsKIAkJaWYgKCFmcm96ZW4pCkBAIC0xMjIyLDkgKzEyMTksMTIgQEAgc3RhdGljIGludCBf
X2NwdWZyZXFfcmVtb3ZlX2Rldl9maW5pc2goc3RydWN0IGRldmljZSAqZGV2LAogCQlyZXR1cm4g
LUVJTlZBTDsKIAl9CiAKLQlsb2NrX3BvbGljeV9yd3NlbV9yZWFkKGNwdSk7CisJV0FSTl9PTihs
b2NrX3BvbGljeV9yd3NlbV93cml0ZShjcHUpKTsKIAljcHVzID0gY3B1bWFza193ZWlnaHQocG9s
aWN5LT5jcHVzKTsKLQl1bmxvY2tfcG9saWN5X3J3c2VtX3JlYWQoY3B1KTsKKworCWlmIChjcHVz
ID4gMSkKKwkJY3B1bWFza19jbGVhcl9jcHUoY3B1LCBwb2xpY3ktPmNwdXMpOworCXVubG9ja19w
b2xpY3lfcndzZW1fd3JpdGUoY3B1KTsKIAogCS8qIElmIGNwdSBpcyBsYXN0IHVzZXIgb2YgcG9s
aWN5LCBmcmVlIHBvbGljeSAqLwogCWlmIChjcHVzID09IDEpIHsKLS0gCjEuNy4xMi5yYzIuMTgu
ZzYxYjQ3MmUKCg==
--e89a8ff1ceb61053c404e62c45cb--
