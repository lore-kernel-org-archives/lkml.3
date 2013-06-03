Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab3FCLat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:30:49 -0400
Received: from mailhub.stratus.com ([134.111.1.18]:54800 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3FCLar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:30:47 -0400
Date: Mon, 3 Jun 2013 07:25:49 -0400 (EDT)
From: Joe Lawrence <joe.lawrence@stratus.com>
X-X-Sender: jlaw@jlaw-desktop.mno.stratus.com
To: Joe Lawrence <joe.lawrence@stratus.com>
cc: Rusty Russell <rusty@rustcorp.com.au>,
        Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: Re: Please add to stable:  module: don't unlink the module until
 we've removed all exposure.
In-Reply-To: <alpine.DEB.2.02.1306022212200.10003@jlaw-desktop.mno.stratus.com>
Message-ID: <alpine.DEB.2.02.1306030724230.19647@jlaw-desktop.mno.stratus.com>
References: <51A8E884.1080009@candelatech.com> <87ehclumhr.fsf@rustcorp.com.au> <alpine.DEB.2.02.1306022212200.10003@jlaw-desktop.mno.stratus.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 03 Jun 2013 11:29:29.0312 (UTC) FILETIME=[9C67CE00:01CE604D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[fixing Cc: stable@kernel.org address]

On Sun, 2 Jun 2013, Joe Lawrence wrote:

> On Sun, 2 Jun 2013, Rusty Russell wrote:
> 
> > Ben Greear <greearb@candelatech.com> writes:
> > 
> > > It turns out, the bug I spent yesterday chasing in various 3.9 kernels is apparently
> > > fixed by the commit in the title (c9c390bb5535380d40614571894ef0c00bc026ff).
> > 
> > Apparently being the operative word.
> > 
> > This commit avoids the entire "module insert failed due to sysfs race"
> > path in the common case, it doesn't fix any actual problem.
> > 
> > I think the real commit you want is Linus' kobject fix
> > a49b7e82cab0f9b41f483359be83f44fbb6b4979 "kobject: fix kset_find_obj()
> > race with concurrent last kobject_put()".
> > 
> > Or is that already in stable?
> 
> Hi Rusty,
>  
> I had pointed Ben (offlist) to that bugzilla entry without realizing
> there were other earlier related fixes in this space.  Re-viewing bz-
> 58011, it looks like it was opened against 3.8.12, while Ben and myself
> had encountered module loading problems in versions 3.9 and
> 3.9.[1-3].  I can update the bugzilla entry to add a comment noting commit
> a49b7e82 "kobject: fix kset_find_obj() race with concurrent last
> kobject_put()".
> 
> That said, it doesn't appear that commit 944a1fa "module: don't unlink the
> module until we've removed all exposure" has not made it into any stable  
> kernel.  On my system, applying this on top of 3.9 resolved a module
> unload/load race that would occasionally occur on boot (two video adapters
> of the same make, the module unloads for whatever reason and I see "module
> is already loaded" and "sysfs: cannot create duplicate filename
> '/module/mgag200'" messages every 5-10% instances.)  I have logs if you
> were interested in these warnings/crashes.
> 
> Hope this clarifies things.
> 
> Regards,
> 
> -- Joe
> 
