Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab3IKUHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:07:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47468 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab3IKUHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:07:16 -0400
Message-ID: <5230CD70.50202@wwwdotorg.org>
Date: Wed, 11 Sep 2013 14:07:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cpufreq <cpufreq@vger.kernel.org>
Subject: Re: cpufreq_stats NULL deref on second system suspend
References: <522E1FEF.6080803@wwwdotorg.org> <1775778.MeiRhuYy7o@vostro.rjw.lan> <522F86AD.6010603@wwwdotorg.org> <2521560.SfeNbV74nj@vostro.rjw.lan> <52304439.3030301@linux.vnet.ibm.com> <523094CD.3000506@wwwdotorg.org> <5230B078.3070306@linux.vnet.ibm.com> <5230B991.3040702@linux.vnet.ibm.com> <5230BE75.7040307@wwwdotorg.org> <5230C89D.7010801@linux.vnet.ibm.com>
In-Reply-To: <5230C89D.7010801@linux.vnet.ibm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 01:46 PM, Srivatsa S. Bhat wrote:
> On 09/12/2013 12:33 AM, Stephen Warren wrote:
>> On 09/11/2013 12:42 PM, Srivatsa S. Bhat wrote:
>> ...
>>> OK, I took a second look at the code, and I suspect that applying the
>>> second patch might help. So can you try by applying both the patches
>>> please[1][2]?
>>>
>> ...
>>> [1]. http://marc.info/?l=linux-kernel&m=137889516210816&w=2
>>> [2]. http://marc.info/?l=linux-kernel&m=137889800511940&w=2
>>
>> Yes, with both of those patches applies, the problem is solved:-)
>>
>> I was going to test the second patch originally, but it sounded like it
>> was more of a cleanup rather than a fix for my issue, so I didn't bother
>> when I found the problem wasn't solved by patch 1. Sorry!
>>
> 
> Well, honestly, even I had intended the second patch as a cleanup and
> hadn't asked you to test it ;-) Only when you reported that the first patch
> failed to solve your problem, I realized that the second patch was
> important too! :-) Thanks for testing!
> 
>> For the record, I'm testing on a 2-CPU system, so I'm not sure whether
>> your explanation applies; it talks about CPUs 2 and 3 whereas I only
>> have CPUs 0 and 1, but perhaps your explanation applies equally to any
>> pair of CPUs?
>>
> 
> Yes, it applies to any pair of CPUs, as long as the CPU first taken down
> is not the policy->cpu. In your case, it applies like this:
> IIUC, CPU0 is the boot cpu, and hence it wont be taken offline using hotplug.
> So only CPU 1 is taken offline during suspend. And if it is not the policy->cpu,
> then it hits the very same bug that I described with the analogy of CPUs 2
> and 3.
> 
>> For the record, here's the information you requested in the other email:
>>
>> # cat /sys/devices/system/cpu/cpu*/cpufreq/related_cpus
>> 0 1
>> 0 1
> 
> Thanks! It would have been more useful to somehow know which was the
> policy->cpu. But looking at the problem, certainly CPU0 was the policy->cpu
> in your case.

Yes, I believe CPU0 since,

> # ls -l /sys/devices/system/cpu/cpu1/cpufreq
> lrwxrwxrwx 1 root root 0 Jan  1 00:01 /sys/devices/system/cpu/cpu1/cpufreq -> ../cpu0/cpufreq

and cpu0/cpufreq/ has all the files in it.

...
> So can you see if patch 1 + this above fix solves your problem as well?
> Then we can retain the original patch 2 as a cleanup, after these 2 patches.
> This organization also makes the code look better and understandable.

Yes, both patch 1+3 and 1+3+2 work fine.

