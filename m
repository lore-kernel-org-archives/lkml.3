Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3AJUij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:38:39 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:22298 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755020Ab3AJUii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:38:38 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18xDbta8my2SEHavRdacK90
Date: Thu, 10 Jan 2013 12:38:33 -0800
From: Tony Lindgren <tony@atomide.com>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        liu chuansheng <chuansheng.liu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] hardlockup: detect hard lockups without NMIs using
 secondary cpus
Message-ID: <20130110203833.GE14149@atomide.com>
References: <1357783059-13923-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357783059-13923-1-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Colin Cross <ccross@android.com> [130109 18:05]:
> +static void watchdog_check_hardlockup_other_cpu(void)
> +{
> +	int cpu;
> +	cpumask_t cpus = watchdog_cpus;
> +
> +	/*
> +	 * Test for hardlockups every 3 samples.  The sample period is
> +	 *  watchdog_thresh * 2 / 5, so 3 samples gets us back to slightly over
> +	 *  watchdog_thresh (over by 20%).
> +	 */
> +	if (__this_cpu_read(hrtimer_interrupts) % 3 != 0)
> +		return;
> +
> +	/* check for a hardlockup on the next cpu */
> +	cpu = cpumask_next(smp_processor_id(), &cpus);

Hmm don't you want to check cpu_oneline_mask here and
return if the other CPU is offline?

> +	if (cpu >= nr_cpu_ids)
> +		cpu = cpumask_first(&cpus);
> +	if (cpu == smp_processor_id())
> +		return;

Regards,

Tony
