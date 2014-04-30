Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaD3HnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:43:19 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39930 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaD3HnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:43:16 -0400
Message-ID: <1398843793.26071.52.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>
Date: Wed, 30 Apr 2014 09:43:13 +0200
In-Reply-To: <20140429201308.63292691@gandalf.local.home>
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
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-29 at 20:13 -0400, Steven Rostedt wrote: 
> On Tue, 29 Apr 2014 07:21:09 +0200
> Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> 
> > On Mon, 2014-04-28 at 16:37 +0200, Mike Galbraith wrote: 
> > 
> > > > Seems that migrate_disable() must be called before taking the lock as
> > > > it is done in every other location.
> > > 
> > > And for tasklist_lock, seems you also MUST do that prior to trylock as
> > > well, else you'll run afoul of the hotplug beast.
> > 
> > Bah.  Futzing with dmesg while stress script is running is either a very
> > bad idea, or a very good test.  Both virgin 3.10-rt and 3.12-rt with new
> > bugs squashed will deadlock.
> > 
> > Too bad I kept on testing, I liked the notion that hotplug was solid ;-)
> 
> I was able to stress cpu hotplug on 3.12-rt after applying the
> following patch.
> 
> If there's no complaints about it. I'm going to add this to the 3.12-rt
> stable tree. As without it, it fails horribly with the cpu hotplug
> stress test, and I wont release a stable kernel that does that.

My local boxen are happy, 64 core box with 14-rt seems happy as well,
though I couldn't let it burn for long.

BTW, that dmesg business went into hiding.  I didn't have time to put
virgin 10-rt back on and play around poking both kernels this that and
the other way again, but seems there's some phase-of-moon factor there.

-Mike

