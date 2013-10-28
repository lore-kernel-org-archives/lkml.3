Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab3J1RrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:47:07 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55765 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab3J1RrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:47:03 -0400
Date: Mon, 28 Oct 2013 13:46:30 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131028174630.GB31048@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <20131012172124.GA18241@gmail.com>
 <20131014202854.GH26880@hmsreliant.think-freely.org>
 <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
 <20131017003421.GA31470@hmsreliant.think-freely.org>
 <20131017084121.GC22705@gmail.com>
 <20131028160131.GA31048@hmsreliant.think-freely.org>
 <20131028162438.GB14350@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028162438.GB14350@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 05:24:38PM +0100, Ingo Molnar wrote:
> 
> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Looking at the specific cpu counters we get this:
> > 
> > Base:
> >      Total time: 0.179 [sec]
> > 
> >  Performance counter stats for 'perf bench sched messaging -- bash -c echo 1 > /sys/module/csum_test/parameters/test_fire' (20 runs):
> > 
> >        1571.304618 task-clock                #    5.213 CPUs utilized            ( +-  0.45% )
> >             14,423 context-switches          #    0.009 M/sec                    ( +-  4.28% )
> >              2,710 cpu-migrations            #    0.002 M/sec                    ( +-  2.83% )
> 
> Hm, for these second round of measurements were you using 'perf stat 
> -a -C ...'?
> 
> The most accurate method of measurement for such single-threaded 
> workloads is something like:
> 
> 	taskset 0x1 perf stat -a -C 1 --repeat 20 ...
> 
> this will bind your workload to CPU#0, and will do PMU measurements 
> only there - without mixing in other CPUs or workloads.
> 
> Thanks,
> 
> 	Ingo
I wasn't, but I will...
Neil

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
