Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbaBEIKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:10:53 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52339 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaBEIKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:10:51 -0500
Date: Wed, 5 Feb 2014 00:10:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fengguang Wu <fengguang.wu@intel.com>
cc: Peter Zijlstra <peterz@infradead.org>, Pekka Enberg <penberg@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [slub] WARNING: CPU: 1 PID: 1 at mm/slub.c:992
 deactivate_slab()
In-Reply-To: <20140205072558.GC9379@localhost>
Message-ID: <alpine.DEB.2.02.1402050009200.7839@chino.kir.corp.google.com>
References: <20140205072558.GC9379@localhost>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Fengguang Wu wrote:

> Greetings,
> 
> I got the below dmesg and the first bad commit is in upstream 
> 
> commit c65c1877bd6826ce0d9713d76e30a7bed8e49f38
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Fri Jan 10 13:23:49 2014 +0100
> Commit:     Pekka Enberg <penberg@kernel.org>
> CommitDate: Mon Jan 13 21:34:39 2014 +0200
> 
>     slub: use lockdep_assert_held
>     
>     Instead of using comments in an attempt at getting the locking right,
>     use proper assertions that actively warn you if you got it wrong.
>     
>     Also add extra braces in a few sites to comply with coding-style.
>     
>     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>     Signed-off-by: Pekka Enberg <penberg@kernel.org>
> 
> ===================================================
> PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> ===================================================
> 
> +---------------------------------------------------------+--------------+--------------+
> |                                                         | 8afb1474db47 | 1738cc0ecc54 |
> +---------------------------------------------------------+--------------+--------------+
> | boot_successes                                          | 166          | 6            |
> | boot_failures                                           | 10           | 13           |
> | BUG:kernel_test_crashed                                 | 9            | 1            |
> | WARNING:CPU:PID:at_arch/x86/kernel/cpu/amd.c:init_amd() | 1            |              |
> | WARNING:CPU:PID:at_mm/slub.c:deactivate_slab()          | 0            | 12           |
> +---------------------------------------------------------+--------------+--------------+
> 
> [1868680.126265] netconsole: network logging started
> [1868680.135018] Unregister pv shared memory for cpu 0
> [1868680.523086] ------------[ cut here ]------------
> [1868680.526909] WARNING: CPU: 1 PID: 1 at mm/slub.c:992 deactivate_slab+0x4ce/0xa70()
> [1868680.537875] Modules linked in:
> [1868680.541340] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.13.0-02621-g1738cc0 #8
> [1868680.555880] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [1868680.565937]  ffffffff ce04dd64 c1a6323f 00000000 00000000 000003e0 ce04dd94 c106fbe1
> [1868680.572881]  c1efb154 00000001 00000001 c1f09c28 000003e0 c11c2d0e c11c2d0e 00000001
> [1868680.582142]  ce5db280 ce000640 ce04dda4 c106fc7d 00000009 00000000 ce04de0c c11c2d0e
> [1868680.589099] Call Trace:
> [1868680.591109]  [<c1a6323f>] dump_stack+0x7a/0xdb
> [1868680.593887]  [<c106fbe1>] warn_slowpath_common+0x91/0xb0
> [1868680.597430]  [<c11c2d0e>] ? deactivate_slab+0x4ce/0xa70
> [1868680.600510]  [<c11c2d0e>] ? deactivate_slab+0x4ce/0xa70
> [1868680.603588]  [<c106fc7d>] warn_slowpath_null+0x1d/0x20
> [1868680.606728]  [<c11c2d0e>] deactivate_slab+0x4ce/0xa70

Hi Fengguang, 

I think this is the inlined add_full() and should be fixed with 
http://marc.info/?l=linux-kernel&m=139147105027693 that has been added to 
the -mm tree and should now be in next.  Is this patch included for this 
kernel?
