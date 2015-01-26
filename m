Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbbAZMDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:03:48 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:33336 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbbAZMDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:03:44 -0500
Date: Mon, 26 Jan 2015 14:03:29 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Huang Ying <ying.huang@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [mm] WARNING: CPU: 0 PID: 117 at mm/mmap.c:2858
 exit_mmap+0x151/0x160()
Message-ID: <20150126120329.GC25833@node.dhcp.inet.fi>
References: <1422242257.24875.19.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422242257.24875.19.camel@intel.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 11:17:37AM +0800, Huang Ying wrote:
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit f7a7b53a90f7a489c4e435d1300db121f6b42776 ("mm: account pmd page tables to the process")
> 
> 
> +-----------------------------------+------------+------------+
> |                                   | fe888c1f62 | f7a7b53a90 |
> +-----------------------------------+------------+------------+
> | boot_successes                    | 102        | 6          |
> | boot_failures                     | 2          | 20         |
> | BUG:kernel_boot_hang              | 2          |            |
> | WARNING:at_mm/mmap.c:#exit_mmap() | 0          | 20         |
> | backtrace:do_execveat_common      | 0          | 20         |
> | backtrace:SyS_execve              | 0          | 20         |
> | backtrace:do_group_exit           | 0          | 20         |
> | backtrace:SyS_exit_group          | 0          | 20         |
> +-----------------------------------+------------+------------+
> 
> 
> [    5.178599] NX-protecting the kernel data: 5340k
> [    5.182110] random: init urandom read with 0 bits of entropy available
> [    5.183522] ------------[ cut here ]------------
> [    5.184275] WARNING: CPU: 0 PID: 117 at mm/mmap.c:2858 exit_mmap+0x151/0x160()
> [    5.185664] CPU: 0 PID: 117 Comm: init Not tainted 3.19.0-rc5-next-20150123-gde3d2c5 #144
> [    5.186988] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    5.187838]  00000000 00000000 d5d23d34 c16bf243 d5d23d68 c1055ae3 c186e81c 00000000
> [    5.189610]  00000075 c187dabf 00000b2a c111da01 00000b2a c111da01 00000000 d5d611c0
> [    5.191397]  0000005e d5d23d78 c1055be2 00000009 00000000 d5d23dd4 c111da01 00000000
> [    5.193161] Call Trace:
> [    5.193708]  [<c16bf243>] dump_stack+0x16/0x18
> [    5.194434]  [<c1055ae3>] warn_slowpath_common+0x83/0xb0
> [    5.195243]  [<c111da01>] ? exit_mmap+0x151/0x160
> [    5.195988]  [<c111da01>] ? exit_mmap+0x151/0x160
> [    5.196754]  [<c1055be2>] warn_slowpath_null+0x22/0x30
> [    5.197575]  [<c111da01>] exit_mmap+0x151/0x160
> [    5.198308]  [<c10533d3>] mmput+0x43/0xd0
> [    5.198990]  [<c114335d>] flush_old_exec+0x35d/0x7b0
> [    5.199800]  [<c1185fb8>] load_elf_binary+0x2a8/0xce0
> [    5.200599]  [<c1176e8e>] ? __fsnotify_parent+0xe/0x100
> [    5.201407]  [<c113dd02>] ? vfs_read+0xe2/0x100
> [    5.202137]  [<c1143b4f>] search_binary_handler+0x5f/0x110
> [    5.202964]  [<c1184979>] load_script+0x209/0x240
> [    5.203734]  [<c1070068>] ? atomic_notifier_chain_register+0xa8/0xb0
> [    5.204649]  [<c130269b>] ? __copy_from_user_ll+0xb/0xe0
> [    5.205463]  [<c1302a84>] ? _copy_from_user+0x54/0x60
> [    5.206248]  [<c10fa218>] ? put_page+0x8/0x40
> [    5.206973]  [<c1142709>] ? copy_strings+0x259/0x2b0
> [    5.207756]  [<c1075d80>] ? preempt_count_sub+0xa0/0x100
> [    5.208569]  [<c1143b4f>] search_binary_handler+0x5f/0x110
> [    5.209392]  [<c1144104>] do_execveat_common+0x504/0x690
> [    5.210205]  [<c1146585>] ? getname_flags+0x25/0x110
> [    5.210981]  [<c1144534>] SyS_execve+0x34/0x40
> [    5.211709]  [<c16c6a22>] sysenter_do_call+0x12/0x12
> [    5.212484] ---[ end trace 863af1d202a59fb4 ]---
> [    5.214592] ------------[ cut here ]------------


http://lkml.kernel.org/r/20150126115612.GA25833@node.dhcp.inet.fi
-- 
 Kirill A. Shutemov
