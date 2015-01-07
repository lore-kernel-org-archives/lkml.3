Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbbAGVpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:45:41 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:41548 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbbAGVpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:45:40 -0500
Date: Wed, 7 Jan 2015 13:45:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: linux-next: Tree for Jan 7 (microblaze qemu problems)
Message-ID: <20150107214530.GA27620@roeck-us.net>
References: <20150107151618.7cb9d574@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150107151618.7cb9d574@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54ADA90B.02AA,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 03:16:18PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20150106:
> 
> *crickets*
> 
> Non-merge commits (relative to Linus' tree): 1350
>  1543 files changed, 41856 insertions(+), 24250 deletions(-)
> 

With this kernel I get the following WARNINGs (lots of htem) when running
microblaze images (both big and little endian) with qemu.

WARNING: CPU: 0 PID: 1 at arch/microblaze/kernel/cpu/cache.c:432
__invalidate_dcache_range_msr_irq_wt+0xcc/0xd8()
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 3.19.0-rc3-next-20150107 #1
...
(sample) Call Trace:
[<c0004080>] microblaze_unwind+0x5c/0x78
[<c0003d64>] show_stack+0xe0/0x164
[<c02e2224>] dump_stack+0x20/0x38
[<c000adbc>] warn_slowpath_common+0x90/0xec
[<c000aea0>] warn_slowpath_null+0xc/0x24
[<c000493c>] __invalidate_dcache_range_msr_irq_wt+0xc0/0xd8
[<c00c59c4>] simple_write_begin+0xf8/0x170
[<c005d18c>] generic_perform_write+0xa8/0x2ac
[<c005f1f8>] __generic_file_write_iter+0x1a8/0x478
[<c005f504>] generic_file_write_iter+0x3c/0x128
[<c009b0c4>] new_sync_write+0x84/0xcc
[<c009ba88>] vfs_write+0xe8/0x224
[<c009c314>] SyS_write+0x4c/0xf4
[<c03d5200>] xwrite+0x48/0xb8
[<c03d52a0>] do_copy+0x30/0x1ac
[<c03d47b4>] write_buffer+0x34/0x60
[<c03d4810>] flush_buffer+0x30/0xd0
[<c03e4c70>] gunzip+0x2c0/0x3ac
[<c03d4c20>] unpack_to_rootfs+0x1b8/0x368
[<c03d56e8>] populate_rootfs+0x28/0x2d8
[<c000044c>] do_one_initcall+0xa0/0x24c
[<c03d2d9c>] kernel_init_freeable+0x150/0x238
[<c02dedf0>] kernel_init+0x8/0x14c
[<c0005d78>] ret_from_kernel_thread+0x8/0x20

Detailed logs are available at http://server.roeck-us.net:8010/builders.

bisect results:

# bad: [7e3619a6de57f0257a2f6480182d2287ee05e314] Add linux-next specific files for 20150107
# good: [b1940cd21c0f4abdce101253e860feff547291b0] Linux 3.19-rc3
git bisect start 'HEAD' 'v3.19-rc3'
# bad: [c48667c5659248ff2b2fbff5cd23c43b5768e81b] Merge remote-tracking branch 'net-next/master'
git bisect bad c48667c5659248ff2b2fbff5cd23c43b5768e81b
# bad: [5aa2843082a0ce9b710549bdc7ae8d54140edc70] Merge remote-tracking branch 'pci/next'
git bisect bad 5aa2843082a0ce9b710549bdc7ae8d54140edc70
# good: [11339e9e3d575c1486ff57dc49c83b6154918305] Merge remote-tracking branch 'samsung/for-next'
git bisect good 11339e9e3d575c1486ff57dc49c83b6154918305
# bad: [50d16e144b253542d89830c0ace8573a67ce4b16] Merge remote-tracking branch 'powerpc-mpe/next'
git bisect bad 50d16e144b253542d89830c0ace8573a67ce4b16
# good: [3fda5c0dda2eafe244898809a74831209cdb69b7] Merge remote-tracking branch 'cris/for-next'
git bisect good 3fda5c0dda2eafe244898809a74831209cdb69b7
# bad: [8b772494fda25dd998ade5621cc0684a5c897179] Merge remote-tracking branch 'microblaze/next'
git bisect bad 8b772494fda25dd998ade5621cc0684a5c897179
# bad: [cd2b00db005541d15ea9fbb474b5e5e98b993d8e] microblaze: Fix variable types to remove W=1 warning
git bisect bad cd2b00db005541d15ea9fbb474b5e5e98b993d8e
# good: [8543e6c96762fcc930af5725088c2b9e4865c3aa] microblaze: Use unsigned return type in do_syscall_trace_enter
git bisect good 8543e6c96762fcc930af5725088c2b9e4865c3aa
# good: [e76fdb324844cc0367f8c6ea5d13278a81568ccb] microblaze: Use unsigned type for "for" loop because of comparison-kgdb.c
git bisect good e76fdb324844cc0367f8c6ea5d13278a81568ccb
# bad: [b343c7d621bf801b502cba812c3dcb4320942b93] microblaze: Use unsigned type for limit comparison in cache.c
git bisect bad b343c7d621bf801b502cba812c3dcb4320942b93
# good: [bdb96e3cad21f5973c95f0e6687db4a57eff7c53] microblaze: Use unsigned type for proper comparison in cpuinfo*.c
git bisect good bdb96e3cad21f5973c95f0e6687db4a57eff7c53
# first bad commit: [b343c7d621bf801b502cba812c3dcb4320942b93] microblaze: Use unsigned type for limit comparison in cache.c

Reverting the offending commit fixes the problem.

Guenter
