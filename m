Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaF3KZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:25:23 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59047 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067AbaF3KZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:25:22 -0400
Message-ID: <53B13B0B.5030809@mev.co.uk>
Date: Mon, 30 Jun 2014 11:25:15 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] staging: comedi: addi_apci_1564: miscellaneous fixes
 and cleanups
References: <1403930876-27678-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1403930876-27678-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-28 05:47, Chase Southwood wrote:
> This patchset moves a misplaced include to the proper file, swaps out an overly
> aggressive placement of apci1564_reset(), and cleans up apci1564_interrupt().
>
> Chase Southwood (3):
>    staging: comedi: addi_apci_1564: move addi_watchdog.h include to
>      addi_apci_1564.c
>    staging: comedi: addi_apci_1564: fix use of apci1564_reset() to
>      disable DI interrupts
>    staging: comedi: addi_apci_1564: clean up apci1564_interrupt()
>

It's okay, but I think you can simplify the interrupt handling a bit 
more by not bothering to check for interrupts from unknown sources.   If 
a source hasn't been enabled, it shouldn't generate interrupts, right? 
Besides, since the does nothing to stop further interrupts from unknown 
sources, it would just keep getting further interrupts repeatedly in 
that case.

Then you can get rid of the ui_DO, ui_DI, ui_Timer, and counters[] 
variables and just check the registers directly (e.g. replace 'if 
(ui_Timer == 1)' with 'if (inl(devpriv->amcc_iobase + 
APCI1564_TIMER_IRQ_REG) & 0x01)').

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
