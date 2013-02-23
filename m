Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab3BWBHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 20:07:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39628 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab3BWBHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 20:07:33 -0500
Date: Fri, 22 Feb 2013 20:07:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: rafael.j.wysocki@intel.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: Regression introduced by
 805d410fb0dbd65e1a57a810858fa2491e75822d (ACPI: Separate adding ACPI device
 objects from probing ACPI drivers) in v3.9-rc0
Message-ID: <20130223010723.GA9542@phenom.dumpdata.com>
References: <20130222214811.GA25445@phenom.dumpdata.com>
 <CAE9FiQUjj_bqF0aLVHDg01rc+A-1xKMuFc0yHN6Tqnxc5A-h3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUjj_bqF0aLVHDg01rc+A-1xKMuFc0yHN6Tqnxc5A-h3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > [    1.830762] IP: [<ffffffff813862fa>] apei_hest_parse+0x2a/0x140
> > [    1.830780] PGD 0
> > [    1.830791] Oops: 0000 [#1] SMP
> > [    1.830806] Modules linked in:
> > [    1.830819] CPU 0
> > [    1.830827] Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc2upstream-00002-g92ef2a2 #1
> > [    1.830838] RIP: e030:[<ffffffff813862fa>]  [<ffffffff813862fa>] apei_hest_parse+0x2a/0x140
> > [    1.830853] RSP: e02b:ffff88005bb69e98  EFLAGS: 00010246
> > [    1.830862] RAX: 00000000ffffffea RBX: 0000000000000030 RCX: 0000000000000017
> > [    1.830871] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81328b30
> > [    1.830880] RBP: ffff88005bb69eb8 R08: 00000000833df7a7 R09: 0720072007200720
> > [    1.830890] R10: 0720072007200720 R11: 0720072007200720 R12: 0000000000000000
> > [    1.830899] R13: ffffffff81328b30 R14: 0000000000000000 R15: 0000000000000000
> > [    1.830913] FS:  0000000000000000(0000) GS:ffff88005d600000(0000) knlGS:0000000000000000
> > [    1.830926] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [    1.830935] CR2: 0000000000000024 CR3: 0000000001a0c000 CR4: 0000000000040660
> > [    1.830945] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [    1.830955] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [    1.830965] Process swapper/0 (pid: 1, threadinfo ffff88005bb68000, task ffff88005bb627f0)
> > [    1.830975] Stack:
> > [    1.830981]  0000000000000030 0000000000000000 ffffffff81ae8f60 000000006d1ed4e7
> > [    1.831007]  ffff88005bb69ec8 ffffffff81328b8b ffff88005bb69ed8 ffffffff81ae8f72
> > [    1.831033]  ffff88005bb69f08 ffffffff81002124 0000000000000030 0000000000000007
> > [    1.831057] Call Trace:
> > [    1.831057]  [<ffffffff81ae8f60>] ? pcie_portdrv_init+0x7a/0x7a
> > [    1.831057]  [<ffffffff81328b8b>] aer_acpi_firmware_first+0x1b/0x30
> > [    1.831057]  [<ffffffff81ae8f72>] aer_service_init+0x12/0x2b
> > [    1.831057]  [<ffffffff81002124>] do_one_initcall+0x124/0x170
> > [    1.831057]  [<ffffffff81645404>] kernel_init+0x174/0x2f0
> > [    1.831057]  [<ffffffff81abd5ca>] ? parse_early_options+0x2b/0x2b
> > [    1.831057]  [<ffffffff81645290>] ? rest_init+0xa0/0xa0
> > [    1.831057]  [<ffffffff81663ffc>] ret_from_fork+0x7c/0xb0
> > [    1.831057]  [<ffffffff81645290>] ? rest_init+0xa0/0xa0
> > [    1.831057] Code: 90 55 80 3d 50 5f 8d 00 00 b8 ea ff ff ff 48 89 e5 41 56 49 89 f6 41 55 49 89 fd 41 54 53 0f 85 bd 00 00 00 48 8b 15 fe 7c 71 00 <44> 8b 4a 24 45 85 c9 0f 84 e1 00 00 00 0f b7 42 28 31 db 48 8d
> > [    1.831057] RIP  [<ffffffff813862fa>] apei_hest_parse+0x2a/0x140
> > [    1.831057]  RSP <ffff88005bb69e98>
> > [    1.831057] CR2: 0000000000000024
> > [    2.028436] ---[ end trace dad4411f23c0dcf5 ]---
> > [    2.028459] swapper/0 (1) used greatest stack depth: 5176 bytes left
> > [    2.028476] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
> > [    2.028476]
> > Parsing config from test.xm
> > Daemon running with PID 5069
> >
> 
> 
> https://patchwork.kernel.org/patch/2175871/

And Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thanks!

