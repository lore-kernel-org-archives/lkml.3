Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab3D3R15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 13:27:57 -0400
Received: from a9-62.smtp-out.amazonses.com ([54.240.9.62]:38869 "EHLO
	a9-62.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932772Ab3D3R1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 13:27:55 -0400
Date: Tue, 30 Apr 2013 17:27:53 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp>
Message-ID: <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com>
References: <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com> <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp> <0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com>
 <201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp> <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com> <201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.30-54.240.9.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 1 May 2013, Tetsuo Handa wrote:

> Christoph Lameter wrote:
> > On Tue, 30 Apr 2013, Tetsuo Handa wrote:
> >
> > > The testcases still trigger BUG() at 32M:
> >
> > I thought we established that MAX_ORDER only allows a maximum of 8M sized
> > allocations? Why are you trying 32M?
>
> Only for regression testing. At least until Linux 3.9, requesting too large
> size didn't trigger oops, did it? I'm not expecting kmalloc() to trigger oops
> for Linux 3.10 and future kernels.

It did for SLUB. SLAB returned NULL for some cases.

> "kmalloc() returning NULL for these allocations" is needed by "try kmalloc()
> first, fallback to vmalloc()" allocation. There are kernel modules which expect
> kmalloc() to return NULL rather than oops when the requested size is larger
> than KMALLOC_MAX_SIZE bytes. If kmalloc() suddenly starts triggering oops, such
> modules will break.

This behavior has been in there for years. Why try a kmalloc that
always fails since the size is too big?

> Anyway, there is a regression we want to fix : we won't be able to boot
> Linux 3.10-rc1 for x86_32 built with CONFIG_DEBUG_SLAB=y &&
> CONFIG_DEBUG_SPINLOCK=y && CONFIG_DEBUG_PAGEALLOC=y .
> ("Fix off by one error in slab.h" did not fix the regression.)

Hmm... Where does this fail? In slab?


