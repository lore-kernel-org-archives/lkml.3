Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaKGJaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:30:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:37408 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaKGJaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:30:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,330,1413270000"; 
   d="scan'208";a="628217438"
Date: Fri, 7 Nov 2014 17:30:31 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKP <lkp@01.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [LKP] [dmi] PANIC: early exception 0e rip 10:ffffffff81899e6b
 error 9 cr2 ffffffffff240000
Message-ID: <20141107093031.GF24745@yliu-dev.sh.intel.com>
References: <20141107054741.GB30507@yliu-dev.sh.intel.com>
 <CAKv+Gu9_ipZe-BV_CxhYVdv2mPrab3EXdznJUd-Unbw3usmckw@mail.gmail.com>
 <1415351762.14686.99.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415351762.14686.99.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 09:16:02AM +0000, Matt Fleming wrote:
> On Fri, 2014-11-07 at 08:17 +0100, Ard Biesheuvel wrote:
> > On 7 November 2014 06:47, LKP <lkp@01.org> wrote:
> > > FYI, we noticed the below changes on
> > >
> > > https://git.linaro.org/people/ard.biesheuvel/linux-arm efi-for-3.19
> > > commit aacdce6e880894acb57d71dcb2e3fc61b4ed4e96 ("dmi: add support for SMBIOS 3.0 64-bit entry point")
> > >
> > >
> > > +-----------------------+------------+------------+
> > > |                       | 2fa165a26c | aacdce6e88 |
> > > +-----------------------+------------+------------+
> > > | boot_successes        | 20         | 10         |
> > > | early-boot-hang       | 1          |            |
> > > | boot_failures         | 0          | 5          |
> > > | PANIC:early_exception | 0          | 5          |
> > > +-----------------------+------------+------------+
> > >
> > >
> > > [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000036fffffff] usable
> > > [    0.000000] bootconsole [earlyser0] enabled
> > > [    0.000000] NX (Execute Disable) protection: active
> > > PANIC: early exception 0e rip 10:ffffffff81899e6b error 9 cr2 ffffffffff240000
> > > [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc2-gc5221e6 #1
> > > [    0.000000]  0000000000000000 ffffffff82203d30 ffffffff819f0a6e 00000000000003f8
> > > [    0.000000]  ffffffffff240000 ffffffff82203e18 ffffffff823701b0 ffffffff82511401
> > > [    0.000000]  0000000000000000 0000000000000ba3 0000000000000000 ffffffffff240000
> > > [    0.000000] Call Trace:
> > > [    0.000000]  [<ffffffff819f0a6e>] dump_stack+0x4e/0x68
> > > [    0.000000]  [<ffffffff823701b0>] early_idt_handler+0x90/0xb7
> > > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
> > > [    0.000000]  [<ffffffff81899e6b>] ? dmi_table+0x3f/0x94
> > > [    0.000000]  [<ffffffff81899e42>] ? dmi_table+0x16/0x94
> > > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
> > > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
> > > [    0.000000]  [<ffffffff823c7eff>] dmi_walk_early+0x44/0x69
> > > [    0.000000]  [<ffffffff823c88a2>] dmi_present+0x180/0x1ff
> > > [    0.000000]  [<ffffffff823c8ab3>] dmi_scan_machine+0x144/0x191
> > > [    0.000000]  [<ffffffff82370702>] ? loglevel+0x31/0x31
> > > [    0.000000]  [<ffffffff82377f52>] setup_arch+0x490/0xc73
> > > [    0.000000]  [<ffffffff819eef73>] ? printk+0x4d/0x4f
> > > [    0.000000]  [<ffffffff82370b90>] start_kernel+0x9c/0x43f
> > > [    0.000000]  [<ffffffff82370120>] ? early_idt_handlers+0x120/0x120
> > > [    0.000000]  [<ffffffff823704a2>] x86_64_start_reservations+0x2a/0x2c
> > > [    0.000000]  [<ffffffff823705df>] x86_64_start_kernel+0x13b/0x14a
> > > [    0.000000] RIP 0x4
> > >
> > 
> > This is most puzzling. Could anyone decode the exception?
> > This looks like the non-EFI path through dmi_scan_machine(), which
> > calls dmi_present() /after/ calling dmi_smbios3_present(), which
> > apparently has not found the _SM3_ header tag. Or could the call stack
> > be inaccurate?
> 
> The code triggered a page fault while trying to access
> 0xffffffffff240000, caused because the reserved bit was set in the page
> table and no page was found. Looks like it jumped through a bogus
> pointer.
> 
> And yes, the callstack may definitely be wrong - the stack dumper is
> just scraping addresses from the stack, as indicated by the '?' symbol.
> 
> Yuanhan, what symbol does 0xffffffff81899e6b (the faulting instruction)
> translate to?

I found no System.map for that kernel, I then changed to another kernel,
and here is the new panic dmesg:

PANIC: early exception 0e rip 10:ffffffff8167aa1a error 9 cr2 ffffffffff240001
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc2-00008-g4d3a0be #66
[    0.000000]  0000000000000ba3 ffffffff81bcfd10 ffffffff818010a4 00000000000003f8
[    0.000000]  000000000000003e ffffffff81bcfdf8 ffffffff81d801b0 617420534f49424d
[    0.000000]  000000000000001f ffffffffff240000 0000000000000000 ffffffffff240000
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff818010a4>] dump_stack+0x46/0x58
[    0.000000]  [<ffffffff81d801b0>] early_idt_handler+0x90/0xb7
[    0.000000]  [<ffffffff81dd4cfc>] ? dmi_format_ids.constprop.9+0x13c/0x13c
[    0.000000]  [<ffffffff8167aa1a>] ? dmi_table+0x4a/0xf0
[    0.000000]  [<ffffffff817fa71b>] ? printk+0x61/0x63
[    0.000000]  [<ffffffff81dd4cfc>] ? dmi_format_ids.constprop.9+0x13c/0x13c
[    0.000000]  [<ffffffff81dd4cfc>] ? dmi_format_ids.constprop.9+0x13c/0x13c
[    0.000000]  [<ffffffff81dd49dc>] dmi_walk_early+0x6b/0x90
[    0.000000]  [<ffffffff81dd52fc>] dmi_present+0x1b4/0x23f
[    0.000000]  [<ffffffff81dd55ab>] dmi_scan_machine+0x1d4/0x23a
[    0.000000]  [<ffffffff81d80120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81d883a2>] setup_arch+0x462/0xcc6
[    0.000000]  [<ffffffff81d80120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81d80167>] ? early_idt_handler+0x47/0xb7
[    0.000000]  [<ffffffff81d80120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81d80cf0>] start_kernel+0x97/0x456
[    0.000000]  [<ffffffff81d80120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81d80120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81d805ee>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d8072e>] x86_64_start_kernel+0x13e/0x14d
[    0.000000] RIP 0xba2


The address changes to 10:ffffffff8167aa1a, and in the System.map, it has:

  ffffffff8167a9d0 t dmi_table
  ffffffff8167aac0 T dmi_name_in_vendors

Sorry, I don't know how to dig furture.

	--yliu
