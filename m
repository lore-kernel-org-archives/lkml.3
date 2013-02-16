Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab3BPWSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 17:18:11 -0500
Received: from blu0-omc1-s5.blu0.hotmail.com ([65.55.116.16]:31327 "EHLO
	blu0-omc1-s5.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754617Ab3BPWSJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 17:18:09 -0500
X-EIP: [qmloAyHN8sszu1mISJpWboF6QNdebjyxpBSq4T8Jfsc=]
X-Originating-Email: [emilio@elopez.com.ar]
Message-ID: <BLU0-SMTP3204E8218EA90D50AB340558A0D0@phx.gbl>
Date: Sat, 16 Feb 2013 19:18:04 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: arm@kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/11] ARM: disable virt_to_bus/virt_to_bus almost everywhere
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de> <1360849767-1463135-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1360849767-1463135-2-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Feb 2013 22:18:08.0282 (UTC) FILETIME=[7FB817A0:01CE0C93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

El 14/02/13 10:49, Arnd Bergmann escribió:
> We are getting a number of warnings about the use of the deprecated
> bus_to_virt function in drivers using the ARM ISA DMA API:
> 
> drivers/parport/parport_pc.c: In function 'parport_pc_fifo_write_block_dma':
> drivers/parport/parport_pc.c:622:3: warning: 'bus_to_virt' is deprecated
> (declared at arch/arm/include/asm/memory.h:253) [-Wdeprecated-declarations]
> 
> This is only because that function gets used by the inline
> set_dma_addr() helper. We know that any driver for the ISA DMA API
> is correctly using the DMA addresses, so we can change this
> to use the __bus_to_virt() function instead, which does not warn.
> 
> After this, there are no remaining drivers that are used on
> any defconfigs on ARM using virt_to_bus or bus_to_virt, with
> the exception of the OSS sound driver. That driver is only used
> on RiscPC, NetWinder and Shark, so we can set ARCH_NO_VIRT_TO_BUS
> on all other platforms and hide the deprecated functions, which
> is far more effective than marking them as deprecated, in order
> to avoid any new users of that code.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Russell King <linux@arm.linux.org.uk>

Small nitpick: Please have a look at the patch subject, I suppose you
meant something like "virt_to_bus/bus_to_virt" instead of
"virt_to_bus/virt_to_bus".

Thanks,

Emilio
