Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3KQJ7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 04:59:09 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:55548 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab3KQJ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 04:59:05 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] coredumps truncated after "new helper: dump_align()"
Date: Sun, 17 Nov 2013 01:59:02 -0800 (PST)
Message-ID: <1963454.uznGuju1ix@al>
User-Agent: KMail/4.11.3 (Linux/3.12.0-custom-09579-g049ffa8; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20131117061907.GL13318@ZenIV.linux.org.uk>
References: <11835033.kIc1RH0rS1@al> <20131116000408.GK13318@ZenIV.linux.org.uk> <20131117061907.GL13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 November 2013 06:19:07 Al Viro wrote:
> On Sat, Nov 16, 2013 at 12:04:08AM +0000, Al Viro wrote:
> > On Fri, Nov 15, 2013 at 10:34:43PM +0100, Peter Wu wrote:
> > 
> >
> > > Unfortunately, this patch still does not fix the issue. I rm'd the
> > > output 
> > > directory just to be sure, but the bug is still there. What does this
> > > commit  do anyway? The commit message is quite vague.
> >
> > 
> >
> > Introduces a helper that used to be open-coded in a bunch of places -
> > pads the coredump to given alignment.  And switches those places
> > to that new helper...
> >
> > 
> >
> > FWIW, I haven't tried that on your config yet, but here (with the patch
> > in my previous mail) I'm seeing a sane-looking coredump -
> > -rw------- 1 root root 315392 Nov 15 17:48 core
> > Different userland, presumably, since that static binary is 684349
> > bytes long.
> >
> > 
> >
> > I'll try to reproduce with your config...
> 
> ... and on your config I'm seeing
> Inited
> Segmentation fault (core dumped)
> [    0.123351] Core size: 315392
> in the log.  Same size, same apparently sane coredump.  Can you check what
> you get on mainline + diff below (combination of dump_align() and locking
> fix)?

Hmm, I cannot reproduce the bug with the two-liner patch you provided before. 
I must have made a mistake with the previous test as the environment is still 
the same.

The bug is fixed with both your two-liner patch and the __kernel_write one.
In addition, the __kernel_write patch removes the lockdep warning reported by 
Dave Jones[1].

Thanks,
Peter

 [1]: http://lkml.org/lkml/2013/11/13/450

