Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaJPRQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:16:00 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50256 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaJPRP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:15:58 -0400
Date: Thu, 16 Oct 2014 10:15:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 16
Message-ID: <20141016171552.GA19765@roeck-us.net>
References: <20141016161128.3be4aa13@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016161128.3be4aa13@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 04:11:28PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any material intended for v3.19 to your linux-next
> included trees until after v3.18-rc1 has been released.
> 
> Changes since 20141015:
> 
> The net tree lost its build failure.
> 
> The thermal tree gained a build failure for which I reverted a commit.
> 
> The akpm-current tree gained a build failure for which I applied a patch.
> 
> The akpm tree lost a patch that turned up elsewhere.
> 
> Non-merge commits (relative to Linus' tree): 1106
>  1073 files changed, 32703 insertions(+), 16141 deletions(-)
> 
> ----------------------------------------------------------------------------
> 

There are some new build failures, so here is a complete list of all the
problems I am seeing in my builds.

Guenter
---

arm:at91_dt_defconfig
arm:sama5_defconfig
arm:at91rm9200_defconfig

drivers/tty/serial/atmel_serial.c:717:3:
	error: implicit declaration of function 'dmaengine_terminate_all'
drivers/tty/serial/atmel_serial.c:724:2:
	error: implicit declaration of function 'async_tx_ack'
drivers/tty/serial/atmel_serial.c: In function 'atmel_release_tx_dma':
drivers/tty/serial/atmel_serial.c:746:3:
	error: implicit declaration of function 'dma_release_channel'
drivers/tty/serial/atmel_serial.c: In function 'atmel_tx_dma':
drivers/tty/serial/atmel_serial.c:790:3:
	error: implicit declaration of function 'dmaengine_prep_slave_sg'
drivers/tty/serial/atmel_serial.c:793:7: error: 'DMA_MEM_TO_DEV' undeclared

and more similar problems.

---
arm64:defconfig

mm/gup.c: In function '__get_user_pages_fast':
mm/gup.c:963:3: error: implicit declaration of function 'pgd_huge'

---
avr32:defconfig

drivers/input/leds.o: In function `init_module':
leds.c:(.init.text+0x0): multiple definition of `init_module'
drivers/input/input.o:input.c:(.init.text+0x0): first defined here
drivers/input/leds.o: In function `cleanup_module':
leds.c:(.exit.text+0x0): multiple definition of `cleanup_module'
drivers/input/input.o:input.c:(.exit.text+0x0): first defined here

---
avr32:merisc_defconfig
avr32:atngw100mkii_evklcd101_defconfig

drivers/tty/serial/atmel_serial.c: In function 'atmel_get_lines_status':
drivers/tty/serial/atmel_serial.c:254:
	error: 'struct atmel_uart_port' has no member named 'gpios'

drivers/tty/serial/atmel_serial.c: In function 'atmel_config_rs485':
drivers/tty/serial/atmel_serial.c:301:
	error: 'struct atmel_uart_port' has no member named 'tx_done_mask'
drivers/tty/serial/atmel_serial.c:308:
	error: 'struct atmel_uart_port' has no member named 'rs485'

and many more similar problems. Also there are the same dma related errors as
for the arm builds.

---
sparc64:allmodconfig

drivers/bcma/main.c: In function 'bcma_of_find_child_device':
drivers/bcma/main.c:150:3:
	error: implicit declaration of function 'of_translate_address'

---
