Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab3HLQ1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:27:34 -0400
Received: from www.sr71.net ([198.145.64.142]:46750 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab3HLQ1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:27:32 -0400
Message-ID: <52090CF2.3040505@sr71.net>
Date: Mon, 12 Aug 2013 09:27:30 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: early boot crash: "alloc_low_page: ran out of memory" (bisected)
References: <520578D0.7020607@intel.com> <CAE9FiQUuPmZfhsHvmsS+_O_VOWMA_OBAexGyRF3eZR1_D3EehA@mail.gmail.com> <52059508.3090405@sr71.net> <CAE9FiQVvo+saJFpx=6A8O7GOns0cR302_GBe4A0a10a4Z0mZyw@mail.gmail.com> <CAE9FiQWn5+XH7cjUjRJNuB747u2-aq3ZpXoPwyZEFYALCxZ30Q@mail.gmail.com>
In-Reply-To: <CAE9FiQWn5+XH7cjUjRJNuB747u2-aq3ZpXoPwyZEFYALCxZ30Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 07:21 PM, Yinghai Lu wrote:
> -/* need 4 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
> -#define INIT_PGT_BUF_SIZE	(5 * PAGE_SIZE)
> +/* need 4 4k for initial PMD_SIZE,  3 4k for 0-ISA_END_ADDRESS */
> +#define INIT_PGT_BUF_SIZE	(7 * PAGE_SIZE)
>  RESERVE_BRK(early_pgt_alloc, INIT_PGT_BUF_SIZE);
>  void  __init early_alloc_pgt_buf(void)

That patch allows me to boot again.  I've also attached a boot with the
debug options that you asked for.

I'm really curious to see the full changelog for why this patch helps
any why it's only triggered for large memory sizes. :)

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
> [    0.000000] Linux version 3.11.0-rc4-00153-g14e9419-dirty (davehans@viggo.jf.intel.com) (gcc version 4.6.3 20120306 (Red Hat 4.6.3-2) (GCC) ) #33 SMP Mon Aug 12 09:22:46 PDT 2013
> [    0.000000] Command line: root=/dev/sda1 console=ttyS0,115200 earlyprintk=ttyS0,115200 debug debug ignore_loglevel memblock=debug
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffbfff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000dfffc000-0x00000000dfffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000e80effffff] usable
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0xe80f000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] PAT not supported by CPU.
> [    0.000000] e820: last_pfn = 0xdfffc max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at [ffff8800000fdb00]
> [    0.000000] memblock_reserve: [0x000000000fdb00-0x000000000fdb10] smp_scan_config+0x101/0x135
> [    0.000000] memblock_reserve: [0x000000000fdb10-0x000000000fdbf0] smp_scan_config+0x11a/0x135
> [    0.000000] memblock_reserve: [0x00000002085000-0x0000000208b000] setup_arch+0x5ed/0xc79
> [    0.000000] MEMBLOCK configuration:
> [    0.000000]  memory size = 0xe7eef9a400 reserved size = 0x10ec000
> [    0.000000]  memory.cnt  = 0x3
> [    0.000000]  memory[0x0]	[0x00000000001000-0x0000000009efff], 0x9e000 bytes
> [    0.000000]  memory[0x1]	[0x00000000100000-0x000000dfffbfff], 0xdfefc000 bytes
> [    0.000000]  memory[0x2]	[0x00000100000000-0x0000e80effffff], 0xe70f000000 bytes
> [    0.000000]  reserved.cnt  = 0x2
> [    0.000000]  reserved[0x0]	[0x0000000009f000-0x000000000fffff], 0x61000 bytes
> [    0.000000]  reserved[0x1]	[0x00000001000000-0x0000000208afff], 0x108b000 bytes
> [    0.000000] memblock_reserve: [0x00000000099000-0x0000000009f000] reserve_real_mode+0x61/0x87
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] memblock_reserve: [0x00000000000000-0x00000000010000] setup_arch+0x6cf/0xc79
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x02086000, 0x02086fff] PGTABLE
> [    0.000000] BRK [0x02087000, 0x02087fff] PGTABLE
> [    0.000000] BRK [0x02088000, 0x02088fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0xe80ee00000-0xe80effffff]
> [    0.000000]  [mem 0xe80ee00000-0xe80effffff] page 4k
> [    0.000000] BRK [0x02089000, 0x02089fff] PGTABLE
> [    0.000000] BRK [0x0208a000, 0x0208afff] PGTABLE
> [    0.000000] Kernel panic - not syncing: alloc_low_page: ran out of memory
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.11.0-rc4-00153-g14e9419-dirty #33
> [    0.000000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [    0.000000]  0000000000000001 ffffffff81c01ad8 ffffffff8165b550 000000000000019b
> [    0.000000]  ffffffff819ee0b8 ffffffff81c01b58 ffffffff81658600 0000000000000000
> [    0.000000]  0000000000000008 ffffffff81c01b68 ffffffff81c01b08 0000000000000006
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff8165b550>] dump_stack+0x55/0x76
> [    0.000000]  [<ffffffff81658600>] panic+0xbb/0x1cb
> [    0.000000]  [<ffffffff8164ee0a>] alloc_low_pages+0x15a/0x160
> [    0.000000]  [<ffffffff816533bb>] phys_pmd_init+0x1e2/0x28d
> [    0.000000]  [<ffffffff81658c46>] ? printk+0x4d/0x4f
> [    0.000000]  [<ffffffff81653638>] phys_pud_init+0x1d2/0x25c
> [    0.000000]  [<ffffffff81653fc7>] kernel_physical_mapping_init+0x14c/0x1ea
> [    0.000000]  [<ffffffff8164eff3>] init_memory_mapping+0x1e3/0x350
> [    0.000000]  [<ffffffff81d09d89>] init_range_memory_mapping+0xc2/0x10b
> [    0.000000]  [<ffffffff81d09f05>] init_mem_mapping+0x133/0x1e2
> [    0.000000]  [<ffffffff81cfaf11>] setup_arch+0x6d4/0xc79
> [    0.000000]  [<ffffffff81658c46>] ? printk+0x4d/0x4f
> [    0.000000]  [<ffffffff81cf4b59>] start_kernel+0xc9/0x3f3
> [    0.000000]  [<ffffffff81cf45a6>] x86_64_start_reservations+0x2a/0x2c
> [    0.000000]  [<ffffffff81cf4694>] x86_64_start_kernel+0xec/0xf3

