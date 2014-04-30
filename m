Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbaD3Ps1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:48:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:21587 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759333AbaD3PsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:48:23 -0400
Date: Wed, 30 Apr 2014 11:48:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [ANNOUNCE] 3.14-rt1
Message-ID: <20140430114819.03e8c6ce@gandalf.local.home>
In-Reply-To: <1398870957.5220.2.camel@marge.simpson.net>
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
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014 17:15:57 +0200
Mike Galbraith <umgwanakikbuti@gmail.com> wrote:

> On Wed, 2014-04-30 at 11:11 -0400, Steven Rostedt wrote:
> 
> > > Another little bug.  This hunk of patches/stomp-machine-raw-lock.patch
> > > should be while (atomic_read(&done.nr_todo)) 
> > > 
> > > @@ -647,7 +671,7 @@ int stop_machine_from_inactive_cpu(int (
> > >         ret = multi_cpu_stop(&msdata);
> > > 
> > >         /* Busy wait for completion. */
> > > -       while (!completion_done(&done.completion))
> > > +       while (!atomic_read(&done.nr_todo))
>                    ^--- that ! needs to go away 
> > 
> > I don't see this in the code. That is, there is no "completion_done()"
> > in stop_machine_from_inactive_cpu(). It is already an atomic_read().
> 
> Yes, but it should read "while (atomic_read(&done.nr_todo))"

Ah, this would have been better if you had sent a patch. I misread what
you talked about.

Yes, this was the culprit of my failures. After removing the '!', it
worked.

Care to send a patch :-)

-- Steve
