Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaCJOmC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:42:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbaCJOmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:42:01 -0400
Date: Mon, 10 Mar 2014 15:41:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: i915 resume-from-hibernation problems on resume with current
 Linus' tree
In-Reply-To: <CAKMK7uG1PG=h8uiofNXt_-GOGgL354skaQeqA5OxK4VbYk2Vkg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1403101540140.3690@pobox.suse.cz>
References: <alpine.LNX.2.00.1402271153480.21399@pobox.suse.cz> <alpine.LNX.2.00.1403031519500.7030@pobox.suse.cz> <alpine.LNX.2.00.1403101525220.3690@pobox.suse.cz> <CAKMK7uG1PG=h8uiofNXt_-GOGgL354skaQeqA5OxK4VbYk2Vkg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014, Daniel Vetter wrote:

> >> > *ERROR* render ring initialization failed ctl 0001f001 head 00003004 tail 00000000 start 00003000
> >> >
> >> > as it doesn't seem to be there in case of resumption that works properly.
> >> >
> >> > Please see the dmesg from the broken case below.
> >>
> >> I encountered this again with -rc5.
> >>
> >> If there is anything I can do to help debug this, please let me know.
> >
> > I hate to be doing this, but ... ping? :)
> 
> gm45 and rendering ring init failures. We've seen this occasionally
> crop up due to rather unrelated changes. Some even hit stable
> backports and had to be backed out again. We essentially have no clue
> what's amiss, but it seems to /mostly/ work. Thus far I've only hear
> reports of this for gm45 and not yet really for upstream. Until
> someone digs up more evidence I think we need to classify this as a
> rare heisenbug and not really a regression :(

Thanks for getting back to me with this, Daniel.

Well, this started to be rather regular sometime during the 3.14 
development cycle on my system.

I am able to reproduce it after ~20 suspend-resume cycles. Which is rather 
inconvenient for bisect, but enough for making the kernel unusable on that 
system.

> One thing we could try is to simply repeat the ring init setup, maybe
> after a gpu reset or something like that.

Will be happy to test any patches.

Thanks,

-- 
Jiri Kosina
SUSE Labs
