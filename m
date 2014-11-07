Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaKGJRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:17:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:23010 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaKGJRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:17:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,330,1413270000"; 
   d="scan'208";a="628212515"
Message-ID: <1415351762.14686.99.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [LKP] [dmi] PANIC: early exception 0e rip 10:ffffffff81899e6b
 error 9 cr2 ffffffffff240000
From: Matt Fleming <matt.fleming@intel.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC: LKP <lkp@01.org>, Leif Lindholm <leif.lindholm@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Date: Fri, 7 Nov 2014 09:16:02 +0000
In-Reply-To: <CAKv+Gu9_ipZe-BV_CxhYVdv2mPrab3EXdznJUd-Unbw3usmckw@mail.gmail.com>
References: <20141107054741.GB30507@yliu-dev.sh.intel.com>
	 <CAKv+Gu9_ipZe-BV_CxhYVdv2mPrab3EXdznJUd-Unbw3usmckw@mail.gmail.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.180]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 08:17 +0100, Ard Biesheuvel wrote:
> On 7 November 2014 06:47, LKP <lkp@01.org> wrote:
> > FYI, we noticed the below changes on
> >
> > https://git.linaro.org/people/ard.biesheuvel/linux-arm efi-for-3.19
> > commit aacdce6e880894acb57d71dcb2e3fc61b4ed4e96 ("dmi: add support for SMBIOS 3.0 64-bit entry point")
> >
> >
> > +-----------------------+------------+------------+
> > |                       | 2fa165a26c | aacdce6e88 |
> > +-----------------------+------------+------------+
> > | boot_successes        | 20         | 10         |
> > | early-boot-hang       | 1          |            |
> > | boot_failures         | 0          | 5          |
> > | PANIC:early_exception | 0          | 5          |
> > +-----------------------+------------+------------+
> >
> >
> > [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000036fffffff] usable
> > [    0.000000] bootconsole [earlyser0] enabled
> > [    0.000000] NX (Execute Disable) protection: active
> > PANIC: early exception 0e rip 10:ffffffff81899e6b error 9 cr2 ffffffffff240000
> > [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc2-gc5221e6 #1
> > [    0.000000]  0000000000000000 ffffffff82203d30 ffffffff819f0a6e 00000000000003f8
> > [    0.000000]  ffffffffff240000 ffffffff82203e18 ffffffff823701b0 ffffffff82511401
> > [    0.000000]  0000000000000000 0000000000000ba3 0000000000000000 ffffffffff240000
> > [    0.000000] Call Trace:
> > [    0.000000]  [<ffffffff819f0a6e>] dump_stack+0x4e/0x68
> > [    0.000000]  [<ffffffff823701b0>] early_idt_handler+0x90/0xb7
> > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
> > [    0.000000]  [<ffffffff81899e6b>] ? dmi_table+0x3f/0x94
> > [    0.000000]  [<ffffffff81899e42>] ? dmi_table+0x16/0x94
> > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
> > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
> > [    0.000000]  [<ffffffff823c7eff>] dmi_walk_early+0x44/0x69
> > [    0.000000]  [<ffffffff823c88a2>] dmi_present+0x180/0x1ff
> > [    0.000000]  [<ffffffff823c8ab3>] dmi_scan_machine+0x144/0x191
> > [    0.000000]  [<ffffffff82370702>] ? loglevel+0x31/0x31
> > [    0.000000]  [<ffffffff82377f52>] setup_arch+0x490/0xc73
> > [    0.000000]  [<ffffffff819eef73>] ? printk+0x4d/0x4f
> > [    0.000000]  [<ffffffff82370b90>] start_kernel+0x9c/0x43f
> > [    0.000000]  [<ffffffff82370120>] ? early_idt_handlers+0x120/0x120
> > [    0.000000]  [<ffffffff823704a2>] x86_64_start_reservations+0x2a/0x2c
> > [    0.000000]  [<ffffffff823705df>] x86_64_start_kernel+0x13b/0x14a
> > [    0.000000] RIP 0x4
> >
> 
> This is most puzzling. Could anyone decode the exception?
> This looks like the non-EFI path through dmi_scan_machine(), which
> calls dmi_present() /after/ calling dmi_smbios3_present(), which
> apparently has not found the _SM3_ header tag. Or could the call stack
> be inaccurate?

The code triggered a page fault while trying to access
0xffffffffff240000, caused because the reserved bit was set in the page
table and no page was found. Looks like it jumped through a bogus
pointer.

And yes, the callstack may definitely be wrong - the stack dumper is
just scraping addresses from the stack, as indicated by the '?' symbol.

Yuanhan, what symbol does 0xffffffff81899e6b (the faulting instruction)
translate to?

