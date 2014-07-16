Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaGPVeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:34:18 -0400
Received: from infernal.debian.net ([176.28.9.132]:35094 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaGPVeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:34:12 -0400
Date: Wed, 16 Jul 2014 23:34:08 +0200
From: Andreas Bombe <aeb@debian.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REGRESSION] Boot hang with 939f04bec printk: enable interrupts
 before calling console_trylock_for_printk()
Message-ID: <20140716213408.GA8749@amos.fritz.box>
References: <20140628225050.GA3484@amos.fritz.box>
 <20140714083527.GA30550@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714083527.GA30550@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:35:27AM +0200, Jan Kara wrote:
> On Sun 29-06-14 00:50:50, Andreas Bombe wrote:
> > None of the post 3.15 kernel boot for me. They all hang at the GRUB
> > screen telling me it loaded and started the kernel, but the kernel
> > itself stops before it prints anything (or even replaces the GRUB
> > background graphics).
> > 
> > I bisected it down to 939f04bec1a4ef6ba4370b0f34b01decc844b1b1 "printk:
> > enable interrupts before calling console_trylock_for_printk()".
> > Reverting that patch on the latest kernel (git 24b414d5a7) allows me to
> > boot normally. I fixed the conflict in the revert by leaving in the "if
> > (in_sched) return printed_len;".
> > 
> > I have the "early printk via the EFI framebuffer" option enabled,
> > disabling it made no difference however.
>   Thanks for report. I've been on vacation so I'm replying with a delay. I
> believe this is one of the issues where this patch just uncovers underlying
> problem - I belive lockdep tries to report some locking issue in console
> driver code (this patch increased lockdep coverage of console driver code)
> however we are holding some locks in printk code which make lockdep
> deadlock. Can you try running with the attached patch?

EUNABLE

You forgot to attach a patch.
