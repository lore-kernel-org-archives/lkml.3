Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab3CYOEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:04:33 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:50502 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758065Ab3CYOEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:04:31 -0400
Message-ID: <5150596D.7080901@mimc.co.uk>
Date: Mon, 25 Mar 2013 14:04:29 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 3.9.0-rc3: BUG: Bad page state in process
References: <51505173.1050009@mimc.co.uk> <51505851.8020609@mimc.co.uk>
In-Reply-To: <51505851.8020609@mimc.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/03/13 13:59, Mark Jackson wrote:
> On 25/03/13 13:30, Mark Jackson wrote:
>> On our custom AM335x cpu board, I have had several kernel crashes via my userspace program.
> 
> <snip>
> 
> And here's another similar oops ...

<snip>

Another big blowout ...

[16910.346870] BUG: Bad page state in process ccrt  pfn:8f94e
[16910.352656] page:c0cb49c0 count:0 mapcount:1 mapping:  (null) index:0xb6a21
[16910.360028] page flags: 0x80008(uptodate|swapbacked)
[16910.365332] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[16910.374211] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0097f58>] (free_pages_prepare+0xfc/0x108)
[16910.383451] [<c0097f58>] (free_pages_prepare+0xfc/0x108) from [<c009881c>] (free_hot_cold_page+0x18/0x144)
[16910.393602] [<c009881c>] (free_hot_cold_page+0x18/0x144) from [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48)
[16910.404112] [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48) from [<c009d474>] (release_pages+0x1d0/0x20c)
[16910.414264] [<c009d474>] (release_pages+0x1d0/0x20c) from [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc)
[16910.424608] [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc) from [<c00b56e8>] (exit_mmap+0x110/0x1f4)
[16910.434579] [<c00b56e8>] (exit_mmap+0x110/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16910.442713] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[16910.451321] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[16910.461103] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[16910.471429] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[16910.481121] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[16910.489737] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[16910.498694] BUG: Bad page state in process ccrt  pfn:8f94c
[16910.504484] page:c0cb4980 count:0 mapcount:1 mapping:  (null) index:0xb6a1f
[16910.511779] page flags: 0x80008(uptodate|swapbacked)
[16910.517033] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[16910.525906] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0097f58>] (free_pages_prepare+0xfc/0x108)
[16910.535144] [<c0097f58>] (free_pages_prepare+0xfc/0x108) from [<c009881c>] (free_hot_cold_page+0x18/0x144)
[16910.545290] [<c009881c>] (free_hot_cold_page+0x18/0x144) from [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48)
[16910.555799] [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48) from [<c009d474>] (release_pages+0x1d0/0x20c)
[16910.565945] [<c009d474>] (release_pages+0x1d0/0x20c) from [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc)
[16910.576271] [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc) from [<c00b56e8>] (exit_mmap+0x110/0x1f4)
[16910.586235] [<c00b56e8>] (exit_mmap+0x110/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16910.594375] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[16910.602952] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[16910.612734] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[16910.623062] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[16910.632752] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[16910.641348] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[16910.759432] BUG: Bad page state in process ccrt  pfn:8f94e
[16910.765348] page:c0cb49c0 count:1 mapcount:1 mapping:  (null) index:0x2
[16910.772283] page flags: 0x0()
[16910.775475] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[16910.784360] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0098fa0>] (get_page_from_freelist+0x47c/0x57c)
[16910.794056] [<c0098fa0>] (get_page_from_freelist+0x47c/0x57c) from [<c0099320>] (__alloc_pages_nodemask+0xd8/0x7bc)
[16910.805030] [<c0099320>] (__alloc_pages_nodemask+0xd8/0x7bc) from [<c00ae154>] (do_wp_page+0xbc/0x728)
[16910.814813] [<c00ae154>] (do_wp_page+0xbc/0x728) from [<c00b0624>] (handle_pte_fault+0x23c/0x6c4)
[16910.824141] [<c00b0624>] (handle_pte_fault+0x23c/0x6c4) from [<c00b0b3c>] (handle_mm_fault+0x90/0xc0)
[16910.833831] [<c00b0b3c>] (handle_mm_fault+0x90/0xc0) from [<c001da08>] (do_page_fault+0x220/0x38c)
[16910.843251] [<c001da08>] (do_page_fault+0x220/0x38c) from [<c0008498>] (do_DataAbort+0x30/0x9c)
[16910.852390] [<c0008498>] (do_DataAbort+0x30/0x9c) from [<c0013534>] (__dabt_usr+0x34/0x40)
[16910.861068] Exception stack(0xcd057fb0 to 0xcd057ff8)
[16910.866382] 7fa0:                                     00000000 bedfe4c8 00000002 00000094
[16910.874974] 7fc0: 00000000 b6eb1198 b6eacee8 b6ea1d52 000042b0 0001394e bedfe900 0001f190
[16910.883568] 7fe0: b6eacf34 bedfe490 b6e9fc18 b6e9fc1c 00000010 ffffffff
[16910.890504] BUG: Bad page state in process ccrt  pfn:8f94c
[16910.896271] page:c0cb4980 count:1 mapcount:1 mapping:  (null) index:0x2
[16910.903217] page flags: 0x0()
[16910.906345] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[16910.915217] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0098fa0>] (get_page_from_freelist+0x47c/0x57c)
[16910.924913] [<c0098fa0>] (get_page_from_freelist+0x47c/0x57c) from [<c0099320>] (__alloc_pages_nodemask+0xd8/0x7bc)
[16910.935877] [<c0099320>] (__alloc_pages_nodemask+0xd8/0x7bc) from [<c00ae154>] (do_wp_page+0xbc/0x728)
[16910.945663] [<c00ae154>] (do_wp_page+0xbc/0x728) from [<c00b0624>] (handle_pte_fault+0x23c/0x6c4)
[16910.954991] [<c00b0624>] (handle_pte_fault+0x23c/0x6c4) from [<c00b0b3c>] (handle_mm_fault+0x90/0xc0)
[16910.964683] [<c00b0b3c>] (handle_mm_fault+0x90/0xc0) from [<c001da08>] (do_page_fault+0x220/0x38c)
[16910.974102] [<c001da08>] (do_page_fault+0x220/0x38c) from [<c0008498>] (do_DataAbort+0x30/0x9c)
[16910.983243] [<c0008498>] (do_DataAbort+0x30/0x9c) from [<c0013534>] (__dabt_usr+0x34/0x40)
[16910.991907] Exception stack(0xcd057fb0 to 0xcd057ff8)
[16910.997220] 7fa0:                                     00000000 bedfe4c8 00000002 00000094
[16911.005828] 7fc0: 00000000 b6eb1198 b6eacee8 b6ea1d52 000042b0 0001394e bedfe900 0001f190
[16911.014419] 7fe0: b6eacf34 bedfe490 b6e9fc18 b6e9fc1c 00000010 ffffffff
[16911.051465] BUG: Bad page map in process ccrt  pte:8f94c3cd pmd:8f31b831
[16911.058584] page:c0cb4980 count:1 mapcount:-1 mapping:  (null) index:0x2
[16911.065644] page flags: 0x10(dirty)
[16911.069320] addr:b6a1f000 vm_flags:00100073 anon_vma:cf642768 mapping:  (null) index:b6a1f
[16911.078050] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c00ad988>] (print_bad_pte+0x128/0x1a4)
[16911.087481] [<c00ad988>] (print_bad_pte+0x128/0x1a4) from [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8)
[16911.097177] [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16911.106416] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16911.114932] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16911.122971] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[16911.131573] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[16911.141356] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[16911.151689] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[16911.161374] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[16911.169991] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[16911.178966] BUG: Bad page map in process ccrt  pte:8f94e3cd pmd:8f31b831
[16911.186011] page:c0cb49c0 count:1 mapcount:-1 mapping:  (null) index:0x2
[16911.193033] page flags: 0x10(dirty)
[16911.196721] addr:b6a21000 vm_flags:00100073 anon_vma:cf642768 mapping:  (null) index:b6a21
[16911.205413] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c00ad988>] (print_bad_pte+0x128/0x1a4)
[16911.214832] [<c00ad988>] (print_bad_pte+0x128/0x1a4) from [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8)
[16911.224522] [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16911.233757] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16911.242243] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16911.250294] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[16911.258891] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[16911.268673] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[16911.279004] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[16911.288693] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[16911.297292] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[16911.307756] BUG: Bad page state in process ccrt  pfn:8f94e
[16911.313578] page:c0cb49c0 count:0 mapcount:-1 mapping:  (null) index:0x2
[16911.320600] page flags: 0x10(dirty)
[16911.324326] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[16911.333209] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0097f58>] (free_pages_prepare+0xfc/0x108)
[16911.342428] [<c0097f58>] (free_pages_prepare+0xfc/0x108) from [<c009881c>] (free_hot_cold_page+0x18/0x144)
[16911.352580] [<c009881c>] (free_hot_cold_page+0x18/0x144) from [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48)
[16911.363097] [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48) from [<c009d474>] (release_pages+0x1d0/0x20c)
[16911.373252] [<c009d474>] (release_pages+0x1d0/0x20c) from [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc)
[16911.383582] [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc) from [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8)
[16911.394183] [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16911.403421] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16911.411913] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16911.419964] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[16911.428566] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[16911.438348] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[16911.448676] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[16911.458365] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[16911.466967] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[16911.475929] BUG: Bad page state in process ccrt  pfn:8f94c
[16911.481680] page:c0cb4980 count:0 mapcount:-1 mapping:  (null) index:0x2
[16911.488721] page flags: 0x10(dirty)
[16911.492403] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[16911.501279] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0097f58>] (free_pages_prepare+0xfc/0x108)
[16911.510516] [<c0097f58>] (free_pages_prepare+0xfc/0x108) from [<c009881c>] (free_hot_cold_page+0x18/0x144)
[16911.520663] [<c009881c>] (free_hot_cold_page+0x18/0x144) from [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48)
[16911.531170] [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48) from [<c009d474>] (release_pages+0x1d0/0x20c)
[16911.541311] [<c009d474>] (release_pages+0x1d0/0x20c) from [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc)
[16911.551641] [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc) from [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8)
[16911.562246] [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16911.571482] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16911.579988] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16911.588040] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[16911.596644] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[16911.606423] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[16911.616752] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[16911.626444] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[16911.635044] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[16911.719931] BUG: Bad page state in process ccrt  pfn:8e44b
[16911.725822] page:c0c8a960 count:0 mapcount:1 mapping:  (null) index:0x8b
[16911.732847] page flags: 0x80008(uptodate|swapbacked)
[16911.738157] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[16911.747042] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0097f58>] (free_pages_prepare+0xfc/0x108)
[16911.756285] [<c0097f58>] (free_pages_prepare+0xfc/0x108) from [<c009881c>] (free_hot_cold_page+0x18/0x144)
[16911.766432] [<c009881c>] (free_hot_cold_page+0x18/0x144) from [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48)
[16911.776949] [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48) from [<c009d474>] (release_pages+0x1d0/0x20c)
[16911.787102] [<c009d474>] (release_pages+0x1d0/0x20c) from [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc)
[16911.797445] [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc) from [<c00b56e8>] (exit_mmap+0x110/0x1f4)
[16911.807416] [<c00b56e8>] (exit_mmap+0x110/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16911.815833] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[16911.824591] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[16911.834398] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[16911.844738] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[16911.854432] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[16911.863026] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[16911.913537] BUG: Bad page state in process ccrt  pfn:8f94e
[16911.919321] page:c0cb49c0 count:1 mapcount:1 mapping:  (null) index:0x2
[16911.926311] page flags: 0x0()
[16911.929483] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[16911.938364] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0098fa0>] (get_page_from_freelist+0x47c/0x57c)
[16911.948063] [<c0098fa0>] (get_page_from_freelist+0x47c/0x57c) from [<c0099320>] (__alloc_pages_nodemask+0xd8/0x7bc)
[16911.959051] [<c0099320>] (__alloc_pages_nodemask+0xd8/0x7bc) from [<c00ae154>] (do_wp_page+0xbc/0x728)
[16911.968839] [<c00ae154>] (do_wp_page+0xbc/0x728) from [<c00b0624>] (handle_pte_fault+0x23c/0x6c4)
[16911.978161] [<c00b0624>] (handle_pte_fault+0x23c/0x6c4) from [<c00b0b3c>] (handle_mm_fault+0x90/0xc0)
[16911.987853] [<c00b0b3c>] (handle_mm_fault+0x90/0xc0) from [<c001da08>] (do_page_fault+0x220/0x38c)
[16911.997272] [<c001da08>] (do_page_fault+0x220/0x38c) from [<c0008498>] (do_DataAbort+0x30/0x9c)
[16912.006425] [<c0008498>] (do_DataAbort+0x30/0x9c) from [<c0013534>] (__dabt_usr+0x34/0x40)
[16912.015106] Exception stack(0xcd05dfb0 to 0xcd05dff8)
[16912.020406] dfa0:                                     00000000 bedfe4c8 00000002 00000094
[16912.029002] dfc0: 00000000 b6eb1198 b6eacee8 b6ea1d52 000042b0 0001394e bedfe900 0001f190
[16912.037593] dfe0: b6eacf34 bedfe490 b6e9fc18 b6e9fc1c 00000010 ffffffff
[16912.044544] BUG: Bad page state in process ccrt  pfn:8f94c
[16912.050294] page:c0cb4980 count:1 mapcount:1 mapping:  (null) index:0x2
[16912.057240] page flags: 0x0()
[16912.060369] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[16912.069247] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0098fa0>] (get_page_from_freelist+0x47c/0x57c)
[16912.078938] [<c0098fa0>] (get_page_from_freelist+0x47c/0x57c) from [<c0099320>] (__alloc_pages_nodemask+0xd8/0x7bc)
[16912.089909] [<c0099320>] (__alloc_pages_nodemask+0xd8/0x7bc) from [<c00ae154>] (do_wp_page+0xbc/0x728)
[16912.099692] [<c00ae154>] (do_wp_page+0xbc/0x728) from [<c00b0624>] (handle_pte_fault+0x23c/0x6c4)
[16912.109021] [<c00b0624>] (handle_pte_fault+0x23c/0x6c4) from [<c00b0b3c>] (handle_mm_fault+0x90/0xc0)
[16912.118706] [<c00b0b3c>] (handle_mm_fault+0x90/0xc0) from [<c001da08>] (do_page_fault+0x220/0x38c)
[16912.128122] [<c001da08>] (do_page_fault+0x220/0x38c) from [<c0008498>] (do_DataAbort+0x30/0x9c)
[16912.137264] [<c0008498>] (do_DataAbort+0x30/0x9c) from [<c0013534>] (__dabt_usr+0x34/0x40)
[16912.145946] Exception stack(0xcd05dfb0 to 0xcd05dff8)
[16912.151242] dfa0:                                     00000000 bedfe4c8 00000002 00000094
[16912.159835] dfc0: 00000000 b6eb1198 b6eacee8 b6ea1d52 000042b0 0001394e bedfe900 0001f190
[16912.168427] dfe0: b6eacf34 bedfe490 b6e9fc18 b6e9fc1c 00000010 ffffffff
[16912.205628] BUG: Bad page map in process ccrt  pte:8f94c3cd pmd:8f573831
[16912.212685] page:c0cb4980 count:1 mapcount:-1 mapping:  (null) index:0x2
[16912.219759] page flags: 0x10(dirty)
[16912.223454] addr:b6a1f000 vm_flags:00100073 anon_vma:cf642720 mapping:  (null) index:b6a1f
[16912.232160] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c00ad988>] (print_bad_pte+0x128/0x1a4)
[16912.241588] [<c00ad988>] (print_bad_pte+0x128/0x1a4) from [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8)
[16912.251281] [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16912.260522] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16912.269034] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16912.277105] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[16912.285707] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[16912.295493] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[16912.305839] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[16912.315531] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[16912.324144] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[16912.333089] BUG: Bad page map in process ccrt  pte:8f94e3cd pmd:8f573831
[16912.340132] page:c0cb49c0 count:1 mapcount:-1 mapping:  (null) index:0x2
[16912.347171] page flags: 0x10(dirty)
[16912.350841] addr:b6a21000 vm_flags:00100073 anon_vma:cf642720 mapping:  (null) index:b6a21
[16912.359531] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c00ad988>] (print_bad_pte+0x128/0x1a4)
[16912.368947] [<c00ad988>] (print_bad_pte+0x128/0x1a4) from [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8)
[16912.378636] [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16912.387872] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16912.396380] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16912.404434] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[16912.413017] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[16912.422799] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[16912.433129] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[16912.442821] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[16912.451418] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[16912.461391] BUG: Bad page state in process ccrt  pfn:8f94e
[16912.467208] page:c0cb49c0 count:0 mapcount:-1 mapping:  (null) index:0x2
[16912.474249] page flags: 0x10(dirty)
[16912.477953] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[16912.486833] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0097f58>] (free_pages_prepare+0xfc/0x108)
[16912.496080] [<c0097f58>] (free_pages_prepare+0xfc/0x108) from [<c009881c>] (free_hot_cold_page+0x18/0x144)
[16912.506232] [<c009881c>] (free_hot_cold_page+0x18/0x144) from [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48)
[16912.516744] [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48) from [<c009d474>] (release_pages+0x1d0/0x20c)
[16912.526898] [<c009d474>] (release_pages+0x1d0/0x20c) from [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc)
[16912.537235] [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc) from [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8)
[16912.547838] [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16912.557075] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16912.565585] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16912.573638] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[16912.582220] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[16912.592004] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[16912.602339] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[16912.612030] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[16912.620635] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[16912.629593] BUG: Bad page state in process ccrt  pfn:8f94c
[16912.635362] page:c0cb4980 count:0 mapcount:-1 mapping:  (null) index:0x2
[16912.642383] page flags: 0x10(dirty)
[16912.646082] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[16912.654955] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0097f58>] (free_pages_prepare+0xfc/0x108)
[16912.664205] [<c0097f58>] (free_pages_prepare+0xfc/0x108) from [<c009881c>] (free_hot_cold_page+0x18/0x144)
[16912.674353] [<c009881c>] (free_hot_cold_page+0x18/0x144) from [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48)
[16912.684865] [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48) from [<c009d474>] (release_pages+0x1d0/0x20c)
[16912.695013] [<c009d474>] (release_pages+0x1d0/0x20c) from [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc)
[16912.705345] [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc) from [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8)
[16912.715944] [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16912.725180] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16912.733688] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16912.741717] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[16912.750315] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[16912.760095] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[16912.770429] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[16912.780117] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[16912.788716] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
Loading main container
[16912.845770] BUG: Bad page map in process ccrt  pte:8e44b3cf pmd:8f39a831
[16912.852831] page:c0c8a960 count:1 mapcount:-1 mapping:cf35526c index:0xe
[16912.859938] page flags: 0x80078(uptodate|dirty|lru|active|swapbacked)
[16912.866762] addr:0008b000 vm_flags:00100073 anon_vma:cf642b10 mapping:  (null) index:8b
[16912.875216] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c00ad988>] (print_bad_pte+0x128/0x1a4)
[16912.884646] [<c00ad988>] (print_bad_pte+0x128/0x1a4) from [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8)
[16912.894338] [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16912.903577] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16912.912071] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16912.920134] [<c00364b8>] (mmput+0x34/0xb8) from [<c003d760>] (do_exit+0x228/0x894)
[16912.928095] [<c003d760>] (do_exit+0x228/0x894) from [<c003de34>] (do_group_exit+0x3c/0xb0)
[16912.936796] [<c003de34>] (do_group_exit+0x3c/0xb0) from [<c0048b48>] (get_signal_to_deliver+0x350/0x5d8)
[16912.946761] [<c0048b48>] (get_signal_to_deliver+0x350/0x5d8) from [<c0016554>] (do_signal+0x7c/0x3a8)
[16912.956452] [<c0016554>] (do_signal+0x7c/0x3a8) from [<c0016c4c>] (do_work_pending+0xb0/0xcc)
[16912.965422] [<c0016c4c>] (do_work_pending+0xb0/0xcc) from [<c001380c>] (work_pending+0xc/0x20)
[16912.997615] BUG: Bad page map in process ccrt  pte:8f94c3cf pmd:8d152831
[16913.004791] page:c0cb4980 count:0 mapcount:-1 mapping:  (null) index:0x2
[16913.011813] page flags: 0x14(referenced|dirty)
[16913.016518] addr:b6a1f000 vm_flags:00100073 anon_vma:cf642138 mapping:  (null) index:b6a1f
[16913.025235] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c00ad988>] (print_bad_pte+0x128/0x1a4)
[16913.034655] [<c00ad988>] (print_bad_pte+0x128/0x1a4) from [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8)
[16913.044349] [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16913.053582] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16913.062069] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16913.070130] [<c00364b8>] (mmput+0x34/0xb8) from [<c003d760>] (do_exit+0x228/0x894)
[16913.078093] [<c003d760>] (do_exit+0x228/0x894) from [<c003de34>] (do_group_exit+0x3c/0xb0)
[16913.086787] [<c003de34>] (do_group_exit+0x3c/0xb0) from [<c0048b48>] (get_signal_to_deliver+0x350/0x5d8)
[16913.096753] [<c0048b48>] (get_signal_to_deliver+0x350/0x5d8) from [<c0016554>] (do_signal+0x7c/0x3a8)
[16913.106444] [<c0016554>] (do_signal+0x7c/0x3a8) from [<c0016c4c>] (do_work_pending+0xb0/0xcc)
[16913.115417] [<c0016c4c>] (do_work_pending+0xb0/0xcc) from [<c001380c>] (work_pending+0xc/0x20)
[16913.124464] BUG: Bad page map in process ccrt  pte:8f94e3cf pmd:8d152831
[16913.131488] page:c0cb49c0 count:0 mapcount:-1 mapping:  (null) index:0x2
[16913.138526] page flags: 0x14(referenced|dirty)
[16913.143220] addr:b6a21000 vm_flags:00100073 anon_vma:cf642138 mapping:  (null) index:b6a21
[16913.151893] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c00ad988>] (print_bad_pte+0x128/0x1a4)
[16913.161317] [<c00ad988>] (print_bad_pte+0x128/0x1a4) from [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8)
[16913.171009] [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16913.180251] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16913.188757] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16913.196809] [<c00364b8>] (mmput+0x34/0xb8) from [<c003d760>] (do_exit+0x228/0x894)
[16913.204768] [<c003d760>] (do_exit+0x228/0x894) from [<c003de34>] (do_group_exit+0x3c/0xb0)
[16913.213456] [<c003de34>] (do_group_exit+0x3c/0xb0) from [<c0048b48>] (get_signal_to_deliver+0x350/0x5d8)
[16913.223420] [<c0048b48>] (get_signal_to_deliver+0x350/0x5d8) from [<c0016554>] (do_signal+0x7c/0x3a8)
[16913.233085] [<c0016554>] (do_signal+0x7c/0x3a8) from [<c0016c4c>] (do_work_pending+0xb0/0xcc)
[16913.242047] [<c0016c4c>] (do_work_pending+0xb0/0xcc) from [<c001380c>] (work_pending+0xc/0x20)
[16913.251426] BUG: Bad page state in process ccrt  pfn:8e44b
[16913.257203] page:c0c8a960 count:0 mapcount:-1 mapping:cf35526c index:0xe
[16913.264242] page flags: 0x80018(uptodate|dirty|swapbacked)
[16913.270049] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[16913.278924] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0097f58>] (free_pages_prepare+0xfc/0x108)
[16913.288167] [<c0097f58>] (free_pages_prepare+0xfc/0x108) from [<c009881c>] (free_hot_cold_page+0x18/0x144)
[16913.298316] [<c009881c>] (free_hot_cold_page+0x18/0x144) from [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48)
[16913.308828] [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48) from [<c009d474>] (release_pages+0x1d0/0x20c)
[16913.318980] [<c009d474>] (release_pages+0x1d0/0x20c) from [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc)
[16913.329315] [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc) from [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8)
[16913.339916] [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16913.349155] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16913.357665] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16913.365716] [<c00364b8>] (mmput+0x34/0xb8) from [<c003d760>] (do_exit+0x228/0x894)
[16913.373676] [<c003d760>] (do_exit+0x228/0x894) from [<c003de34>] (do_group_exit+0x3c/0xb0)
[16913.382346] [<c003de34>] (do_group_exit+0x3c/0xb0) from [<c0048b48>] (get_signal_to_deliver+0x350/0x5d8)
[16913.392313] [<c0048b48>] (get_signal_to_deliver+0x350/0x5d8) from [<c0016554>] (do_signal+0x7c/0x3a8)
[16913.401997] [<c0016554>] (do_signal+0x7c/0x3a8) from [<c0016c4c>] (do_work_pending+0xb0/0xcc)
[16913.410959] [<c0016c4c>] (do_work_pending+0xb0/0xcc) from [<c001380c>] (work_pending+0xc/0x20)
[16913.423605] BUG: Bad rss-counter state mm:cf2fd040 idx:0 val:-3
[16913.429823] BUG: Bad rss-counter state mm:cf2fd040 idx:1 val:3



