Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3AJXnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 18:43:07 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39997 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754476Ab3AJXnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 18:43:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18uA6DSuqAqJxV4ZfrRL8n4
Date: Thu, 10 Jan 2013 15:42:58 -0800
From: Tony Lindgren <tony@atomide.com>
To: Colin Cross <ccross@android.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        liu chuansheng <chuansheng.liu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] hardlockup: detect hard lockups without NMIs using
 secondary cpus
Message-ID: <20130110234258.GA15458@atomide.com>
References: <1357783059-13923-1-git-send-email-ccross@android.com>
 <20130110203833.GE14149@atomide.com>
 <CAMbhsRR5azGw1-VhC4+9y7NfBPnZkBKnK34AqXdMFBsXPqdjCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRR5azGw1-VhC4+9y7NfBPnZkBKnK34AqXdMFBsXPqdjCQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Colin Cross <ccross@android.com> [130110 14:37]:
> On Thu, Jan 10, 2013 at 12:38 PM, Tony Lindgren <tony@atomide.com> wrote:
> >
> > * Colin Cross <ccross@android.com> [130109 18:05]:
> > > +static void watchdog_check_hardlockup_other_cpu(void)
> > > +{
> > > +     int cpu;
> > > +     cpumask_t cpus = watchdog_cpus;
> > > +
> > > +     /*
> > > +      * Test for hardlockups every 3 samples.  The sample period is
> > > +      *  watchdog_thresh * 2 / 5, so 3 samples gets us back to slightly over
> > > +      *  watchdog_thresh (over by 20%).
> > > +      */
> > > +     if (__this_cpu_read(hrtimer_interrupts) % 3 != 0)
> > > +             return;
> > > +
> > > +     /* check for a hardlockup on the next cpu */
> > > +     cpu = cpumask_next(smp_processor_id(), &cpus);
> >
> > Hmm don't you want to check cpu_oneline_mask here and
> > return if the other CPU is offline?
> 
> watchdog_cpus is effectively a local copy of cpu_online_mask, but
> updated after the watchdog_nmi_touch in watchdog_nmi_enable.  This
> avoids a false positive after hotplugging in a cpu when
> cpu_online_mask is true but that cpu hasn't yet run it's first
> hrtimer.

OK thanks for clarifying that.

Tony
