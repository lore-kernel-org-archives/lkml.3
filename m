Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaEBLQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 07:16:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34651 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaEBLQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 07:16:55 -0400
Message-ID: <1399029411.5233.133.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Fri, 02 May 2014 13:16:51 +0200
In-Reply-To: <20140502100951.GC9178@linutronix.de>
References: <20140411185739.GA6644@linutronix.de>
	 <1397918766.5436.16.camel@marge.simpson.net>
	 <20140502100951.GC9178@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 12:09 +0200, Sebastian Andrzej Siewior wrote: 
> * Mike Galbraith | 2014-04-19 16:46:06 [+0200]:
> 
> >Hi Sebastian,
> Hi Mike,
> 
> >This hunk in hotplug-light-get-online-cpus.patch looks like a bug.
> >
> >@@ -333,7 +449,7 @@ static int __ref _cpu_down(unsigned int
> >                /* CPU didn't die: tell everyone.  Can't complain. */
> >                smpboot_unpark_threads(cpu);
> >                cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
> >-               goto out_release;
> >+               goto out_cancel;
> >        }
> >        BUG_ON(cpu_online(cpu));
> 
> Yes, it looks like it. v3.12-rt did not have this…

I just sent a set of dinky patches with which patch to fold them into,
along with my way of dealing with the new stopper_lock.

-Mike

