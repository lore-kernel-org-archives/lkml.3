Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaDSOqO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 10:46:14 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:46704 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaDSOqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 10:46:10 -0400
Message-ID: <1397918766.5436.16.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Sat, 19 Apr 2014 16:46:06 +0200
In-Reply-To: <20140411185739.GA6644@linutronix.de>
References: <20140411185739.GA6644@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Fri, 2014-04-11 at 20:57 +0200, Sebastian Andrzej Siewior wrote: 
> Dear RT folks!
> 
> I'm pleased to announce the v3.14-rt1 patch set.

This hunk in hotplug-light-get-online-cpus.patch looks like a bug.

@@ -333,7 +449,7 @@ static int __ref _cpu_down(unsigned int
                /* CPU didn't die: tell everyone.  Can't complain. */
                smpboot_unpark_threads(cpu);
                cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
-               goto out_release;
+               goto out_cancel;
        }
        BUG_ON(cpu_online(cpu));


> x86-64 crashed after I started hackbench. I figured out that the crash
> does not happen with lazy-preempt disabled. Therefore the last but one
> patch in the queue disables lazy preempt on x86-64. With this change the
> test box survived ~2h without a crash. I look at this later but it looks
> good now.

Ah, I had trouble there a while back too.  I'll try to scrape up cycles
for a round 2, see who begs for mercy this time, it or me again.

-Mike

