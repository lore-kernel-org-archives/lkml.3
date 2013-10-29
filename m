Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3J2LtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:49:17 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36561 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3J2LtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:49:15 -0400
Date: Tue, 29 Oct 2013 07:49:07 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131029114907.GE24477@neilslaptop.think-freely.org>
References: <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
 <20131017003421.GA31470@hmsreliant.think-freely.org>
 <20131017084121.GC22705@gmail.com>
 <20131028160131.GA31048@hmsreliant.think-freely.org>
 <20131028162438.GB14350@gmail.com>
 <20131028174630.GB31048@hmsreliant.think-freely.org>
 <20131028182913.GD31048@hmsreliant.think-freely.org>
 <20131029082542.GA24625@gmail.com>
 <20131029112022.GA24477@neilslaptop.think-freely.org>
 <20131029113031.GA16897@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029113031.GA16897@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 12:30:31PM +0100, Ingo Molnar wrote:
> 
> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Sure it was this:
> > for i in `seq 0 1 3`
> > do
> > echo $i > /sys/module/csum_test/parameters/module_test_mode
> > taskset -c 0 perf stat --repeat 20 -C 0 -ddd perf bench sched messaging -- /root/test.sh
> > done >> counters.txt 2>&1
> > 
> > where test.sh is:
> > #!/bin/sh
> > echo 1 > /sys/module/csum_test/parameters/test_fire
> 
> What does '-- /root/test.sh' do?
> 
> Unless I'm missing something, the line above will run:
> 
>   perf bench sched messaging -- /root/test.sh
> 
> which should be equivalent to:
> 
>   perf bench sched messaging
> 
> i.e. /root/test.sh won't be run.
> 
According to the perf man page, I'm supposed to be able to use -- to separate
perf command line parameters from the command I want to run.  And it definately
executed test.sh, I added an echo to stdout in there as a test run and observed
them get captured in counters.txt

Neil

> Thanks,
> 
> 	Ingo
> 
