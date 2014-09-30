Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaI3U2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:28:00 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:39509 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750901AbaI3U16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:27:58 -0400
Message-ID: <542B1242.1010609@hurleysoftware.com>
Date: Tue, 30 Sep 2014 16:27:46 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 02/13] tty: serial: 8250: make serial8250_console_setup()
 non _init
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de> <1412014009-13315-3-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1412014009-13315-3-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 02:06 PM, Sebastian Andrzej Siewior wrote:
> if I boot with console=ttyS0 and the omap driver is module I end up with
> 
> | console [ttyS0] disabled

Note to self: make ISA config optional.

> | omap8250 44e09000.serial: ttyS0 at MMIO 0x44e09000 (irq = 88, base_baud = 3000000) is a 8250
> | Unable to handle kernel paging request at virtual address c07a9de0
> | Modules linked in: 8250_omap(+)
> | CPU: 0 PID: 908 Comm: modprobe Not tainted 3.17.0-rc5+ #1593
> | PC is at serial8250_console_setup+0x0/0xc8
> | LR is at register_console+0x13c/0x3a4
> | [<c0078788>] (register_console) from [<c02d0340>] (uart_add_one_port+0x3cc/0x420)
> | [<c02d0340>] (uart_add_one_port) from [<c02d38a4>] (serial8250_register_8250_port+0x298/0x39c)
> | [<c02d38a4>] (serial8250_register_8250_port) from [<bf006274>] (omap8250_probe+0x218/0x3dc [8250_omap])
> | [<bf006274>] (omap8250_probe [8250_omap]) from [<c02e3424>] (platform_drv_probe+0x2c/0x5c)
> | [<c02e3424>] (platform_drv_probe) from [<c02e1eac>] (driver_probe_device+0x104/0x228)
> …
> | [<c009fa48>] (SyS_init_module) from [<c000e6e0>] (ret_fast_syscall+0x0/0x30)
> | Code: 7823603b f8314620 051b3013 491ed416 (44792204)
> 
> because serial8250_console_setup() is already gone.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
