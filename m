Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbaFYPyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:54:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887AbaFYPyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:54:53 -0400
Date: Wed, 25 Jun 2014 17:54:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org, tj@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, akpm@linux-foundation.org,
        andi@firstfloor.org, paulmck@linux.vnet.ibm.com, pavel@ucw.cz,
        jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>
Subject: Re: [PATCH 00/21] kGraft
In-Reply-To: <20140625135421.67cd5f5f@alan.etchedpixels.co.uk>
Message-ID: <alpine.LNX.2.00.1406251748170.15939@pobox.suse.cz>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz> <20140625135421.67cd5f5f@alan.etchedpixels.co.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, One Thousand Gnomes wrote:

> > this is a repost of the second round of RFC on kGraft, the linux
> > kernel online patching developed at SUSE. This repost only widened the
> > target audience for broader review, no code change happened.
> 
> -		wait_event_freezable(khubd_wait,
> +		wait_event_freezable(khubd_wait,
>   ({ kgr_task_safe(current);
> 
> The changes are somewhat ugly with all the kgraft crap leaking into plces
> like jbd and freezer and usb. That says to me its not well isolated and
> there must be a better way of hiding that kgr stuff so we don't have to
> kepe putting more code into all the kthreads, and inevitably missing them
> or have people getting it wrong.

Tejun commented on this very issue during the first RFC submission a 
couple weeks ago. Part of his proposal was actually to take this as a good 
pretext to review the existing kernel threads, as the idea is that a big 
portion of those could easily be converted to workqueues.

It of course has its own implications, such as not being able to 
prioritize that easily, but there is probably a lot of low-hanging fruits 
where driver authors and their grandmas have been creating kthreads where 
workqueue would suffice.

But it's a very long term goal, and it's probably impractical to make 
kGraft dependent on it.

> You add instructions to various hotpaths (despite the CONFIG comment).

Kernel entry is hidden behind _TIF_WORK_SYSCALL_ENTRY and 
_TIF_ALLWORK_MASK, so it doesn't add any overhead if kGraft is not 
enabled. What other hot paths do you refer to?

> Don't get me wrong - I'd like a good working ksplice/graft !

Thanks Alan,

-- 
Jiri Kosina
SUSE Labs
