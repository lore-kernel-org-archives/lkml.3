Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915Ab3D3QCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:02:14 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60646 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3D3QCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:02:11 -0400
X-Nat-Received: from [202.181.97.72]:60219 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1367337721.30970
To: cl@linux.com
Cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com>
	<201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
	<0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com>
	<201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp>
	<0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com>
In-Reply-To: <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com>
Message-Id: <201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 1 May 2013 01:01:58 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 30042013 #9858965, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 30 Apr 2013, Tetsuo Handa wrote:
> 
> > The testcases still trigger BUG() at 32M:
> 
> I thought we established that MAX_ORDER only allows a maximum of 8M sized
> allocations? Why are you trying 32M?

Only for regression testing. At least until Linux 3.9, requesting too large
size didn't trigger oops, did it? I'm not expecting kmalloc() to trigger oops
for Linux 3.10 and future kernels.

> 
> The BUG() should trigger for these allocations.
> 

"kmalloc() returning NULL for these allocations" is needed by "try kmalloc()
first, fallback to vmalloc()" allocation. There are kernel modules which expect
kmalloc() to return NULL rather than oops when the requested size is larger
than KMALLOC_MAX_SIZE bytes. If kmalloc() suddenly starts triggering oops, such
modules will break.



Anyway, there is a regression we want to fix : we won't be able to boot
Linux 3.10-rc1 for x86_32 built with CONFIG_DEBUG_SLAB=y &&
CONFIG_DEBUG_SPINLOCK=y && CONFIG_DEBUG_PAGEALLOC=y .
("Fix off by one error in slab.h" did not fix the regression.)

Regards.
