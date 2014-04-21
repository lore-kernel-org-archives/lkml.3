Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaDUDbX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 23:31:23 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:60595 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaDUDbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 23:31:21 -0400
Message-ID: <1398051078.4437.6.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Mon, 21 Apr 2014 05:31:18 +0200
In-Reply-To: <1397918766.5436.16.camel@marge.simpson.net>
References: <20140411185739.GA6644@linutronix.de>
	 <1397918766.5436.16.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-04-19 at 16:46 +0200, Mike Galbraith wrote: 
> Hi Sebastian,
> 
> On Fri, 2014-04-11 at 20:57 +0200, Sebastian Andrzej Siewior wrote: 
> > Dear RT folks!
> > 
> > I'm pleased to announce the v3.14-rt1 patch set.
> 
> This hunk in hotplug-light-get-online-cpus.patch looks like a bug.
> 
> @@ -333,7 +449,7 @@ static int __ref _cpu_down(unsigned int
>                 /* CPU didn't die: tell everyone.  Can't complain. */
>                 smpboot_unpark_threads(cpu);
>                 cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
> -               goto out_release;
> +               goto out_cancel;
>         }
>         BUG_ON(cpu_online(cpu));
> 

Another little bug.  This hunk of patches/stomp-machine-raw-lock.patch
should be while (atomic_read(&done.nr_todo)) 

@@ -647,7 +671,7 @@ int stop_machine_from_inactive_cpu(int (
        ret = multi_cpu_stop(&msdata);

        /* Busy wait for completion. */
-       while (!completion_done(&done.completion))
+       while (!atomic_read(&done.nr_todo))
                cpu_relax();

        mutex_unlock(&stop_cpus_mutex);
                                        

