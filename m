Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaBCOl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:41:26 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:60888 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451AbaBCOlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:41:25 -0500
Date: Mon, 3 Feb 2014 14:41:20 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: 3.13.0: crash on boot
Message-ID: <20140203144120.GA15384@console-pimps.org>
References: <20140131083707.GA9968@oktetlabs.ru>
 <CAErSpo6PaX2BcTqF4GD5ez3wDaPizUCNZJEjy_5EozAd3epoaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6PaX2BcTqF4GD5ez3wDaPizUCNZJEjy_5EozAd3epoaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan, at 11:29:39AM, Bjorn Helgaas wrote:
> [+cc Matt and Matthew; maybe EFI related?]
 
(Pulling in Borislav too)

Yeah, looks EFI related.

> On Fri, Jan 31, 2014 at 1:37 AM, Alexandra N. Kossovsky
> <Alexandra.Kossovsky@oktetlabs.ru> wrote:
> > Hello.
> >
> > I've got 3.13.0 kernel creshed on boot.  A lot of debug options are on.
> > Crash:
> > BUG: unable to handle kernel paging request at 000000012a53f020
> > IP: [<00000000cf038cc6>] 0xcf038cc6
> > PGD 2962067 PUD 2965067 PMD 12fe8f067 PTE 800000012a53f962
> > Oops: 0000 [#1] SMP
> > Modules linked in:
> > CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-debug-amd64 #2
> > Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.0b 09/17/2012
> > task: ffffffff81a134c0 ti: ffffffff81a00000 task.ti: ffffffff81a00000
> > RIP: 0010:[<00000000cf038cc6>]  [<00000000cf038cc6>] 0xcf038cc6
> > RSP: 0000:ffffffff81a01de0  EFLAGS: 00010083
> > RAX: 8000000000000000 RBX: 000000012a53f000 RCX: 0000000000000690
> > RDX: 000000012a53f000 RSI: 00000000cefbff18 RDI: 00000000cf037af4
> > RBP: 0000000000000690 R08: 0000000000000001 R09: 000000012a53f000
> > R10: ffff88012a409e80 R11: 0000000000000000 R12: 00000000cefbfe18
> > R13: 0000000000000001 R14: 0000000000000690 R15: 000000012a53f000
> > FS:  0000000000000000(0000) GS:ffff88012a800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffff88012a44cc58 CR3: 0000000001a0c000 CR4: 00000000000406b0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
> > Stack:
> >  ffffffff810bcf17 ffffffff81a01ee8 ffffffff81306a4a 0000000000000000
> >  00000000cf046a50 00000000cf038f36 00000000cefbfca0 0000000000000001
> >  0000000000000800 ffff88012fe8f040 800000012a408963 ffffffff81a01ee8
> > Call Trace:
> >  [<ffffffff810bcf17>] ? trace_hardirqs_off_caller+0x87/0x120
> >  [<ffffffff81306a4a>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> >  [<ffffffff81064406>] ? efi_call4+0x46/0x80
> >  [<ffffffff81cc4766>] ? efi_enter_virtual_mode+0x20b/0x3a5
> >  [<ffffffff81ca8e53>] ? start_kernel+0x3b3/0x443
> >  [<ffffffff81ca88a9>] ? repair_env_string+0x5c/0x5c
> >  [<ffffffff81ca8120>] ? early_idt_handlers+0x120/0x120
> >  [<ffffffff81ca8556>] ? x86_64_start_reservations+0x2a/0x2c
> >  [<ffffffff81ca869b>] ? x86_64_start_kernel+0x143/0x152
> > Code:  Bad RIP value.
> > RIP  [<00000000cf038cc6>] 0xcf038cc6
> >  RSP <ffffffff81a01de0>
> > CR2: 000000012a53f020
> > ---[ end trace 2fc4d26cbb5bd681 ]---

Alexandra, any chance you could try out a v3.14-rc1 kernel? Basically
all of the EFI memory mapping code was rewritten for v3.14.

-- 
Matt Fleming, Intel Open Source Technology Center
