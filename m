Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab3K2XZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 18:25:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3K2XZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 18:25:04 -0500
Date: Sat, 30 Nov 2013 00:24:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
In-Reply-To: <20131129200532.GA13561@redhat.com>
Message-ID: <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Nov 2013, Oleg Nesterov wrote:

> > > Andi, et al. I am going to discuss the things I do not really
> > > understand, probably this can't make any sense, but...
> >
> > I think it's enough to set the dirty bit in the underlying
> > struct page, no need to play games with the PTE.
> 
> Ah, sorry for confusion, I guess you misunderstood.
> 
> I meant, perhaps sys_text_poke() doesn't the in-kernel text_poke
> machinery altogether?
> 
> Can't we invalidate pte (so that any user will stuck in page fault),
> update the page(s), restore the pte and drop the locks?

Do you think this'd be faster than the int3-based aproach?

We have moved from using stop_machine() to int3-based patching exactly 
because it's much more lightweight.

> This way sys_text_poke() won't be x86-specific, and it will be per-mm.

Good point, it'd be really nice to have this as an alternative on archs 
where breakpoint-based patching wouldn't be possible for some reason.

-- 
Jiri Kosina
SUSE Labs
