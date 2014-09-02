Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaIBSFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:05:51 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:51556 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaIBSFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:05:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140902170726.GF5001@linux.vnet.ibm.com>
References: <1409317700-3836-1-git-send-email-stefan.hengelein@fau.de>
	<20140902170726.GF5001@linux.vnet.ibm.com>
Date: Tue, 2 Sep 2014 20:05:48 +0200
X-Google-Sender-Auth: f_iEnh1Tzj4Qh4bhhfXqcjlEvFI
Message-ID: <CABv5NL8mAy6CRbJQQx=su_72C_Sj-A+OFUA8nN1JPwmX_xeyKA@mail.gmail.com>
Subject: Re: [PATCH] init/Kconfig: move RCU_NOCB_CPU dependencies to choice
From: Stefan Hengelein <stefan.hengelein@fau.de>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jkosina@suse.cz,
        paul.gortmaker@windriver.com, mhocko@suse.cz, mattst88@gmail.com,
        josh@joshtriplett.org, geert@linux-m68k.org, khilman@linaro.org,
        Andreas Ruprecht <rupran@einserver.de>
Content-Type: multipart/mixed; boundary=001a1133c93e21f48d050218f8a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a1133c93e21f48d050218f8a1
Content-Type: text/plain; charset=UTF-8

2014-09-02 19:07 GMT+02:00 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Fri, Aug 29, 2014 at 03:08:20PM +0200, Stefan Hengelein wrote:
>> Every choice item of the "Build-forced no-CBs CPUs" choice had a
>> dependency to RCU_NOCB_CPU. It's more comprehensible if the choice
>> itself has the dependency instead of every choice item.
>> The choice itself doesn't need to be visible if there are no items
>> selectable (i.e. on arch/frv) or RCU_NOCB_CPU is not defined.
>>
>> Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
>> Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
>
> Looks like a nice improvement, but could you please forward-port to branch
> rcu/dev of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git?
>
>                                                                 Thanx, Paul

done, i attached the adjusted patch.

Best Regards,
Stefan

>
>> ---
>>  init/Kconfig | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 197b563..d604000 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -729,6 +729,7 @@ config RCU_NOCB_CPU
>>  choice
>>       prompt "Build-forced no-CBs CPUs"
>>       default RCU_NOCB_CPU_NONE
>> +     depends on RCU_NOCB_CPU
>>       help
>>         This option allows no-CBs CPUs (whose RCU callbacks are invoked
>>         from kthreads rather than from softirq context) to be specified
>> @@ -737,7 +738,7 @@ choice
>>
>>  config RCU_NOCB_CPU_NONE
>>       bool "No build_forced no-CBs CPUs"
>> -     depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
>> +     depends on !NO_HZ_FULL_ALL
>>       help
>>         This option does not force any of the CPUs to be no-CBs CPUs.
>>         Only CPUs designated by the rcu_nocbs= boot parameter will be
>> @@ -751,7 +752,7 @@ config RCU_NOCB_CPU_NONE
>>
>>  config RCU_NOCB_CPU_ZERO
>>       bool "CPU 0 is a build_forced no-CBs CPU"
>> -     depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
>> +     depends on !NO_HZ_FULL_ALL
>>       help
>>         This option forces CPU 0 to be a no-CBs CPU, so that its RCU
>>         callbacks are invoked by a per-CPU kthread whose name begins
>> @@ -766,7 +767,6 @@ config RCU_NOCB_CPU_ZERO
>>
>>  config RCU_NOCB_CPU_ALL
>>       bool "All CPUs are build_forced no-CBs CPUs"
>> -     depends on RCU_NOCB_CPU
>>       help
>>         This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
>>         boot parameter will be ignored.  All CPUs' RCU callbacks will
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>

--001a1133c93e21f48d050218f8a1
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-init-Kconfig-move-RCU_NOCB_CPU-dependencies-to-choic.patch"
Content-Disposition: attachment; 
	filename="0001-init-Kconfig-move-RCU_NOCB_CPU-dependencies-to-choic.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hzljp59c0

RnJvbSAxZjgyZTEyNDBlYmE0YjMxMDkxYmNmZjBlM2MxMjY4NTNhZGFjYjUzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVmYW4gSGVuZ2VsZWluIDxzdGVmYW4uaGVuZ2VsZWluQGZh
dS5kZT4KRGF0ZTogVHVlLCAyIFNlcCAyMDE0IDE5OjU1OjExICswMjAwClN1YmplY3Q6IFtQQVRD
SF0gaW5pdC9LY29uZmlnOiBtb3ZlIFJDVV9OT0NCX0NQVSBkZXBlbmRlbmNpZXMgdG8gY2hvaWNl
CgpFdmVyeSBjaG9pY2UgaXRlbSBvZiB0aGUgIkJ1aWxkLWZvcmNlZCBuby1DQnMgQ1BVcyIgY2hv
aWNlIGhhZCBhCmRlcGVuZGVuY3kgdG8gUkNVX05PQ0JfQ1BVLiAgSXQncyBtb3JlIGNvbXByZWhl
bnNpYmxlIGlmIHRoZSBjaG9pY2UKaXRzZWxmIGhhcyB0aGUgZGVwZW5kZW5jeSBpbnN0ZWFkIG9m
IGV2ZXJ5IGNob2ljZSBpdGVtLiAgVGhlIGNob2ljZQppdHNlbGYgZG9lc24ndCBuZWVkIHRvIGJl
IHZpc2libGUgaWYgdGhlcmUgYXJlIG5vIGl0ZW1zIHNlbGVjdGFibGUKKGkuZS4gIG9uIGFyY2gv
ZnJ2KSBvciBSQ1VfTk9DQl9DUFUgaXMgbm90IGRlZmluZWQuCgpTaWduZWQtb2ZmLWJ5OiBTdGVm
YW4gSGVuZ2VsZWluIDxzdGVmYW4uaGVuZ2VsZWluQGZhdS5kZT4KU2lnbmVkLW9mZi1ieTogQW5k
cmVhcyBSdXByZWNodCA8cnVwcmFuQGVpbnNlcnZlci5kZT4KUmV2aWV3ZWQtYnk6IEpvc2ggVHJp
cGxldHQgPGpvc2hAam9zaHRyaXBsZXR0Lm9yZz4KU2lnbmVkLW9mZi1ieTogQW5kcmV3IE1vcnRv
biA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KLS0tCiBpbml0L0tjb25maWcgfCA0ICstLS0K
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9pbml0L0tjb25maWcgYi9pbml0L0tjb25maWcKaW5kZXggNGZlNTUwMC4uOTVhMTQ0NyAx
MDA2NDQKLS0tIGEvaW5pdC9LY29uZmlnCisrKyBiL2luaXQvS2NvbmZpZwpAQCAtNzM5LDYgKzcz
OSw3IEBAIGNvbmZpZyBSQ1VfTk9DQl9DUFUKIGNob2ljZQogCXByb21wdCAiQnVpbGQtZm9yY2Vk
IG5vLUNCcyBDUFVzIgogCWRlZmF1bHQgUkNVX05PQ0JfQ1BVX05PTkUKKwlkZXBlbmRzIG9uIFJD
VV9OT0NCX0NQVQogCWhlbHAKIAkgIFRoaXMgb3B0aW9uIGFsbG93cyBuby1DQnMgQ1BVcyAod2hv
c2UgUkNVIGNhbGxiYWNrcyBhcmUgaW52b2tlZAogCSAgZnJvbSBrdGhyZWFkcyByYXRoZXIgdGhh
biBmcm9tIHNvZnRpcnEgY29udGV4dCkgdG8gYmUgc3BlY2lmaWVkCkBAIC03NDcsNyArNzQ4LDYg
QEAgY2hvaWNlCiAKIGNvbmZpZyBSQ1VfTk9DQl9DUFVfTk9ORQogCWJvb2wgIk5vIGJ1aWxkX2Zv
cmNlZCBuby1DQnMgQ1BVcyIKLQlkZXBlbmRzIG9uIFJDVV9OT0NCX0NQVQogCWhlbHAKIAkgIFRo
aXMgb3B0aW9uIGRvZXMgbm90IGZvcmNlIGFueSBvZiB0aGUgQ1BVcyB0byBiZSBuby1DQnMgQ1BV
cy4KIAkgIE9ubHkgQ1BVcyBkZXNpZ25hdGVkIGJ5IHRoZSByY3Vfbm9jYnM9IGJvb3QgcGFyYW1l
dGVyIHdpbGwgYmUKQEAgLTc2MSw3ICs3NjEsNiBAQCBjb25maWcgUkNVX05PQ0JfQ1BVX05PTkUK
IAogY29uZmlnIFJDVV9OT0NCX0NQVV9aRVJPCiAJYm9vbCAiQ1BVIDAgaXMgYSBidWlsZF9mb3Jj
ZWQgbm8tQ0JzIENQVSIKLQlkZXBlbmRzIG9uIFJDVV9OT0NCX0NQVQogCWhlbHAKIAkgIFRoaXMg
b3B0aW9uIGZvcmNlcyBDUFUgMCB0byBiZSBhIG5vLUNCcyBDUFUsIHNvIHRoYXQgaXRzIFJDVQog
CSAgY2FsbGJhY2tzIGFyZSBpbnZva2VkIGJ5IGEgcGVyLUNQVSBrdGhyZWFkIHdob3NlIG5hbWUg
YmVnaW5zCkBAIC03NzYsNyArNzc1LDYgQEAgY29uZmlnIFJDVV9OT0NCX0NQVV9aRVJPCiAKIGNv
bmZpZyBSQ1VfTk9DQl9DUFVfQUxMCiAJYm9vbCAiQWxsIENQVXMgYXJlIGJ1aWxkX2ZvcmNlZCBu
by1DQnMgQ1BVcyIKLQlkZXBlbmRzIG9uIFJDVV9OT0NCX0NQVQogCWhlbHAKIAkgIFRoaXMgb3B0
aW9uIGZvcmNlcyBhbGwgQ1BVcyB0byBiZSBuby1DQnMgQ1BVcy4gIFRoZSByY3Vfbm9jYnM9CiAJ
ICBib290IHBhcmFtZXRlciB3aWxsIGJlIGlnbm9yZWQuICBBbGwgQ1BVcycgUkNVIGNhbGxiYWNr
cyB3aWxsCi0tIAoxLjkuMQoK
--001a1133c93e21f48d050218f8a1--
