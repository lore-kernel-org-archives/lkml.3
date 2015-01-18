Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbbARLea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:34:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33436 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbbARLe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:34:29 -0500
Message-ID: <54BB9A32.7080703@oracle.com>
Date: Sun, 18 Jan 2015 06:34:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 3/3] mm: catch memory commitment underflow
References: <20140624201606.18273.44270.stgit@zurg> <20140624201614.18273.39034.stgit@zurg>
In-Reply-To: <20140624201614.18273.39034.stgit@zurg>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 04:16 PM, Konstantin Khlebnikov wrote:
> This patch prints warning (if CONFIG_DEBUG_VM=y) when
> memory commitment becomes too negative.
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>

Hi Konstantin,

I seem to be hitting this warning when fuzzing on the latest -next kernel:

[  683.674323] ------------[ cut here ]------------
[  683.675552] WARNING: CPU: 12 PID: 25654 at mm/mmap.c:157 __vm_enough_memory+0x1b7/0x1d0()
[  683.676972] memory commitment underflow
[  683.678212] Modules linked in:
[  683.678219] CPU: 12 PID: 25654 Comm: trinity-c373 Not tainted 3.19.0-rc4-next-20150116-sasha-00054-g4ad498c-dirty #1744
[  683.678227]  ffffffff9c6f7e73 ffff8802c0883a58 ffffffff9b439fb2 0000000000000000
[  683.678231]  ffff8802c0883aa8 ffff8802c0883a98 ffffffff98159e1a ffff8802c0883ae8
[  683.678236]  0000000000000001 0000000000000000 ffffffffffff76f1 ffff8802a9749000
[  683.678243] Call Trace:
[  683.678288] dump_stack (lib/dump_stack.c:52)
[  683.678297] warn_slowpath_common (kernel/panic.c:447)
[  683.678302] warn_slowpath_fmt (kernel/panic.c:461)
[  683.678307] __vm_enough_memory (mm/mmap.c:157 (discriminator 3))
[  683.678317] cap_vm_enough_memory (security/commoncap.c:958)
[  683.678323] security_vm_enough_memory_mm (security/security.c:212)
[  683.678331] shmem_getpage_gfp (mm/shmem.c:1161)
[  683.678337] shmem_write_begin (mm/shmem.c:1495)
[  683.678343] generic_perform_write (mm/filemap.c:2491)
[  683.678447] __generic_file_write_iter (mm/filemap.c:2632)
[  683.678452] generic_file_write_iter (mm/filemap.c:2659)
[  683.678458] do_iter_readv_writev (fs/read_write.c:680)
[  683.678461] do_readv_writev (fs/read_write.c:848)
[  683.678512] vfs_writev (fs/read_write.c:893)
[  683.678515] SyS_writev (fs/read_write.c:926 fs/read_write.c:917)
[  683.678520] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)


Thanks,
Sasha
