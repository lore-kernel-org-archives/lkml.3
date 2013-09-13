Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab3IMQD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:03:28 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:50626 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3IMQD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130913155313.GA12758@n2100.arm.linux.org.uk>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<fd43341751c7a00d2f4eedf48d6338f866b26a52.1379063063.git.viresh.kumar@linaro.org>
	<20130913155313.GA12758@n2100.arm.linux.org.uk>
Date: Fri, 13 Sep 2013 21:33:26 +0530
Message-ID: <CAKohpo=az_vF8T5jdSLEeA+a1vk8AH7wS_2gTueUobgJ39jQnw@mail.gmail.com>
Subject: Re: [PATCH 181/228] cpufreq: move freq change notifications to
 cpufreq core
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: multipart/mixed; boundary=001a11c30350a6f81b04e645fe34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c30350a6f81b04e645fe34
Content-Type: text/plain; charset=ISO-8859-1

On 13 September 2013 21:23, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Sep 13, 2013 at 06:32:07PM +0530, Viresh Kumar wrote:
>> +             read_lock_irqsave(&cpufreq_driver_lock, flags);
>> +             notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
>> +             read_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
> I don't think this needs to be read under a lock - if this bit changes
> dynamically, then there's something very wrong.

No it doesn't change dynamically.. Was a mistake..
Following change folded into the original commit (attached)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2c1ae708..bb7402d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1802,7 +1802,6 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
        else if (cpufreq_driver->target_index) {
                struct cpufreq_frequency_table *freq_table;
                struct cpufreq_freqs freqs;
-               unsigned long flags;
                bool notify;
                int index;

@@ -1824,9 +1823,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
                        goto out;
                }

-               read_lock_irqsave(&cpufreq_driver_lock, flags);
                notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
-               read_unlock_irqrestore(&cpufreq_driver_lock, flags);

                if (notify) {
                        freqs.old = policy->cur;

--001a11c30350a6f81b04e645fe34
Content-Type: application/octet-stream; 
	name="0181-cpufreq-move-freq-change-notifications-to-cpufreq-co.patch"
Content-Disposition: attachment; 
	filename="0181-cpufreq-move-freq-change-notifications-to-cpufreq-co.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hljliauf0

RnJvbSBmMzRmYzlmNGUzOGRmMTlkZmY0MWJjNTI5ZDMzYWRlMWE4MGQwYmZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8ZjM0ZmM5ZjRlMzhkZjE5ZGZmNDFiYzUyOWQzM2Fk
ZTFhODBkMGJmYi4xMzc5MDg4MTM2LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogV2VkLCAxNCBBdWcg
MjAxMyAxOTozODoyNCArMDUzMApTdWJqZWN0OiBbUEFUQ0ggMTgxLzIyOF0gY3B1ZnJlcTogbW92
ZSBmcmVxIGNoYW5nZSBub3RpZmljYXRpb25zIHRvIGNwdWZyZXEgY29yZQoKTW9zdCBvZiB0aGUg
ZHJpdmVycyBkbyBmb2xsb3dpbmcgaW4gdGhlaXIgLT50YXJnZXRfaW5kZXgoKSByb3V0aW5lczoK
CglzdHJ1Y3QgY3B1ZnJlcV9mcmVxcyBmcmVxczsKCWZyZXFzLm9sZCA9IG9sZCBmcmVxLi4uCglm
cmVxcy5uZXcgPSBuZXcgZnJlcS4uLgoKCWNwdWZyZXFfbm90aWZ5X3RyYW5zaXRpb24ocG9saWN5
LCAmZnJlcXMsIENQVUZSRVFfUFJFQ0hBTkdFKTsKCgkvKiBDaGFuZ2UgcmF0ZSBoZXJlICovCgoJ
Y3B1ZnJlcV9ub3RpZnlfdHJhbnNpdGlvbihwb2xpY3ksICZmcmVxcywgQ1BVRlJFUV9QT1NUQ0hB
TkdFKTsKClRoaXMgaXMgcmVwbGljYXRlZCBvdmVyIGFsbCBjcHVmcmVxIGRyaXZlcnMgdG9kYXkg
YW5kIHRoZXJlIGRvZXNuJ3QgZXhpc3RzIGEKZ29vZCBlbm91Z2ggcmVhc29uIHdoeSB0aGlzIHNo
b3VsZG4ndCBiZSBtb3ZlZCB0byBjcHVmcmVxIGNvcmUgaW5zdGVhZC4KClRoZXJlIGFyZSBmZXcg
c3BlY2lhbCBjYXNlcyB0aG91Z2gsIGxpa2UgZXh5bm9zNTQ0MCwgd2hpY2ggZG9lc24ndCBkbyBl
dmVyeXRoaW5nCm9uIHRoZSBjYWxsIHRvIC0+dGFyZ2V0X2luZGV4KCkgcm91dGluZSBhbmQgY2Fs
bCBzb21lIGtpbmQgb2YgYm90dG9tIGhhbHZlcyBmb3IKZG9pbmcgdGhpcyB3b3JrLCB3b3JrL3Rh
c2tsZXQvZXRjLi4KClRoZXkgbWF5IGNvbnRpbnVlIGRvaW5nIG5vdGlmaWNhdGlvbiBmcm9tIHRo
ZWlyIG93biBjb2RlIGFuZCBzbyB0aGlzIHBhdGNoCmludHJvZHVjZXMgYW5vdGhlciBmbGFnOiBD
UFVGUkVRX0FTWU5DX05PVElGSUNBVElPTiwgd2hpY2ggd2lsbCBiZSBzZXQgYnkgc3VjaApkcml2
ZXJzLgoKU2lnbmVkLW9mZi1ieTogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9y
Zz4KLS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIHwgMzIgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAzMiBpbnNlcnRpb25zKCspCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVx
LmMKaW5kZXggM2ZkMjRiMS4uNzQ2YzhlMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9jcHVmcmVxL2Nw
dWZyZXEuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCkBAIC0xNzg3LDYgKzE3ODcs
OCBAQCBpbnQgX19jcHVmcmVxX2RyaXZlcl90YXJnZXQoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpw
b2xpY3ksCiAJCXJldHZhbCA9IGNwdWZyZXFfZHJpdmVyLT50YXJnZXQocG9saWN5LCB0YXJnZXRf
ZnJlcSwgcmVsYXRpb24pOwogCWVsc2UgaWYgKGNwdWZyZXFfZHJpdmVyLT50YXJnZXRfaW5kZXgp
IHsKIAkJc3RydWN0IGNwdWZyZXFfZnJlcXVlbmN5X3RhYmxlICpmcmVxX3RhYmxlOworCQlzdHJ1
Y3QgY3B1ZnJlcV9mcmVxcyBmcmVxczsKKwkJYm9vbCBub3RpZnk7CiAJCWludCBpbmRleDsKIAog
CQlmcmVxX3RhYmxlID0gY3B1ZnJlcV9mcmVxdWVuY3lfZ2V0X3RhYmxlKHBvbGljeS0+Y3B1KTsK
QEAgLTE4MDcsNyArMTgwOSwzNyBAQCBpbnQgX19jcHVmcmVxX2RyaXZlcl90YXJnZXQoc3RydWN0
IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiAJCQlnb3RvIG91dDsKIAkJfQogCisJCW5vdGlmeSA9
ICEoY3B1ZnJlcV9kcml2ZXItPmZsYWdzICYgQ1BVRlJFUV9BU1lOQ19OT1RJRklDQVRJT04pOwor
CisJCWlmIChub3RpZnkpIHsKKwkJCWZyZXFzLm9sZCA9IHBvbGljeS0+Y3VyOworCQkJZnJlcXMu
bmV3ID0gZnJlcV90YWJsZVtpbmRleF0uZnJlcXVlbmN5OworCQkJZnJlcXMuZmxhZ3MgPSAwOwor
CisJCQlwcl9kZWJ1ZygiJXM6IGNwdTogJWQsIG9sZGZyZXE6ICV1LCBuZXcgZnJlcTogJXVcbiIs
CisJCQkJCV9fZnVuY19fLCBwb2xpY3ktPmNwdSwgZnJlcXMub2xkLAorCQkJCQlmcmVxcy5uZXcp
OworCisJCQljcHVmcmVxX25vdGlmeV90cmFuc2l0aW9uKHBvbGljeSwgJmZyZXFzLAorCQkJCQlD
UFVGUkVRX1BSRUNIQU5HRSk7CisJCX0KKwogCQlyZXR2YWwgPSBjcHVmcmVxX2RyaXZlci0+dGFy
Z2V0X2luZGV4KHBvbGljeSwgaW5kZXgpOworCQlpZiAocmV0dmFsKQorCQkJcHJfZXJyKCIlczog
RmFpbGVkIHRvIGNoYW5nZSBjcHUgZnJlcXVlbmN5OiAlZFxuIiwKKwkJCQkJX19mdW5jX18sIHJl
dHZhbCk7CisKKwkJaWYgKG5vdGlmeSkgeworCQkJLyoKKwkJCSAqIE5vdGlmeSB3aXRoIG9sZCBm
cmVxIGluIGNhc2Ugd2UgZmFpbGVkIHRvIGNoYW5nZQorCQkJICogZnJlcXVlbmN5CisJCQkgKi8K
KwkJCWlmIChyZXR2YWwpCisJCQkJZnJlcXMubmV3ID0gZnJlcXMub2xkOworCisJCQljcHVmcmVx
X25vdGlmeV90cmFuc2l0aW9uKHBvbGljeSwgJmZyZXFzLAorCQkJCQlDUFVGUkVRX1BPU1RDSEFO
R0UpOworCQl9CiAJfQogCiBvdXQ6Ci0tIAoxLjcuMTIucmMyLjE4Lmc2MWI0NzJlCgo=
--001a11c30350a6f81b04e645fe34--
