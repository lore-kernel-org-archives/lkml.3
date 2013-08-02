Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3HBADf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 20:03:35 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36778 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3HBADd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 20:03:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1308011215160.4089@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1308011215160.4089@ionos.tec.linutronix.de>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 1 Aug 2013 20:03:01 -0400
X-Google-Sender-Auth: apQYzIeb1eIpJe7Ok3CaoMc-n0M
Message-ID: <CAP=VYLp1ERhS4cFtgXGHL2DfCGoJ9VbPvShH5ZOWCpPuSzQY6w@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.10.4-rt1
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 7:24 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Dear RT folks!
>
> I'm pleased to announce the 3.10.4-rt1 patch set.
>
> This is a mostly straight forward port of the 3.8 set. I had
> experimented with a new implementation detail, but I did not get it
> into a shape which would have made it applicable to RT.
>
> Known issues:
>
>       - SLAB support not working
>
>       - Untested on ARM and PPC (hapless victims^W^Wtesters are
>         welcome)

We break at compile on powerpc with the below.  It happens because
in earlier RT,  we had TIF_NEED_RESCHED_LAZY as bit 14.  But
now, in 3.10 it is 18, and in breaking the 16 barrier, we get this:

arch/powerpc/kernel/entry_32.S: Assembler messages:
arch/powerpc/kernel/entry_32.S:367: Error: operand out of range
(0x000000000004ff87 is not between 0x0000000000000000 and
0x000000000000ffff)
arch/powerpc/kernel/entry_32.S:833: Error: operand out of range
(0x0000000000046006 is not between 0x0000000000000000 and
0x000000000000ffff)
arch/powerpc/kernel/entry_32.S:898: Error: operand out of range
(0x0000000000040000 is not between 0x0000000000000000 and
0x000000000000ffff)
arch/powerpc/kernel/entry_32.S:914: Error: operand out of range
(0x0000000000040004 is not between 0x0000000000000000 and
0x000000000000ffff)
arch/powerpc/kernel/entry_32.S:1236: Error: operand out of range
(0x0000000000040004 is not between 0x0000000000000000 and
0x000000000000ffff)
arch/powerpc/kernel/entry_32.S:1257: Error: operand out of range
(0x0000000000040004 is not between 0x0000000000000000 and
0x000000000000ffff)
arch/powerpc/kernel/entry_32.S:1259: Error: operand out of range
(0x0000000000046006 is not between 0x0000000000000000 and
0x000000000000ffff)
make[1]: *** [arch/powerpc/kernel/entry_32.o] Error 1

I've added Ben to the CC in case he has a suggestion on
how best to fix this, even though it is not yet mainline.

Paul.
--

>
> I'm about to leave for my annual kids summer camp kitchen duty, so I
> let you fool around with the current pile.
>
> Sebastian will help out while I'm away, so please send tons of patches
> in the next couple of days and get this thing fixed before I
> return. All I'm going to look for in my mail backlog is a mail with
> the subject: 3.10.x-rty is perfect :)
>
> The RT patch against 3.10.4 can be found here:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.10.4-rt1.patch.xz
>
> The split quilt queue is available at:
>
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.10.4-rt1.tar.xz
>
> Enjoy,
>
>         tglx
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
