Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3AOAZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:25:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3AOAZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:25:05 -0500
Date: Mon, 14 Jan 2013 16:25:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Colin Cross <ccross@android.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        liu chuansheng <chuansheng.liu@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2] hardlockup: detect hard lockups without NMIs using
 secondary cpus
Message-Id: <20130114162504.e667a4be.akpm@linux-foundation.org>
In-Reply-To: <CAMbhsRR29Zhje9mGtUwHfUsX+eFsggYkVMHPyQ+zgrGUp_rqTQ@mail.gmail.com>
References: <1357941108-14138-1-git-send-email-ccross@android.com>
	<20130114154914.6d69eb27.akpm@linux-foundation.org>
	<CAMbhsRR29Zhje9mGtUwHfUsX+eFsggYkVMHPyQ+zgrGUp_rqTQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013 16:19:23 -0800
Colin Cross <ccross@android.com> wrote:

> >> +static void watchdog_check_hardlockup_other_cpu(void)
> >> +{
> >> +     unsigned int next_cpu;
> >> +
> >> +     /*
> >> +      * Test for hardlockups every 3 samples.  The sample period is
> >> +      *  watchdog_thresh * 2 / 5, so 3 samples gets us back to slightly over
> >> +      *  watchdog_thresh (over by 20%).
> >> +      */
> >> +     if (__this_cpu_read(hrtimer_interrupts) % 3 != 0)
> >> +             return;
> >
> > The hardwired interval Seems Wrong.  watchdog_thresh is tunable at runtime.
> >
> > The comment could do with some fleshing out.  *why* do we want to test
> > at an interval "slightly over watchdog_thresh"?  What's going on here?
> 
> I'll reword it.  We don't want to be slightly over watchdog_thresh,
> ideally we would be exactly at watchdog_thresh.  However, since this
> relies on the hrtimer interrupts that are scheduled at watchdog_thresh
> * 2 / 5, there is no multiple of hrtimer_interrupts that will result
> in watchdog_thresh.  watchdog_thresh * 2 / 5 * 3 (watchdog_thresh *
> 1.2) is the closest I can get to testing for a hardlockup once every
> watchdog_thresh seconds.

It needs more than rewording, doesn't it?  What happens if watchdog_thresh is
altered at runtime?
