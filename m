Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaLIAYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 19:24:53 -0500
Received: from smtprelay0030.hostedemail.com ([216.40.44.30]:49019 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751103AbaLIAYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 19:24:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:2:41:69:355:379:541:599:800:960:973:979:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2393:2559:2562:2690:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3871:3872:3873:4117:4250:4321:4383:4605:5007:6119:6261:7514:7875:7903:7974:8531:8660:9010:10004:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12683:12740:13148:13230:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gold50_6450f116e131d
X-Filterd-Recvd-Size: 6061
Message-ID: <1418084686.15957.1.camel@perches.com>
Subject: Re: [PATCH v2] init: calibrate: fix style issues
From: Joe Perches <joe@perches.com>
To: Rasmus Wriedt Larsen <rasmuswriedtlarsen@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>
Cc: rmk+kernel@arm.linux.org.uk, pdeschrijver@nvidia.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Dec 2014 16:24:46 -0800
In-Reply-To: <54861078.3090606@gmail.com>
References: <1413048976.16385.37.camel@joe-AO725>
	 <1413195155-8111-1-git-send-email-rasmuswriedtlarsen@gmail.com>
	 <54861078.3090606@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-08 at 21:56 +0100, Rasmus Wriedt Larsen wrote:
> Wanted to bump this patch, as nothing has happened in a long time.

Maybe you need to expand the recipient list.
Andrew Morton sometimes picks up patches like this.
Sometimes Jiri Kosina, the trivial maintainer, does.
Both have been added to the recipient list here.

> As this is my first linux patch, I was quite hoping to get it accepted :)
> 
> On 13/10/14 12:12, Rasmus Wriedt Larsen wrote:
> > * fix multiple quoted string split across lines style issues
> > * change printk(KERN_NOTICE to pr_notice
> > * insert spaces after , in function call
> > * change two line pr_notice msg to one line (credit: Joe Perches)
> > 
> > Signed-off-by: Rasmus Wriedt Larsen <rasmuswriedtlarsen@gmail.com>
> > ---
> >  init/calibrate.c | 35 ++++++++++++++---------------------
> >  1 file changed, 14 insertions(+), 21 deletions(-)
> > 
> > diff --git a/init/calibrate.c b/init/calibrate.c
> > index ce635dc..d9c8810 100644
> > --- a/init/calibrate.c
> > +++ b/init/calibrate.c
> > @@ -15,7 +15,7 @@ unsigned long lpj_fine;
> >  unsigned long preset_lpj;
> >  static int __init lpj_setup(char *str)
> >  {
> > -	preset_lpj = simple_strtoul(str,NULL,0);
> > +	preset_lpj = simple_strtoul(str, NULL, 0);
> >  	return 1;
> >  }
> > 
> > @@ -40,11 +40,13 @@ static unsigned long calibrate_delay_direct(void)
> >  	unsigned long good_timer_sum = 0;
> >  	unsigned long good_timer_count = 0;
> >  	unsigned long measured_times[MAX_DIRECT_CALIBRATION_RETRIES];
> > -	int max = -1; /* index of measured_times with max/min values or not set */
> > +
> > +	/* index of measured_times with max/min values or not set */
> > +	int max = -1;
> >  	int min = -1;
> >  	int i;
> > 
> > -	if (read_current_timer(&pre_start) < 0 )
> > +	if (read_current_timer(&pre_start) < 0)
> >  		return 0;
> > 
> >  	/*
> > @@ -95,9 +97,7 @@ static unsigned long calibrate_delay_direct(void)
> >  		 * >= 12.5% apart, redo calibration.
> >  		 */
> >  		if (start >= post_end)
> > -			printk(KERN_NOTICE "calibrate_delay_direct() ignoring "
> > -					"timer_rate as we had a TSC wrap around"
> > -					" start=%lu >=post_end=%lu\n",
> > +			pr_notice("calibrate_delay_direct() ignoring timer_rate as we had a TSC wrap around start=%lu >=post_end=%lu\n",
> >  				start, post_end);
> >  		if (start < post_end && pre_start != 0 && pre_end != 0 &&
> >  		    (timer_rate_max - timer_rate_min) < (timer_rate_max >> 3)) {
> > @@ -134,14 +134,12 @@ static unsigned long calibrate_delay_direct(void)
> >  		good_timer_count = 0;
> >  		if ((measured_times[max] - estimate) <
> >  				(estimate - measured_times[min])) {
> > -			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
> > -					"min bogoMips estimate %d = %lu\n",
> > +			pr_notice("calibrate_delay_direct() dropping min bogoMips estimate %d = %lu\n",
> >  				min, measured_times[min]);
> >  			measured_times[min] = 0;
> >  			min = max;
> >  		} else {
> > -			printk(KERN_NOTICE "calibrate_delay_direct() dropping "
> > -					"max bogoMips estimate %d = %lu\n",
> > +			pr_notice("calibrate_delay_direct() dropping max bogoMips estimate %d = %lu\n",
> >  				max, measured_times[max]);
> >  			measured_times[max] = 0;
> >  			max = min;
> > @@ -160,9 +158,8 @@ static unsigned long calibrate_delay_direct(void)
> > 
> >  	}
> > 
> > -	printk(KERN_NOTICE "calibrate_delay_direct() failed to get a good "
> > -	       "estimate for loops_per_jiffy.\nProbably due to long platform "
> > -		"interrupts. Consider using \"lpj=\" boot option.\n");
> > +	pr_notice("%s: failed to reasonably estimate loops_per_jiffy (long platform interrupts?) - perhaps use boot option 'lpj='\n",
> > +		  __func__);
> >  	return 0;
> >  }
> >  #else
> > @@ -280,23 +277,19 @@ void calibrate_delay(void)
> >  	if (per_cpu(cpu_loops_per_jiffy, this_cpu)) {
> >  		lpj = per_cpu(cpu_loops_per_jiffy, this_cpu);
> >  		if (!printed)
> > -			pr_info("Calibrating delay loop (skipped) "
> > -				"already calibrated this CPU");
> > +			pr_info("Calibrating delay loop (skipped) already calibrated this CPU");
> >  	} else if (preset_lpj) {
> >  		lpj = preset_lpj;
> >  		if (!printed)
> > -			pr_info("Calibrating delay loop (skipped) "
> > -				"preset value.. ");
> > +			pr_info("Calibrating delay loop (skipped) preset value.. ");
> >  	} else if ((!printed) && lpj_fine) {
> >  		lpj = lpj_fine;
> > -		pr_info("Calibrating delay loop (skipped), "
> > -			"value calculated using timer frequency.. ");
> > +		pr_info("Calibrating delay loop (skipped), value calculated using timer frequency.. ");
> >  	} else if ((lpj = calibrate_delay_is_known())) {
> >  		;
> >  	} else if ((lpj = calibrate_delay_direct()) != 0) {
> >  		if (!printed)
> > -			pr_info("Calibrating delay using timer "
> > -				"specific routine.. ");
> > +			pr_info("Calibrating delay using timer specific routine.. ");
> >  	} else {
> >  		if (!printed)
> >  			pr_info("Calibrating delay loop... ");


