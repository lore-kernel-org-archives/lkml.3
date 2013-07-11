Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab3GKLrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:47:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34985 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3GKLr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:47:29 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-ce-51de9b4f1a05
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: Re: [LOCKDEP] cpufreq: possible circular locking dependency
 detected
Date: Thu, 11 Jul 2013 13:47:21 +0200
Message-id: <6587578.5W401XNfO8@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc2+; KDE/4.8.5; i686; ; )
In-reply-to: <51DE7173.4040905@linux.vnet.ibm.com>
References: <20130625211544.GA2270@swordfish>
 <51DE7120.5040106@linux.vnet.ibm.com> <51DE7173.4040905@linux.vnet.ibm.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jQV3/2fcCDU7tELH4vOEfm8XTph/s
	FrvnLGaxuLxrDpvF594jjBb9C3uZLNZ+fsxucfnrdWaLjV89LA49ncPiwOXxvbWPxWPnrLvs
	Hneu7WHzeHBoM4vHo8UtjB5nFhxh9/i8SS6APYrLJiU1J7MstUjfLoErY2XfbPaCfWYVH5c+
	ZGtg3KfdxcjJISFgIvHk7g5mCFtM4sK99WxdjFwcQgLTGSVOvT7ADOG0MEn0LVzHBFLFJmAl
	MbF9FSOILSKgK7Hr9zOwDmaB80wS179PASsSFgiWmHJ7P1A3BweLgKrEzh0mIGFeAU2JbRtX
	g20TFbCX2PbuLRtICaeAkUTb0gqQsJBAtcSp5n4WiHJBiR+T74HZzALyEvv2T2WFsHUk9rdO
	Y5vAKDALSdksJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcFc+kdzCuarA4
	xCjAwajEw9sQfzdQiDWxrLgy9xCjBAezkgiv4OR7gUK8KYmVValF+fFFpTmpxYcYpTlYlMR5
	D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYY+6nmMqx9MuFrrl37PLyueLa7ruXW8Tt23iKNzLt
	XESdWuSiaQvMBJdcWLJiQ9AP1ikJ7C/mPV9z4Wh1D3eCdi1Tq97CWRo9MrUxoQ66RTHfAy/1
	tT9TTP7jasH/4IJPqov3CvsdHz+2Z+tEX/6z2POS3WI5I5mc6pkn7BycNL92hxs3//ZQYinO
	SDTUYi4qTgQApHSbsYYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, July 11, 2013 04:48:51 PM Michael Wang wrote:
> On 07/11/2013 04:47 PM, Michael Wang wrote:
> > On 07/11/2013 04:22 PM, Sergey Senozhatsky wrote:
> > [snip]
> >>>
> >>
> >> Hello Michael,
> >> nice job! works fine for me.
> >>
> >> Reported-and-Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > 
> > Thanks for the test :)
> > 
> > Borislav may also doing some testing, let's wait for few days and see
> > whether there are any point we missed.
> 
> s /Borislav/Bartlomiej

Michael's patch also works for me. Thanks to everyone involved!
(My only nitpick for the patch is that ->queue_stop can be made bool.)

Reported-and-Tested-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

I think that it would also be helpful if Jiri or Borislav could test
the patch and see if it really works for them and fixes the original
warning they were experiencing on x86.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > And we should also thanks Srivatsa for catching the root issue ;-)
> > 
> > Regards,
> > Michael Wang
> > 
> >>
> >>
> >> 	-ss
> >>
> >>> Regards,
> >>> Michael Wang
> >>>
> >>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> >>> index dc9b72e..a64b544 100644
> >>> --- a/drivers/cpufreq/cpufreq_governor.c
> >>> +++ b/drivers/cpufreq/cpufreq_governor.c
> >>> @@ -178,13 +178,14 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
> >>>  {
> >>>  	int i;
> >>>  
> >>> +	if (dbs_data->queue_stop)
> >>> +		return;
> >>> +
> >>>  	if (!all_cpus) {
> >>>  		__gov_queue_work(smp_processor_id(), dbs_data, delay);
> >>>  	} else {
> >>> -		get_online_cpus();
> >>>  		for_each_cpu(i, policy->cpus)
> >>>  			__gov_queue_work(i, dbs_data, delay);
> >>> -		put_online_cpus();
> >>>  	}
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(gov_queue_work);
> >>> @@ -193,12 +194,27 @@ static inline void gov_cancel_work(struct dbs_data *dbs_data,
> >>>  		struct cpufreq_policy *policy)
> >>>  {
> >>>  	struct cpu_dbs_common_info *cdbs;
> >>> -	int i;
> >>> +	int i, round = 2;
> >>>  
> >>> +	dbs_data->queue_stop = 1;
> >>> +redo:
> >>> +	round--;
> >>>  	for_each_cpu(i, policy->cpus) {
> >>>  		cdbs = dbs_data->cdata->get_cpu_cdbs(i);
> >>>  		cancel_delayed_work_sync(&cdbs->work);
> >>>  	}
> >>> +
> >>> +	/*
> >>> +	 * Since there is no lock to prvent re-queue the
> >>> +	 * cancelled work, some early cancelled work might
> >>> +	 * have been queued again by later cancelled work.
> >>> +	 *
> >>> +	 * Flush the work again with dbs_data->queue_stop
> >>> +	 * enabled, this time there will be no survivors.
> >>> +	 */
> >>> +	if (round)
> >>> +		goto redo;
> >>> +	dbs_data->queue_stop = 0;
> >>>  }
> >>>  
> >>>  /* Will return if we need to evaluate cpu load again or not */
> >>> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> >>> index e16a961..9116135 100644
> >>> --- a/drivers/cpufreq/cpufreq_governor.h
> >>> +++ b/drivers/cpufreq/cpufreq_governor.h
> >>> @@ -213,6 +213,7 @@ struct dbs_data {
> >>>  	unsigned int min_sampling_rate;
> >>>  	int usage_count;
> >>>  	void *tuners;
> >>> +	int queue_stop;
> >>>  
> >>>  	/* dbs_mutex protects dbs_enable in governor start/stop */
> >>>  	struct mutex mutex;
> >>>
> >>>>
> >>>> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> >>>>
> >>>> ---
> >>>>
> >>>>  drivers/cpufreq/cpufreq.c          |  5 +----
> >>>>  drivers/cpufreq/cpufreq_governor.c | 17 +++++++++++------
> >>>>  drivers/cpufreq/cpufreq_stats.c    |  2 +-
> >>>>  3 files changed, 13 insertions(+), 11 deletions(-)
> >>>>
> >>>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> >>>> index 6a015ad..f8aacf1 100644
> >>>> --- a/drivers/cpufreq/cpufreq.c
> >>>> +++ b/drivers/cpufreq/cpufreq.c
> >>>> @@ -1943,13 +1943,10 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
> >>>>  		case CPU_ONLINE:
> >>>>  			cpufreq_add_dev(dev, NULL);
> >>>>  			break;
> >>>> -		case CPU_DOWN_PREPARE:
> >>>> +		case CPU_POST_DEAD:
> >>>>  		case CPU_UP_CANCELED_FROZEN:
> >>>>  			__cpufreq_remove_dev(dev, NULL);
> >>>>  			break;
> >>>> -		case CPU_DOWN_FAILED:
> >>>> -			cpufreq_add_dev(dev, NULL);
> >>>> -			break;
> >>>>  		}
> >>>>  	}
> >>>>  	return NOTIFY_OK;
> >>>> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> >>>> index 4645876..681d5d6 100644
> >>>> --- a/drivers/cpufreq/cpufreq_governor.c
> >>>> +++ b/drivers/cpufreq/cpufreq_governor.c
> >>>> @@ -125,7 +125,11 @@ static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
> >>>>  		unsigned int delay)
> >>>>  {
> >>>>  	struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
> >>>> -
> >>>> +	/* cpu offline might block existing gov_queue_work() user,
> >>>> +	 * unblocking it after CPU_DEAD and before CPU_POST_DEAD.
> >>>> +	 * thus potentially we can hit offlined CPU */
> >>>> +	if (unlikely(cpu_is_offline(cpu)))
> >>>> +		return;
> >>>>  	mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
> >>>>  }
> >>>>
> >>>> @@ -133,15 +137,14 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
> >>>>  		unsigned int delay, bool all_cpus)
> >>>>  {
> >>>>  	int i;
> >>>> -
> >>>> +	get_online_cpus();
> >>>>  	if (!all_cpus) {
> >>>>  		__gov_queue_work(smp_processor_id(), dbs_data, delay);
> >>>>  	} else {
> >>>> -		get_online_cpus();
> >>>>  		for_each_cpu(i, policy->cpus)
> >>>>  			__gov_queue_work(i, dbs_data, delay);
> >>>> -		put_online_cpus();
> >>>>  	}
> >>>> +	put_online_cpus();
> >>>>  }
> >>>>  EXPORT_SYMBOL_GPL(gov_queue_work);
> >>>>
> >>>> @@ -354,8 +357,10 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
> >>>>  		/* Initiate timer time stamp */
> >>>>  		cpu_cdbs->time_stamp = ktime_get();
> >>>>
> >>>> -		gov_queue_work(dbs_data, policy,
> >>>> -				delay_for_sampling_rate(sampling_rate), true);
> >>>> +		/* hotplug lock already held */
> >>>> +		for_each_cpu(j, policy->cpus)
> >>>> +			__gov_queue_work(j, dbs_data,
> >>>> +				delay_for_sampling_rate(sampling_rate));
> >>>>  		break;
> >>>>
> >>>>  	case CPUFREQ_GOV_STOP:
> >>>> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> >>>> index cd9e817..833816e 100644
> >>>> --- a/drivers/cpufreq/cpufreq_stats.c
> >>>> +++ b/drivers/cpufreq/cpufreq_stats.c
> >>>> @@ -355,7 +355,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
> >>>>  	case CPU_DOWN_PREPARE:
> >>>>  		cpufreq_stats_free_sysfs(cpu);
> >>>>  		break;
> >>>> -	case CPU_DEAD:
> >>>> +	case CPU_POST_DEAD:
> >>>>  		cpufreq_stats_free_table(cpu);
> >>>>  		break;
> >>>>  	case CPU_UP_CANCELED_FROZEN:
> >>>> --

