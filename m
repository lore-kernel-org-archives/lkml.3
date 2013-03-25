Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab3CYPkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 11:40:46 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:50950 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758422Ab3CYPko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:40:44 -0400
Message-ID: <51506FFA.4080105@mimc.co.uk>
Date: Mon, 25 Mar 2013 15:40:42 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: jean-philippe francois <jp.francois@cynove.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: 3.9.0-rc3: BUG: Bad page state in process
References: <51505173.1050009@mimc.co.uk> <51505851.8020609@mimc.co.uk> <5150596D.7080901@mimc.co.uk> <CAGGh5h0m2WVHkB9Je1cS0Sjmf4CGphQV5DXjkaom54Q0F4huSA@mail.gmail.com>
In-Reply-To: <CAGGh5h0m2WVHkB9Je1cS0Sjmf4CGphQV5DXjkaom54Q0F4huSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/03/13 15:06, jean-philippe francois wrote:
> 2013/3/25 Mark Jackson <mpfj-list@mimc.co.uk>:
>> On 25/03/13 13:59, Mark Jackson wrote:
>>> On 25/03/13 13:30, Mark Jackson wrote:
>>>> On our custom AM335x cpu board, I have had several kernel crashes via my userspace program.
>>>
> 
> Is the problem still present when booting with nohlt ?

Yes ... 

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.9.0-rc4-00026-g58216a6 (mpfj@mpfj-nanobone) (gcc version 4.5.4 (Buildroot 2012.11) ) #148 Mon Mar 25 09:19:57 GMT 2013
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Generic AM33XX (Flattened Device Tree), model: Newflow AM335x NanoBone
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] CPU: All CPU(s) started in SVC mode.
[    0.000000] AM335X ES1.0 (neon )
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64768
[    0.000000] Kernel command line: root=/dev/nfs nfsroot=10.0.0.100:/tftpboot/nanobone/rootfs rw ip=10.0.101.111::10.0.0.100:::eth0:off console=ttyO0,115200 no-hlt
...

# ./ccrt -f target/ccrt.ccc 4 1
Setting up signal handler
Loading XML
XML mem usage = 1101660 in 55080 elements
Assessing resources
Creating langauge string store
Creating variable store
[   13.323738] BUG: Bad page state in process ccrt  pfn:8fba4
[   13.329525] page:c0cb9480 count:0 mapcount:1 mapping:  (null) index:0x49
[   13.336623] page flags: 0x80008(uptodate|swapbacked)
[   13.341908] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[   13.350794] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0097f58>] (free_pages_prepare+0xfc/0x108)
[   13.360038] [<c0097f58>] (free_pages_prepare+0xfc/0x108) from [<c009881c>] (free_hot_cold_page+0x18/0x144)
[   13.370184] [<c009881c>] (free_hot_cold_page+0x18/0x144) from [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48)
[   13.380699] [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48) from [<c009d474>] (release_pages+0x1d0/0x20c)
[   13.390856] [<c009d474>] (release_pages+0x1d0/0x20c) from [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc)
[   13.401202] [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc) from [<c00b56e8>] (exit_mmap+0x110/0x1f4)
[   13.411167] [<c00b56e8>] (exit_mmap+0x110/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[   13.419317] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[   13.427918] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[   13.437700] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[   13.448029] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[   13.457722] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[   13.466332] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[   13.475303] BUG: Bad page state in process ccrt  pfn:8fbf2
[   13.481055] page:c0cb9e40 count:0 mapcount:1 mapping:  (null) index:0x97
[   13.488100] page flags: 0x80008(uptodate|swapbacked)
[   13.493356] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[   13.502207] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0097f58>] (free_pages_prepare+0xfc/0x108)
[   13.511443] [<c0097f58>] (free_pages_prepare+0xfc/0x108) from [<c009881c>] (free_hot_cold_page+0x18/0x144)
[   13.521610] [<c009881c>] (free_hot_cold_page+0x18/0x144) from [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48)
[   13.532119] [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48) from [<c009d474>] (release_pages+0x1d0/0x20c)
[   13.542265] [<c009d474>] (release_pages+0x1d0/0x20c) from [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc)
[   13.552595] [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc) from [<c00b56e8>] (exit_mmap+0x110/0x1f4)
[   13.562554] [<c00b56e8>] (exit_mmap+0x110/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[   13.570693] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[   13.579288] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[   13.589070] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[   13.599395] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[   13.609086] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[   13.617682] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[   13.736537] BUG: Bad page state in process ccrt  pfn:8fba4
[   13.742321] page:c0cb9480 count:1 mapcount:1 mapping:  (null) index:0x2
[   13.749332] page flags: 0x0()
[   13.752506] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[   13.761390] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0098fa0>] (get_page_from_freelist+0x47c/0x57c)
[   13.771086] [<c0098fa0>] (get_page_from_freelist+0x47c/0x57c) from [<c0099320>] (__alloc_pages_nodemask+0xd8/0x7bc)
[   13.782058] [<c0099320>] (__alloc_pages_nodemask+0xd8/0x7bc) from [<c00ae154>] (do_wp_page+0xbc/0x728)
[   13.791839] [<c00ae154>] (do_wp_page+0xbc/0x728) from [<c00b0624>] (handle_pte_fault+0x23c/0x6c4)
[   13.801167] [<c00b0624>] (handle_pte_fault+0x23c/0x6c4) from [<c00b0b3c>] (handle_mm_fault+0x90/0xc0)
[   13.810858] [<c00b0b3c>] (handle_mm_fault+0x90/0xc0) from [<c001da08>] (do_page_fault+0x220/0x38c)
[   13.820281] [<c001da08>] (do_page_fault+0x220/0x38c) from [<c0008498>] (do_DataAbort+0x30/0x9c)
[   13.829436] [<c0008498>] (do_DataAbort+0x30/0x9c) from [<c0013534>] (__dabt_usr+0x34/0x40)
[   13.838119] Exception stack(0xcf4b7fb0 to 0xcf4b7ff8)
[   13.843432] 7fa0:                                     00000000 be92d4c8 00000002 00000094
[   13.852008] 7fc0: 00000000 b6e88198 b6e83ee8 b6e78d52 000042b0 0001394e be92d900 0001f190
[   13.860597] 7fe0: b6e83f34 be92d490 b6e76c18 b6e76c1c 00000010 ffffffff
[   13.867567] BUG: Bad page state in process ccrt  pfn:8fbf2
[   13.873339] page:c0cb9e40 count:1 mapcount:1 mapping:  (null) index:0x2
[   13.880271] page flags: 0x0()
[   13.883416] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[   13.892266] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0098fa0>] (get_page_from_freelist+0x47c/0x57c)
[   13.901962] [<c0098fa0>] (get_page_from_freelist+0x47c/0x57c) from [<c0099320>] (__alloc_pages_nodemask+0xd8/0x7bc)
[   13.912929] [<c0099320>] (__alloc_pages_nodemask+0xd8/0x7bc) from [<c00ae154>] (do_wp_page+0xbc/0x728)
[   13.922705] [<c00ae154>] (do_wp_page+0xbc/0x728) from [<c00b0624>] (handle_pte_fault+0x23c/0x6c4)
[   13.932034] [<c00b0624>] (handle_pte_fault+0x23c/0x6c4) from [<c00b0b3c>] (handle_mm_fault+0x90/0xc0)
[   13.941727] [<c00b0b3c>] (handle_mm_fault+0x90/0xc0) from [<c001da08>] (do_page_fault+0x220/0x38c)
[   13.951139] [<c001da08>] (do_page_fault+0x220/0x38c) from [<c0008498>] (do_DataAbort+0x30/0x9c)
[   13.960282] [<c0008498>] (do_DataAbort+0x30/0x9c) from [<c0013534>] (__dabt_usr+0x34/0x40)
[   13.968961] Exception stack(0xcf4b7fb0 to 0xcf4b7ff8)
[   13.974273] 7fa0:                                     00000000 be92d4c8 00000002 00000094
[   13.982853] 7fc0: 00000000 b6e88198 b6e83ee8 b6e78d52 000042b0 0001394e be92d900 0001f190
[   13.991440] 7fe0: b6e83f34 be92d490 b6e76c18 b6e76c1c 00000010 ffffffff
[   14.001719] BUG: Bad page map in process ccrt  pte:8fba43cd pmd:8f4f7831
[   14.008831] page:c0cb9480 count:1 mapcount:-1 mapping:  (null) index:0x2
[   14.015876] page flags: 0x10(dirty)
[   14.019550] addr:00049000 vm_flags:00100073 anon_vma:cf5a5de0 mapping:  (null) index:49
[   14.028000] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c00ad988>] (print_bad_pte+0x128/0x1a4)
[   14.037423] [<c00ad988>] (print_bad_pte+0x128/0x1a4) from [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8)
[   14.047114] [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[   14.056374] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[   14.064884] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[   14.072920] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[   14.081521] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[   14.091301] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[   14.101631] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[   14.111317] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[   14.119925] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[   14.128910] BUG: Bad page map in process ccrt  pte:8fbf23cd pmd:8f4f7831
[   14.135958] page:c0cb9e40 count:1 mapcount:-1 mapping:  (null) index:0x2
[   14.142978] page flags: 0x10(dirty)
[   14.146665] addr:00097000 vm_flags:00100073 anon_vma:cf5a5de0 mapping:  (null) index:97
[   14.155079] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c00ad988>] (print_bad_pte+0x128/0x1a4)
[   14.164498] [<c00ad988>] (print_bad_pte+0x128/0x1a4) from [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8)
[   14.174189] [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[   14.183424] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[   14.191914] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[   14.199963] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[   14.208559] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[   14.218334] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[   14.228661] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[   14.238347] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[   14.246943] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[   14.287108] BUG: Bad page state in process ccrt  pfn:8fba4
[   14.292889] page:c0cb9480 count:0 mapcount:-1 mapping:  (null) index:0x2
[   14.299969] page flags: 0x10(dirty)
[   14.303713] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[   14.312580] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0097f58>] (free_pages_prepare+0xfc/0x108)
[   14.321827] [<c0097f58>] (free_pages_prepare+0xfc/0x108) from [<c009881c>] (free_hot_cold_page+0x18/0x144)
[   14.331980] [<c009881c>] (free_hot_cold_page+0x18/0x144) from [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48)
[   14.342489] [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48) from [<c009d474>] (release_pages+0x1d0/0x20c)
[   14.352642] [<c009d474>] (release_pages+0x1d0/0x20c) from [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc)
[   14.362978] [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc) from [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8)
[   14.373585] [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[   14.382803] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[   14.391313] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[   14.399369] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[   14.407965] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[   14.417746] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[   14.428074] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[   14.437762] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[   14.446373] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[   14.455340] BUG: Bad page state in process ccrt  pfn:8fbf2
[   14.461091] page:c0cb9e40 count:0 mapcount:-1 mapping:  (null) index:0x2
[   14.468128] page flags: 0x10(dirty)
[   14.471809] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c0097dfc>] (bad_page+0xa8/0x108)
[   14.480680] [<c0097dfc>] (bad_page+0xa8/0x108) from [<c0097f58>] (free_pages_prepare+0xfc/0x108)
[   14.489919] [<c0097f58>] (free_pages_prepare+0xfc/0x108) from [<c009881c>] (free_hot_cold_page+0x18/0x144)
[   14.500063] [<c009881c>] (free_hot_cold_page+0x18/0x144) from [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48)
[   14.510574] [<c0098b08>] (free_hot_cold_page_list+0x2c/0x48) from [<c009d474>] (release_pages+0x1d0/0x20c)
[   14.520718] [<c009d474>] (release_pages+0x1d0/0x20c) from [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc)
[   14.531043] [<c00be510>] (free_pages_and_swap_cache+0xac/0xbc) from [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8)
[   14.541636] [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[   14.550866] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[   14.559373] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[   14.567421] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[   14.576014] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[   14.585789] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[   14.596121] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[   14.605815] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[   14.614412] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
Loading main container
[   14.684815] BUG: Bad page map in process ccrt  pte:8fba43cf pmd:8f30f831
[   14.691875] page:c0cb9480 count:0 mapcount:-1 mapping:  (null) index:0x2
[   14.698980] page flags: 0x14(referenced|dirty)
[   14.703710] addr:00049000 vm_flags:00100073 anon_vma:cf368210 mapping:  (null) index:49
[   14.712145] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c00ad988>] (print_bad_pte+0x128/0x1a4)
[   14.721573] [<c00ad988>] (print_bad_pte+0x128/0x1a4) from [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8)
[   14.731263] [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[   14.740502] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[   14.749014] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[   14.757074] [<c00364b8>] (mmput+0x34/0xb8) from [<c003d760>] (do_exit+0x228/0x894)
[   14.765039] [<c003d760>] (do_exit+0x228/0x894) from [<c003de34>] (do_group_exit+0x3c/0xb0)
[   14.773743] [<c003de34>] (do_group_exit+0x3c/0xb0) from [<c0048b48>] (get_signal_to_deliver+0x350/0x5d8)
[   14.783706] [<c0048b48>] (get_signal_to_deliver+0x350/0x5d8) from [<c0016554>] (do_signal+0x7c/0x3a8)
[   14.793396] [<c0016554>] (do_signal+0x7c/0x3a8) from [<c0016c4c>] (do_work_pending+0xb0/0xcc)
[   14.802352] [<c0016c4c>] (do_work_pending+0xb0/0xcc) from [<c001380c>] (work_pending+0xc/0x20)
[   14.811437] BUG: Bad page map in process ccrt  pte:8fbf23cf pmd:8f30f831
[   14.818482] page:c0cb9e40 count:0 mapcount:-1 mapping:  (null) index:0x2
[   14.825525] page flags: 0x14(referenced|dirty)
[   14.830202] addr:00097000 vm_flags:00100073 anon_vma:cf368210 mapping:  (null) index:97
[   14.838618] [<c00190c0>] (unwind_backtrace+0x0/0xf8) from [<c00ad988>] (print_bad_pte+0x128/0x1a4)
[   14.848034] [<c00ad988>] (print_bad_pte+0x128/0x1a4) from [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8)
[   14.857724] [<c00aed74>] (unmap_single_vma+0x5b4/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[   14.866956] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[   14.875466] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[   14.883520] [<c00364b8>] (mmput+0x34/0xb8) from [<c003d760>] (do_exit+0x228/0x894)
[   14.891461] [<c003d760>] (do_exit+0x228/0x894) from [<c003de34>] (do_group_exit+0x3c/0xb0)
[   14.900152] [<c003de34>] (do_group_exit+0x3c/0xb0) from [<c0048b48>] (get_signal_to_deliver+0x350/0x5d8)
[   14.910121] [<c0048b48>] (get_signal_to_deliver+0x350/0x5d8) from [<c0016554>] (do_signal+0x7c/0x3a8)
[   14.919812] [<c0016554>] (do_signal+0x7c/0x3a8) from [<c0016c4c>] (do_work_pending+0xb0/0xcc)
[   14.928773] [<c0016c4c>] (do_work_pending+0xb0/0xcc) from [<c001380c>] (work_pending+0xc/0x20)
[   14.964710] BUG: Bad rss-counter state mm:cf2fd640 idx:0 val:-2
[   14.970939] BUG: Bad rss-counter state mm:cf2fd640 idx:1 val:2
Segmentation fault

