Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaGCA5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 20:57:22 -0400
Received: from infernal.debian.net ([176.28.9.132]:38286 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbaGCA5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 20:57:20 -0400
Date: Thu, 3 Jul 2014 02:57:15 +0200
From: Andreas Bombe <aeb@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [REGRESSION] Boot hang with 939f04bec printk: enable interrupts
 before calling console_trylock_for_printk()
Message-ID: <20140703005715.GA3626@amos.fritz.box>
References: <20140628225050.GA3484@amos.fritz.box>
 <20140630132030.fa6ac8c8f040e6f5b05071f3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630132030.fa6ac8c8f040e6f5b05071f3@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 01:20:30PM -0700, Andrew Morton wrote:
> On Sun, 29 Jun 2014 00:50:50 +0200 Andreas Bombe <aeb@debian.org> wrote:
> 
> > None of the post 3.15 kernel boot for me. They all hang at the GRUB
> > screen telling me it loaded and started the kernel, but the kernel
> > itself stops before it prints anything (or even replaces the GRUB
> > background graphics).
> > 
> > I bisected it down to 939f04bec1a4ef6ba4370b0f34b01decc844b1b1 "printk:
> > enable interrupts before calling console_trylock_for_printk()".
> > Reverting that patch on the latest kernel (git 24b414d5a7) allows me to
> > boot normally.
> 
> OK, thanks, I queued the below reversion.  I'll hold off for a week or
> two in case we come up with a fix.
> 
> > I fixed the conflict in the revert by leaving in the "if
> > (in_sched) return printed_len;".
> 
> hm, that might have been buggy - we still need to the lockdep_on() and
> local_irq_restore().  You're a victim of
> someone-stuck-a-random-return-in-the-middle-of-a-function.

To be honest, I just randomly picked one possible conflict resolution to
confirm whether the revert actually helps.

> Please review this and if possible, run-time test it?  Against current
> mainline.

I've applied it (actually I picked the one from your patch series but
they are identical I think) and it does boot. I'm writing this on the
latest kernel + your revert.
