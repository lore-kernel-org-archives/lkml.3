Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3J2Lah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:30:37 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45040 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3J2Laf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:30:35 -0400
Date: Tue, 29 Oct 2013 12:30:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131029113031.GA16897@gmail.com>
References: <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
 <20131017003421.GA31470@hmsreliant.think-freely.org>
 <20131017084121.GC22705@gmail.com>
 <20131028160131.GA31048@hmsreliant.think-freely.org>
 <20131028162438.GB14350@gmail.com>
 <20131028174630.GB31048@hmsreliant.think-freely.org>
 <20131028182913.GD31048@hmsreliant.think-freely.org>
 <20131029082542.GA24625@gmail.com>
 <20131029112022.GA24477@neilslaptop.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029112022.GA24477@neilslaptop.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Horman <nhorman@tuxdriver.com> wrote:

> Sure it was this:
> for i in `seq 0 1 3`
> do
> echo $i > /sys/module/csum_test/parameters/module_test_mode
> taskset -c 0 perf stat --repeat 20 -C 0 -ddd perf bench sched messaging -- /root/test.sh
> done >> counters.txt 2>&1
> 
> where test.sh is:
> #!/bin/sh
> echo 1 > /sys/module/csum_test/parameters/test_fire

What does '-- /root/test.sh' do?

Unless I'm missing something, the line above will run:

  perf bench sched messaging -- /root/test.sh

which should be equivalent to:

  perf bench sched messaging

i.e. /root/test.sh won't be run.

Thanks,

	Ingo
