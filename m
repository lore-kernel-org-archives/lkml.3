Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3IMQMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:12:25 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:63783 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3IMQMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:12:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130913155424.GB12758@n2100.arm.linux.org.uk>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<6e2ca86ce948c0bc35f7709baf22672771fcf1e8.1379063063.git.viresh.kumar@linaro.org>
	<20130913155424.GB12758@n2100.arm.linux.org.uk>
Date: Fri, 13 Sep 2013 21:42:23 +0530
Message-ID: <CAKohpomAj0wDnjdi7XXw=bGsu0LMRrr1SMwdzBsa0GTxGrABoQ@mail.gmail.com>
Subject: Re: [PATCH 206/228] cpufreq: sa11x0: remove calls to cpufreq_notify_transition()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 September 2013 21:24, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Sep 13, 2013 at 06:32:32PM +0530, Viresh Kumar wrote:
>> Most of the drivers do following in their ->target_index() routines:
>>
>>       struct cpufreq_freqs freqs;
>>       freqs.old = old freq...
>>       freqs.new = new freq...
>>
>>       cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
>>
>>       /* Change rate here */
>>
>>       cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
>>
>> This is replicated over all cpufreq drivers today and there doesn't exists a
>> good enough reason why this shouldn't be moved to cpufreq core instead.
>>
>> Earlier patches have added support in cpufreq core to do cpufreq notification on
>> frequency change, this one removes it from this driver.
>>
>> Some related minor cleanups are also done along with it.
>>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Shouldn't this patch set CPUFREQ_ASYNC_NOTIFICATION somewhere?

As far as I can see, sa11x0 completes frequency transition from within
target() and so it does it synchronously.. And so it doesn't need to set
CPUFREQ_ASYNC_NOTIFICATION...

Am I missing something?
