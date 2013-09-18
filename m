Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3IRIB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 04:01:29 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:43797 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3IRIB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 04:01:27 -0400
MIME-Version: 1.0
In-Reply-To: <523951B4.5090601@linux.vnet.ibm.com>
References: <141ec437a203e4384459abb22e393d83136f732d.1379432906.git.viresh.kumar@linaro.org>
	<523951B4.5090601@linux.vnet.ibm.com>
Date: Wed, 18 Sep 2013 13:31:26 +0530
Message-ID: <CAKohpokZyxhwVqagTM4OfOGgHxPGKPQkFTHRfAo53OxCP77cEQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: create per policy rwsem instead of per cpu cpu_policy_rwsem
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 September 2013 12:39, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 09/17/2013 09:20 PM, Viresh Kumar wrote:

> The code looks good, but the patch doesn't apply properly, because of the code
> change that went in in your patch "cpufreq: Clear policy->cpus bits in
> __cpufreq_remove_dev_finish()".

Hmm.. Because of the number of patches floating now a days, it is getting more
and more complex..

I will sort things out once Rafael starts picking stuff for 3.13..

>> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h

>> +     /*
>> +      * The rules for this semaphore:
>> +      * - Any routine that wants to read from the policy structure will
>> +      *   do a down_read on this semaphore.
>> +      * - Any routine that will write to the policy structure and/or may take away
>> +      *   the policy altogether (eg. CPU hotplug), will hold this lock in write
>> +      *   mode before doing so.
>> +      *
>> +      * Additional rules:
>> +      * - Governor routines that can be called in cpufreq hotplug path should not
>> +      *   take this sem as top level hotplug notifier handler takes this.
>
> I think this comment is obsolete. I don't see the top-level hotplug notifier handler
> (cpufreq_cpu_callback) acquiring the rwsem. Good to fix this comment while we are
> at it, perhaps in a separate patch. (The comment above __cpufreq_remove_dev about
> the policy-rwsem appears to be similarly out of date).

Yeah.. Will get that done, but will send these again only once Rafael is picking
stuff for 3.13..
