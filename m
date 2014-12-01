Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaLARjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:39:49 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:54210 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaLARjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:39:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAOiHx=nb4Ub_bseHUrz+HrnJxDEKMijQ=r+ASZ-p5MtTi81Big@mail.gmail.com>
References: <1417149142-3756-1-git-send-email-cernekee@gmail.com>
 <1417149142-3756-9-git-send-email-cernekee@gmail.com> <CAOiHx=nb4Ub_bseHUrz+HrnJxDEKMijQ=r+ASZ-p5MtTi81Big@mail.gmail.com>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 1 Dec 2014 09:39:26 -0800
Message-ID: <CAJiQ=7D631F1wkegeKup7yeB-wgjKLjvD3V1-n8fu3aW=fOm0g@mail.gmail.com>
Subject: Re: [PATCH V4 08/16] irqchip: Add new driver for BCM7038-style level
 1 interrupt controllers
To: Jonas Gorski <jogo@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Brian Norris <computersforpeace@gmail.com>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 8:09 AM, Jonas Gorski <jogo@openwrt.org> wrote:
> I'm not that firm in interrupt controller terminology, but can this be
> a level 1 interrupt controller if it has a parent interrupt
> controller? Isn't the parent the level 1 interrupt controller? Or
> would the parent then be a level 0 interrupt controller? ;-)

According to the register manual, this is an L1 controller and the
"IRQ0" controller handled by irq-bcm7120-l2.c is an L2 controller.

This terminology is used consistently across the MIPS and ARM STB
chips, but it is worth noting that MIPS has a builtin "L0 controller"
(not a published term) to demux the 5 HW IRQ lines, while ARM only
uses a single IRQ input for peripherals.  On STB MIPS platforms it is
typical to only use one HW IRQ input per CPU (TP).

Also note that brcm,bcm3384-l2-intc can either be used for an L1
(PERIPH INT block) or an L2/L3 (ZMIPS/CMIPS/IOP).
