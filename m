Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab3CLBXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 21:23:30 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:37800 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3CLBX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 21:23:28 -0400
MIME-Version: 1.0
In-Reply-To: <3402692.Elm8oBRUJI@vostro.rjw.lan>
References: <EE928378561BF1449699C96571234A740FE66C2A@SHSMSX102.ccr.corp.intel.com>
	<3402692.Elm8oBRUJI@vostro.rjw.lan>
Date: Mon, 11 Mar 2013 18:23:27 -0700
Message-ID: <CAMbhsRTi8-41em4+-7NpLwXFpbGcy3Vsib5ees_OWm5JGmOVDw@mail.gmail.com>
Subject: Re: Fix memory leak in cpufreq stats.
From: Colin Cross <ccross@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "davej@redhat.com" <davej@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Tang, Guifang" <guifang.tang@intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 1:30 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday 15 of October 2012 02:48:28 Tu, Xiaobing wrote:
>>
>> Fix memory leak in cpufreq stats.
>>
>> When system enter sleep, non-boot CPUs will be disable.
>> Cpufreq stats sysfs is created when the CPU is up, but it is not freed when
>> the CPU going down. This will cause memory leak.
>> signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
>> signed-off-by: guifang tang <guifang.tang@intel.com>
>
> I will push this patch for v3.7 in the -rc3 time frame if no one objects.
>
> Thanks,
> Rafael
>
>
>> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
>> index b40ee14..3998316 100644
>> --- a/drivers/cpufreq/cpufreq_stats.c
>> +++ b/drivers/cpufreq/cpufreq_stats.c
>> @@ -328,6 +328,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
>>                 cpufreq_update_policy(cpu);
>>                 break;
>>         case CPU_DOWN_PREPARE:
>> +       case CPU_DOWN_PREPARE_FROZEN:
>>                 cpufreq_stats_free_sysfs(cpu);
>>                 break;
>>         case CPU_DEAD:
>>
>> Br
>> XiaoBing Tu
>> PSI@System Integration Shanghai

This patch, commited as e37736777254ce1abc85493a5cacbefe5983b896 since
v3.7, should also have gone to stable.  It should apply all the way
back to 3.0.
