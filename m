Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3D2PMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:12:00 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:34853 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792Ab3D2PL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:11:59 -0400
X-Greylist: delayed 761 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Apr 2013 11:11:59 EDT
Date: Mon, 29 Apr 2013 14:59:16 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <517E8758.9040803@parallels.com>
Message-ID: <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com>
References: <201304242108.FDC35910.VJMHFFFSOLOOQt@I-love.SAKURA.ne.jp> <201304252120.GII21814.FMJFtHLOOVQFOS@I-love.SAKURA.ne.jp> <201304291140.IFJ95894.OFLSFFHQOOMVJt@I-love.SAKURA.ne.jp> <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com>
 <517E8758.9040803@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.02.1304290953202.22648@gentwo.org>
X-SES-Outgoing: 2013.04.29-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, Glauber Costa wrote:

> >> causes no warning at compile time and returns NULL at runtime. But
> >>
> >>   unsigned int size = 8 * 1024 * 1024;
> >>   kmalloc(size, GFP_KERNEL);
> >>
> >> causes compile time warning
> >>
> >>   include/linux/slab_def.h:136: warning: array subscript is above array bounds
> >>
> >> and runtime bug.

SLAB should have support up to 2 << 25 = 1 mb << 5 = 32M

> I believe this is because the code now always assume that the cache is
> found when a constant is passed. Before this patch, we had a "found"
> statement that was mistakenly removed.

The code in kmalloc_index() creates a BUG() and preferentially should
create a compile time failure when a number that is too big is passed to it.

What is MAX_ORDER on the architecture?

An allocation size of more than MAX_ORDER is not supported by the page
allocator or by slab. It is safe to return NULL in that case.

