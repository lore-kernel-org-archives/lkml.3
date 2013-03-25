Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab3CYN7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:59:48 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:50435 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757826Ab3CYN7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:59:46 -0400
Message-ID: <51505851.8020609@mimc.co.uk>
Date: Mon, 25 Mar 2013 13:59:45 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 3.9.0-rc3: BUG: Bad page state in process
References: <51505173.1050009@mimc.co.uk>
In-Reply-To: <51505173.1050009@mimc.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/03/13 13:30, Mark Jackson wrote:
> On our custom AM335x cpu board, I have had several kernel crashes via my userspace program.

<snip>

And here's another similar oops ...

[16565.691706] Unable to handle kernel NULL pointer dereference at virtual address 00000000
[16565.700289] pgd = cd07c000
[16565.703149] [00000000] *pgd=00000000
[16565.706909] Internal error: Oops: 5 [#1] ARM
[16565.711390] CPU: 0    Not tainted  (3.9.0-rc4-00026-g58216a6 #148)
[16565.717886] PC is at free_pages_and_swap_cache+0x48/0xbc
[16565.723457] LR is at release_pages+0x1d0/0x20c
[16565.728117] pc : [<c00be4ac>]    lr : [<c009d474>]    psr: 20000013
[16565.728117] sp : cf707d70  ip : 00000000  fp : cf56edac
[16565.740153] r10: cd079388  r9 : c0c8bac0  r8 : 00000000
[16565.745624] r7 : 00000001  r6 : cd079380  r5 : 00000320  r4 : 0000000e
[16565.752463] r3 : 00080068  r2 : 00000000  r1 : 00000000  r0 : cf707d2c
[16565.759308] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[16565.766784] Control: 10c5387d  Table: 8d07c019  DAC: 00000015
[16565.772802] Process ccrt (pid: 800, stack limit = 0xcf706238)
[16565.778820] Stack: (0xcf707d70 to 0xcf708000)
[16565.783389] 7d60:                                     0000000b b6bb6000 00000001 cf707e08
[16565.791961] 7d80: cf707e08 b6c00000 00000000 c00aeb70 cf644d38 cf640700 cf644d00 00000000
[16565.800531] 7da0: 8e4d63cd cf56eda8 b6d97000 b6d96fff c0c8ba60 00000000 fffffe49 00000000
[16565.809102] 7dc0: 09bdd609 cf640700 ffffffff cf707e08 00000000 00000000 cf52d868 cf644d00
[16565.817675] 7de0: cf39c680 c00af4b4 00000000 cf2fd640 cf640498 cf644d00 cf707e08 cf2ffc80
[16565.826251] 7e00: cf2fd640 c00b56a8 cf644d00 00000001 00000000 00000080 00000000 00000400
[16565.834826] 7e20: 00000400 cd079000 cf2ffc80 cf2fd640 cf52d868 cf644d00 cf39c680 c03ffc08
[16565.843397] 7e40: 60000013 cf644d5c cf644d00 cf644d00 00000000 cf706000 cf2ffc80 c00364b8
[16565.851968] 7e60: cf644d00 cf52d4c0 cf706000 c00ccb4c cf2f7340 cf2ffc80 cf2f73a4 cf707e90
[16565.860541] 7e80: cf2f7374 cf706000 00000001 c010a624 cf2ffc80 00000080 00000003 00000000
[16565.869118] 7ea0: cf706000 cf2ffd80 cf6003c0 c0579ddc cf706000 c0109b08 00000320 c0075190
[16565.877691] 7ec0: 00000002 00000000 00000000 c00cd214 00000000 00000000 cf52d4c0 c0579dc0
[16565.886262] 7ee0: 00000002 00000000 c0579dc0 cf2ffc80 fffffff8 00000000 c057a71c c0579ddc
[16565.894834] 7f00: cf706000 c010a3e8 00000320 c00cd200 00000001 00000000 c00cd150 befff000
[16565.903406] 7f20: cf706000 00000001 cf38e548 cf706000 00000001 00000001 cf38e548 cf2ffc80
[16565.911976] 7f40: bebc3dac bebc34a8 00000000 c00cd750 00000001 00000000 c00cd3bc 00000ff0
[16565.920549] 7f60: cf2fd698 cf2fd640 cf52d6e0 00000000 00000000 cd046000 bebc3dac bebc34a8
[16565.929124] 7f80: 0000000b c0013968 cf706000 00000000 0001f190 c00cda58 00000000 b6e0c198
[16565.937703] 7fa0: b6e07ee8 c00137c0 00000000 b6e0c198 b6dfcd52 bebc34a8 bebc3dac b6e0c190
[16565.946280] 7fc0: 00000000 b6e0c198 b6e07ee8 0000000b 000042b0 0001394e bebc3900 0001f190
[16565.954852] 7fe0: b6e07f34 bebc3488 b6dfac38 b6dc9e88 00000010 b6dfcd52 00000000 00000000
[16565.963451] [<c00be4ac>] (free_pages_and_swap_cache+0x48/0xbc) from [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8)
[16565.974035] [<c00aeb70>] (unmap_single_vma+0x3b0/0x5b8) from [<c00af4b4>] (unmap_vmas+0x54/0x68)
[16565.983253] [<c00af4b4>] (unmap_vmas+0x54/0x68) from [<c00b56a8>] (exit_mmap+0xd0/0x1f4)
[16565.991746] [<c00b56a8>] (exit_mmap+0xd0/0x1f4) from [<c00364b8>] (mmput+0x34/0xb8)
[16565.999783] [<c00364b8>] (mmput+0x34/0xb8) from [<c00ccb4c>] (flush_old_exec+0x240/0x4c8)
[16566.008365] [<c00ccb4c>] (flush_old_exec+0x240/0x4c8) from [<c010a624>] (load_elf_binary+0x23c/0x11b0)
[16566.018131] [<c010a624>] (load_elf_binary+0x23c/0x11b0) from [<c00cd200>] (search_binary_handler+0xe4/0x1f0)
[16566.028437] [<c00cd200>] (search_binary_handler+0xe4/0x1f0) from [<c00cd750>] (do_execve+0x444/0x4fc)
[16566.038107] [<c00cd750>] (do_execve+0x444/0x4fc) from [<c00cda58>] (sys_execve+0x30/0x44)
[16566.046697] [<c00cda58>] (sys_execve+0x30/0x44) from [<c00137c0>] (ret_fast_syscall+0x0/0x3c)
[16566.055635] Code: e2877001 e1540007 da000015 e49a8004 (e5983000)
[16566.062129] ---[ end trace d58a14e8bd6d8269 ]---


