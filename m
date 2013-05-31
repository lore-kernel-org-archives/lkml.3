Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3EaTYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:24:03 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:64908 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3EaTX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:23:56 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/1] i2c: omap: correct usage of the interrupt enable register
References: <1370007211-9736-1-git-send-email-oleksandr.dmytryshyn@ti.com>
Date: Fri, 31 May 2013 12:23:52 -0700
In-Reply-To: <1370007211-9736-1-git-send-email-oleksandr.dmytryshyn@ti.com>
	(Oleksandr Dmytryshyn's message of "Fri, 31 May 2013 16:33:30 +0300")
Message-ID: <87vc5zymuv.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleksandr Dmytryshyn <oleksandr.dmytryshyn@ti.com> writes:

> I've just removed unnecessary Change-Id line.
>
> If the i2c controller during suspend will generate an interrupt, it
> can lead to unpredictable behaviour in the kernel.
>
> Based on the logic of the kernel code interrupts from i2c should be
> prohibited during suspend. Kernel writes 0 to the I2C_IE register in
> the omap_i2c_runtime_suspend() function. In the other side kernel
> writes saved interrupt flags to the I2C_IE register in
> omap_i2c_runtime_resume() function. I.e. interrupts should be disabled
> during suspend.
>
> This works for chips with version1 registers scheme. Interrupts are
> disabled during suspend. For chips with version2 scheme registers
> writting 0 to the I2C_IE register does nothing (because now the
> I2C_IRQENABLE_SET register is located at this address). This register
> is used to enable interrupts. For disabling interrupts
> I2C_IRQENABLE_CLR register should be used.
>
> Because the registers I2C_IRQENABLE_SET and I2C_IE have the same
> addresses, the interrupt enabling procedure is unchanged.
>
> I've checked that interrupts in the i2c controller are still enabled
> after writting 0 to the I2C_IE register. But with my patch interrupts
> are disabled in the omap_i2c_runtime_suspend() function. 
>
> This has been working up until now because we've just been lucky. 

This belongs in the changelog of the patch, not the cover letter and
needs more detail.

Also, you don't need a cover letter on a 1-patch series.

Kevin

> Next patch fixes it.
>
> Patch is based on:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> tag: v3.10-rc2
>
> Verified on OMAP4430.
>
> Oleksandr Dmytryshyn (1):
>   i2c: omap: correct usage of the interrupt enable register
>
>  drivers/i2c/busses/i2c-omap.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
