Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbaD3Oyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:54:52 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:41853 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834AbaD3Oyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:54:50 -0400
Message-ID: <1398869686.26071.151.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>
Date: Wed, 30 Apr 2014 16:54:46 +0200
In-Reply-To: <20140430103308.1e46dd18@gandalf.local.home>
References: <20140411185739.GA6644@linutronix.de>
	 <1397918766.5436.16.camel@marge.simpson.net>
	 <1398411635.11930.45.camel@marge.simpson.net>
	 <1398501491.12941.5.camel@marge.simpson.net>
	 <1398520699.28726.22.camel@marge.simpson.net>
	 <1398661784.30930.33.camel@marge.simpson.net>
	 <1398676186.30930.49.camel@marge.simpson.net>
	 <20140428101805.75032f45@gandalf.local.home>
	 <1398695832.14475.10.camel@marge.simpson.net>
	 <1398748869.5514.81.camel@marge.simpson.net>
	 <20140429201308.63292691@gandalf.local.home>
	 <1398843793.26071.52.camel@marge.simpson.net>
	 <1398863189.26071.97.camel@marge.simpson.net>
	 <20140430091550.1177bc90@gandalf.local.home>
	 <1398866403.26071.125.camel@marge.simpson.net>
	 <20140430101919.70b2f622@gandalf.local.home>
	 <20140430103308.1e46dd18@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 10:33 -0400, Steven Rostedt wrote: 
> On Wed, 30 Apr 2014 10:19:19 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > I'm testing it now. But could you please post them as regular patches.
> > They were attachments to this thread, and were not something that stood
> > out.
> 
> With your two patches, it still crashes exactly the same way. I
> probably should remove my debug just in case, but I think this box has
> another problem with it.

You killed this hunk of hotplug-light-get-online-cpus.patch

@@ -333,7 +449,7 @@ static int __ref _cpu_down(unsigned int
                /* CPU didn't die: tell everyone.  Can't complain. */
                smpboot_unpark_threads(cpu);
                cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
-               goto out_release;
+               goto out_cancel;
        }
        BUG_ON(cpu_online(cpu));

..and fixed this too?

Another little bug.  This hunk of patches/stomp-machine-raw-lock.patch
should be while (atomic_read(&done.nr_todo)) 

@@ -647,7 +671,7 @@ int stop_machine_from_inactive_cpu(int (
        ret = multi_cpu_stop(&msdata);

        /* Busy wait for completion. */
-       while (!completion_done(&done.completion))
+       while (!atomic_read(&done.nr_todo))
                cpu_relax();

        mutex_unlock(&stop_cpus_mutex);

