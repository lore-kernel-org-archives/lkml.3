Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3IQQSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:18:12 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45623 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3IQQSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:18:09 -0400
MIME-Version: 1.0
In-Reply-To: <52387343.7040007@wwwdotorg.org>
References: <cover.1378963070.git.viresh.kumar@linaro.org>
	<8f777cc6b41b2fed4bf71ce2adc36800353d5738.1378963070.git.viresh.kumar@linaro.org>
	<52387343.7040007@wwwdotorg.org>
Date: Tue, 17 Sep 2013 21:48:08 +0530
Message-ID: <CAKohpo=_bhaws44_XEf=DEjbVtiRfYHeMm-cK=bHo1Sed14kAg@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 September 2013 20:50, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/11/2013 11:25 PM, Viresh Kumar wrote:
>> This broke after a recent change "cedb70a cpufreq: Split __cpufreq_remove_dev()
>> into two parts" from Srivatsa..
>>
>> Consider a scenario where we have two CPUs in a policy (0 & 1) and we are
>> removing cpu 1. On the call to __cpufreq_remove_dev_prepare() we have cleared 1
>> from policy->cpus and now on a call to __cpufreq_remove_dev_finish() we read
>> cpumask_weight of policy->cpus, which will come as 1 and this code will behave
>> as if we are removing the last cpu from policy :)
>>
>> Fix it by clearing cpu mask in __cpufreq_remove_dev_finish() instead of
>> __cpufreq_remove_dev_prepare().
>
> I see this patch isn't in linux-next yet, nor did it make 3.12-rc1. I
> assume it'll make 3.12-rc2? It solves various CPU hotplug and
> suspend/resume issues for me.

Yes, I have asked Rafael to get this in for rc2 and few others too..
Waiting for his reply though..

--
viresh
