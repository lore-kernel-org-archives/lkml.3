Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbbASVgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:36:18 -0500
Received: from senator.holtmann.net ([87.106.208.187]:54308 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbbASVgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:36:14 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH] bluetooth: Add hci_h4p driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141223130219.GA5731@amd>
Date: Mon, 19 Jan 2015 13:36:08 -0800
Cc: =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CB643345-4B50-4ED0-8C3E-296CD225754D@holtmann.org>
References: <20141223130219.GA5731@amd>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> Add HCI driver for H4 with Nokia extensions. This device is used on
> Nokia N900 cell phone.
> 
> Older version of this driver lived in staging, before being reverted
> in a4102f90e87cfaa3fdbed6fdf469b23f0eeb4bfd .
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Thanks-to: Sebastian Reichel <sre@debian.org>
> Thanks-to: Joe Perches <joe@perches.com>
> 
> ---
> 
> Please apply,
> 								Pavel
> 
> 
> Kconfig      |   10 
> Makefile     |    4 
> nokia_core.c | 1149 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> nokia_fw.c   |   99 +++++
> nokia_h4p.h  |  214 ++++++++++
> nokia_uart.c |  171 ++++++++
> 7 files changed, 1667 insertions(+)

so when I run this through checkpatch --strict, then I get tons of warning that we have DOS style ^M line breaks. There are also trailing whitespace that need fixing. I can use cleanpatch to do this, but so can you.

Even after doing that there are still obvious plain coding style violation in the patch. For example:

ERROR: space prohibited before that ',' (ctx:WxW)
#610: FILE: drivers/bluetooth/nokia_core.c:517:
+			__h4p_set_auto_ctsrts(info, 0 , UART_EFR_RTS);
 			                              ^

CHECK: Alignment should match open parenthesis
#662: FILE: drivers/bluetooth/nokia_core.c:569:
+		h4p_outb(info, UART_OMAP_SCR,
+			     h4p_inb(info, UART_OMAP_SCR) |

CHECK: Blank lines aren't necessary before a close brace '}'
#692: FILE: drivers/bluetooth/nokia_core.c:599:
+
+}

These are only few. They are more and all these need fixing before I even consider it.

Also this worries me:

WARNING: DT compatible string "brcm,uart,bcm2048" appears un-documented -- check ./Documentation/devicetree/bindings/
#1222: FILE: drivers/bluetooth/nokia_core.c:1129:
+	{ .compatible = "brcm,uart,bcm2048" },

Regards

Marcel

