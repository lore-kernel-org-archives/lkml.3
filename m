Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab3D2P22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:28:28 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65291 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3D2P21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:28:27 -0400
X-Nat-Received: from [202.181.97.72]:50969 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1367249297.30690
To: cl@linux.com, glommer@parallels.com
Cc: penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201304252120.GII21814.FMJFtHLOOVQFOS@I-love.SAKURA.ne.jp>
	<201304291140.IFJ95894.OFLSFFHQOOMVJt@I-love.SAKURA.ne.jp>
	<CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com>
	<517E8758.9040803@parallels.com>
	<0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com>
In-Reply-To: <0000013e564e0e5a-121c52f9-e489-470f-99d5-67a5ad42eb75-000000@email.amazonses.com>
Message-Id: <201304300028.IAD13051.OHOVMJSLFFFQOt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 30 Apr 2013 00:28:13 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 29042013 #9855340, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> If I am right, the following (untested) patch should solve the problem.

This patch did not help;

  kmalloc(8 * 1024 * 1024, GFP_KERNEL)

still causes both

  include/linux/slab_def.h:136: warning: array subscript is above array bounds

and

  BUG: unable to handle kernel NULL pointer dereference at 00000058
  IP: [<c10b9d76>] kmem_cache_alloc+0x26/0xb0

.

Christoph Lameter wrote:
> What is MAX_ORDER on the architecture?

In my environment (x86_32), the constants are

  MAX_ORDER=11 PAGE_SHIFT=12 KMALLOC_SHIFT_HIGH=22 KMALLOC_MAX_SIZE=4194304
