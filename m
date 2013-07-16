Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab3GPBFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:05:45 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64737 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab3GPBFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:05:44 -0400
Date: Tue, 16 Jul 2013 03:05:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nohz: Warn if the machine can not perform nohz_full
Message-ID: <20130716010538.GD13562@somewhere>
References: <20130715170859.GA25570@redhat.com>
 <20130715171800.GD6442@somewhere>
 <20130715172423.GA27745@redhat.com>
 <20130715173848.GA1066@redhat.com>
 <1373914182.17876.165.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373914182.17876.165.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 02:49:42PM -0400, Steven Rostedt wrote:
> On Mon, 2013-07-15 at 13:38 -0400, Dave Jones wrote:
> > On Mon, Jul 15, 2013 at 01:24:23PM -0400, Dave Jones wrote:
> >  > On Mon, Jul 15, 2013 at 07:18:02PM +0200, Frederic Weisbecker wrote:
> >  >  
> >  >  > > So I guess you guys never want this to be enabled on distro kernels ?
> >  >  > > If that's the case, can you add something to that effect in Kconfig ?
> >  >  > 
> >  >  > I believe we want it to be enabled on distros in the long term. But right now it would
> >  >  > be a bad idea until the off case (nohz_full= parameter empty) is carefully optimized.
> >  >  > I'm currently working on that.
> >  >  > 
> >  >  > Now for the unstable tsc, which is what it's about on the above code block, we need
> >  >  > the tick to be there to leverage the sched clock madness. May be there could be some
> >  >  > other solution that could work along full dynticks but for now we chose the easy path.
> >  >  > 
> >  >  > Are broken TSCs that common?
> >  >  
> >  > I just hit one apparently.  http://paste.fedoraproject.org/25421/73907845/raw/
> >  > That's a fairly recent Atom board, so I suspect it's not uncommon on that platform.
> > 
> > And here's a Core Duo from circa 2008.
> > http://paste.fedoraproject.org/25429/13739098/raw
> > 
> > Two for two so far. I get the feeling you guys are going to get a ton of these reports.
> > 
> 
> Hmm, we should only warn if the user tried to enable nohz-full via the
> command line. But it looks like it warns even without enabling
> nohz-full, which wasn't the desired effect.
> 
> I'll look at this, and send a patch to make sure the warning only
> happens when the user tries to use nohz-full, and doesn't just compile
> it in. The point of the patch is to not let the user think they have
> nohz-full when they don't.

Great! I'll wait for your patch then.
