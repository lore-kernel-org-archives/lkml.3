Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161585Ab3DEFnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:43:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469Ab3DEFnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:43:11 -0400
Message-ID: <515E6461.3060800@redhat.com>
Date: Thu, 04 Apr 2013 22:42:57 -0700
From: Adam Williamson <awilliam@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: dirk.brandewie@gmail.com, Parag Warudkar <parag.lkml@gmail.com>,
        rjw@sisk.pl, linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq/intel_pstate: Set timer timeout correctly
References: <1365096935-16730-1-git-send-email-dirk.brandewie@gmail.com> <CAOh2x=mzQBSnBB3-10yGMdGfxMWeMcvE_t2Mvnz+fvdHv0-uaA@mail.gmail.com>
In-Reply-To: <CAOh2x=mzQBSnBB3-10yGMdGfxMWeMcvE_t2Mvnz+fvdHv0-uaA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/13 10:19 PM, Viresh Kumar wrote:
> On Thu, Apr 4, 2013 at 11:05 PM,  <dirk.brandewie@gmail.com> wrote:
>> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>>
>> The current calculation of the delay time is wrong and a cut and paste
>> error from a previous experimental driver.  This can result in the
>> timeout being set to jiffies + 1 which setup the driver to race with
>> it's self if the apic timer interrupt happen at just the right time.
>>
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=920289
>>
>> Reported-by: Adam Williamson <awilliam@redhat.com>
>> Reported-by: Parag Warudkar <parag.lkml@gmail.com>
>>
>> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
>> ---
>>   drivers/cpufreq/intel_pstate.c |    1 -
>>   1 files changed, 0 insertions(+), 1 deletions(-)
>
> Looks fine, but I would like to see a Tested-by from Adam/Parag
> as they haven't said anything about this patch (even in bugzilla).

I'll try. Note the bug is not reliably reproducible, all I can really do 
is run for a day or two and see if it crashes.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | identi.ca: adamwfedora
http://www.happyassassin.net
