Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab3CLMPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:15:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40323 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3CLMPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:15:14 -0400
Date: Tue, 12 Mar 2013 12:14:58 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Colin Cross <ccross@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "davej@redhat.com" <davej@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Tang, Guifang" <guifang.tang@intel.com>, stable@vger.kernel.org
Subject: Re: Fix memory leak in cpufreq stats.
Message-ID: <20130312121458.GC3222@hercules>
References: <EE928378561BF1449699C96571234A740FE66C2A@SHSMSX102.ccr.corp.intel.com>
 <3402692.Elm8oBRUJI@vostro.rjw.lan>
 <CAMbhsRTi8-41em4+-7NpLwXFpbGcy3Vsib5ees_OWm5JGmOVDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRTi8-41em4+-7NpLwXFpbGcy3Vsib5ees_OWm5JGmOVDw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 06:23:27PM -0700, Colin Cross wrote:
> On Mon, Oct 15, 2012 at 1:30 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday 15 of October 2012 02:48:28 Tu, Xiaobing wrote:
> >>
> >> Fix memory leak in cpufreq stats.
> >>
> >> When system enter sleep, non-boot CPUs will be disable.
> >> Cpufreq stats sysfs is created when the CPU is up, but it is not freed when
> >> the CPU going down. This will cause memory leak.
> >> signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
> >> signed-off-by: guifang tang <guifang.tang@intel.com>
> >
> > I will push this patch for v3.7 in the -rc3 time frame if no one objects.
> >
> > Thanks,
> > Rafael
> >
> >
> >> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> >> index b40ee14..3998316 100644
> >> --- a/drivers/cpufreq/cpufreq_stats.c
> >> +++ b/drivers/cpufreq/cpufreq_stats.c
> >> @@ -328,6 +328,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
> >>                 cpufreq_update_policy(cpu);
> >>                 break;
> >>         case CPU_DOWN_PREPARE:
> >> +       case CPU_DOWN_PREPARE_FROZEN:
> >>                 cpufreq_stats_free_sysfs(cpu);
> >>                 break;
> >>         case CPU_DEAD:
> >>
> >> Br
> >> XiaoBing Tu
> >> PSI@System Integration Shanghai
> 
> This patch, commited as e37736777254ce1abc85493a5cacbefe5983b896 since
> v3.7, should also have gone to stable.  It should apply all the way
> back to 3.0.

Thanks, I'm queuing it for the 3.5 kernel.

Cheers,
--
Luis
