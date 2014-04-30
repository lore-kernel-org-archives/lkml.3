Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbaD3P4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:56:40 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:57060 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758931AbaD3P4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:56:38 -0400
Message-ID: <1398873394.7754.1.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>
Date: Wed, 30 Apr 2014 17:56:34 +0200
In-Reply-To: <20140430114819.03e8c6ce@gandalf.local.home>
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
	 <1398869686.26071.151.camel@marge.simpson.net>
	 <20140430111100.72a7a71b@gandalf.local.home>
	 <1398870957.5220.2.camel@marge.simpson.net>
	 <20140430114819.03e8c6ce@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 11:48 -0400, Steven Rostedt wrote: 
> On Wed, 30 Apr 2014 17:15:57 +0200
> Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> 
> > On Wed, 2014-04-30 at 11:11 -0400, Steven Rostedt wrote:
> > 
> > > > Another little bug.  This hunk of patches/stomp-machine-raw-lock.patch
> > > > should be while (atomic_read(&done.nr_todo)) 
> > > > 
> > > > @@ -647,7 +671,7 @@ int stop_machine_from_inactive_cpu(int (
> > > >         ret = multi_cpu_stop(&msdata);
> > > > 
> > > >         /* Busy wait for completion. */
> > > > -       while (!completion_done(&done.completion))
> > > > +       while (!atomic_read(&done.nr_todo))
> >                    ^--- that ! needs to go away 
> > > 
> > > I don't see this in the code. That is, there is no "completion_done()"
> > > in stop_machine_from_inactive_cpu(). It is already an atomic_read().
> > 
> > Yes, but it should read "while (atomic_read(&done.nr_todo))"
> 
> Ah, this would have been better if you had sent a patch. I misread what
> you talked about.
> 
> Yes, this was the culprit of my failures. After removing the '!', it
> worked.
> 
> Care to send a patch :-)

I figured those two were just edit patch, done, but yeah, I can do that.

-Mike

