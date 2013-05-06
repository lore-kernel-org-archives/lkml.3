Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3EFVVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:21:17 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:37172 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab3EFVVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 17:21:15 -0400
From: "Ortiz, Lance E" <lance.oritz@hp.com>
To: Borislav Petkov <bp@alien8.de>,
        =?utf-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux-ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Dall, Elizabeth J (MCLinux)" <betty.dall@hp.com>
Subject: RE: WARNING at drivers/pci/search.c:214 for 3.9
Thread-Topic: WARNING at drivers/pci/search.c:214 for 3.9
Thread-Index: AQHOSmT7XmlaV8+Pw0um1uzzkieDY5j4QjGAgABiRIA=
Date: Mon, 6 May 2013 21:20:04 +0000
Message-ID: <A961433CDFF2F640A2866803152E61F951772648@G9W0715.americas.hpqcorp.net>
References: <20130506162112.6b79b7b1@pluto.restena.lu>
 <20130506150757.GC22041@pd.tnic>
In-Reply-To: <20130506150757.GC22041@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.31]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r46LLMBc027132

> > [   69.965933] ------------[ cut here ]------------
> > [   69.965938] WARNING: at /data/kernel/linux-
> git/drivers/pci/search.c:214 pci_get_dev_by_id+0x8a/0x90()
> > [   69.965941] Hardware name: PRIMERGY RX200 S7
> > [   69.965946] Modules linked in:
> > [   69.965950] Pid: 0, comm: swapper/11 Tainted: G        W    3.9.0-
> x86_64-fj #1
> > [   69.965953] Call Trace:
> > [   69.965956]  <IRQ>  [<ffffffff8106689a>]
> warn_slowpath_common+0x7a/0xc0
> > [   69.965967]  [<ffffffff810668f5>] warn_slowpath_null+0x15/0x20
> > [   69.965975]  [<ffffffff8125b98a>] pci_get_dev_by_id+0x8a/0x90
> > [   69.965981]  [<ffffffff8125baa0>] pci_get_subsys+0x30/0x40
> > [   69.965987]  [<ffffffff8125bac3>] pci_get_device+0x13/0x20
> > [   69.965993]  [<ffffffff8125baff>]
> pci_get_domain_bus_and_slot+0x2f/0x70
> > [   69.966001]  [<ffffffff812bf3ed>]
> cper_print_pcie.isra.1+0x5d/0x200
> > [   69.966007]  [<ffffffff812bf8c5>]
> apei_estatus_print_section+0x1e5/0x2c0
> > [   69.966013]  [<ffffffff812bfa27>] apei_estatus_print+0x87/0xb0
> > [   69.966019]  [<ffffffff812c2015>]
> __ghes_print_estatus.isra.8+0x75/0xc0
> > [   69.966027]  [<ffffffff81239d50>] ? ___ratelimit.part.0+0x80/0xe0
> > [   69.966033]  [<ffffffff812c20b9>]
> ghes_print_estatus.constprop.10+0x59/0x70
> > [   69.966039]  [<ffffffff812c24f0>] ? ghes_irq_func+0x20/0x20
> > [   69.966044]  [<ffffffff812c244c>] ghes_proc+0x5c/0x70
> > [   69.966050]  [<ffffffff812c2501>] ghes_poll_func+0x11/0x30
> > [   69.966057]  [<ffffffff8107332d>] call_timer_fn.isra.30+0x2d/0x90
> > [   69.966065]  [<ffffffff81073536>] run_timer_softirq+0x1a6/0x1e0
> > [   69.966071]  [<ffffffff8106dcc8>] __do_softirq+0xc8/0x180
> > [   69.966077]  [<ffffffff8106dec6>] irq_exit+0x86/0xa0
> > [   69.966084]  [<ffffffff810248d9>]
> smp_apic_timer_interrupt+0x69/0xa0
> > [   69.966090]  [<ffffffff815f4b4a>] apic_timer_interrupt+0x6a/0x70
> > [   69.966093]  <EOI>  [<ffffffff814c8408>] ?
> cpuidle_wrap_enter+0x48/0x90
> > [   69.966101]  [<ffffffff814c8404>] ? cpuidle_wrap_enter+0x44/0x90
> > [   69.966107]  [<ffffffff814c8460>] cpuidle_enter_tk+0x10/0x20
> > [   69.966116]  [<ffffffff814c81c5>] cpuidle_idle_call+0x85/0x100
> > [   69.966122]  [<ffffffff8100b97f>] cpu_idle+0xbf/0x110
> > [   69.966129]  [<ffffffff815db2ed>] start_secondary+0xbd/0xbf
> > [   69.966134] ---[ end trace 9ea0454133ddf8a3 ]---
> 
> Apparently you're not supposed to do pci_get* in IRQ context. But this
> code is older than 3.9 so why does it trigger now?

Right Boris, looks like we are hitting the WARN_ON(in_interrupt) in pci_get_dev_by_id().  We recently started seeing this on our test systems when injecting errors.  The only reason we are calling pci_get_domain_bus_and_slot() is to get the pci_dev* to pass into cper_print_aer() so we can have the device's name to put into the trace event for AER.  If we can find another way to get the device name for the trace event we could remove this call to pci_get_domain_bus_and_slot().  I will continue to look into an alternative. If you have any ideas on how to get the device data from this context let me know.

I'm not sure why the pci_get_domain_bus_and_slot() is failing to find the PCI device though.  We are not hitting that issue.  We are just seeing the in_interrupt warning.

Lance
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
