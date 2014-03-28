Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaC1PGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 11:06:17 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:36719 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbaC1PGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 11:06:16 -0400
Message-ID: <53358FE0.2060105@dev.rtsoft.ru>
Date: Fri, 28 Mar 2014 19:06:08 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: Xianghua Xiao <x.xiao@freescale.com>, Jason Jin <Jason.jin@freescale.com>,
        Jon Loelier <jdl@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
CC: "Vadim V. Vlasov" <vvlasov@dev.rtsoft.ru>,
        "'Alexey Lugovskoy'" <lugovskoy@dev.rtsoft.ru>,
        linux-kernel@vger.kernel.org
Subject: ULI M1575 question
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello people

I'm writing you since your addresses are in Signed-Of-By lines of commit
0e65bfe34c1 ("[POWERPC] Add initial MPC8610 HPCD Platform files") in
linux kernel git tree.

This commit has quirk_uli1575() routine, that has followinf lines:

    /* Disable INTx */
    pci_read_config_dword(dev, 0x48, &temp32);
    pci_write_config_dword(dev, 0x48, (temp32 | 1<<26));

This code is still in kernel, just moved to
  arch/powerpc/platforms/fsl_uli1575.c
at some point.

Could you please explain what "Disable INTx" comment means, and why
setting bit 2 of PCI configuration byte with offset 0x4b does that?

Per ULI1575 datasheet that we've been able to find in the net, this bit
is part of 4-bit field "PIRQG# routing table", thus setting it alone
looks very strange.


The reason for asking is the following.

We are trying to overcome a very unpleasant problem with ULI M1575 on
Freescale P2020DS and MPC8572DS boards. On both boards, when running
CONFIG_PREEMPT_RT_FULL kernel and trying to use PCI ethernet adapter in
PCI slot, we are getting irq storm on MPIC IRQ that is used by i8259,
while i8259 reports no irq.

Looks like same MPIC input is triggered by something else. Which, per
CPU reference guide, could be caused by "Assert INTx" message received
from ULI1575 over PCIe bus. However, ULI1575 document we have does not
say anything about usage of "Assert INTx" on upstream bus. Instead, it
documents how to route IRQs via built-in i8259-compatible interrupt
controller.

Mention of "Disable INTx" in your code raises some ideas that perhaps
ULI *does* use INTx, and that could be somehow disabled...


Thanks in advance.
Nikita Yushchenko
RTsoft Sortware Development Center.

