Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934286AbaJ2PwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:52:23 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:43658 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933498AbaJ2PwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:52:21 -0400
X-Originating-IP: 50.43.41.112
Date: Wed, 29 Oct 2014 08:52:09 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: linux-next: manual merge of the tiny tree with the tip tree
Message-ID: <20141029155209.GA7287@thin>
References: <20140923143232.5ffff46e@canb.auug.org.au>
 <20140923054328.GA28790@gmail.com>
 <20140923062125.GB6900@thin>
 <20140923083603.GA31876@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923083603.GA31876@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 10:36:03AM +0200, Ingo Molnar wrote:
> * Josh Triplett <josh@joshtriplett.org> wrote:
> > I've dropped tiny/no-io from tiny/next; I'll poke at it further 
> > and resubmit for the x86 tree later, likely not for the next 
> > merge window at this point.
> > 
> > Thanks for the feedback on process; this is day 1 of having a 
> > merge-window-bound tree in -next for the first time. :)
> 
> Sorry about the harshness of my initial email - I was unsure 
> about the background and we are close to the merge window. I have 
> no objections against the -tiny tree in linux-next, it's a good 
> effort.
> 
> I think we could cut down on the #ifdef uglies if we made the 
> ioperm callback pointer unconditional. That's just a tiny amount 
> of extra bloat, but should remove half of the #ifdefs or so? The 
> rest of the patches look fine.

I've revised the patch to eliminate quite a few #ifdefs, and in
particular almost all of those in .c files, by adding a macro
INIT_SET_IOPL_MASK to use in place of the initializer for set_iopl_mask,
and using __maybe_unused rather than wrapping function definitions in
#ifdef.  I'll send a new version momentarily.

> Usually hpa handles the x86 ioperm area, but he's swamped right 
> now, so I'll look at picking them up once you have submitted the 
> latest version. If you send it in the next day or two then they 
> could make the v3.18 merge window.

Other things came up (LinuxCon / Plumbers), but hopefully the new
version can go into 3.19.

- Josh Triplett
