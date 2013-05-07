Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab3EGDL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:11:56 -0400
Received: from mail-gg0-f170.google.com ([209.85.161.170]:48000 "EHLO
	mail-gg0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab3EGDLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:11:54 -0400
Message-ID: <51886FAF.1030801@lwfinger.net>
Date: Mon, 06 May 2013 22:06:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev@lists.infradead.org
Subject: Re: linux-next: Tree for May 6 (b43/bcma)
References: <20130506144207.c812a0227d7763d26e5fec80@canb.auug.org.au> <5187EB95.2060605@infradead.org>
In-Reply-To: <5187EB95.2060605@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 12:42 PM, Randy Dunlap wrote:
>
> on x86_64:
>
> drivers/built-in.o: In function `b43_gpio_cleanup.isra.40':
> main.c:(.text+0x1b425b): undefined reference to `bcma_chipco_gpio_control'
> drivers/built-in.o: In function `b43_wireless_core_reset':
> (.text+0x1b5fb6): undefined reference to `bcma_core_set_clockmode'
> drivers/built-in.o: In function `b43_wireless_core_reset':
> (.text+0x1b6058): undefined reference to `bcma_core_pll_ctl'
> drivers/built-in.o: In function `b43_chip_init':
> main.c:(.text+0x1b8444): undefined reference to `bcma_chipco_gpio_control'
> drivers/built-in.o: In function `b43_wireless_core_init':
> main.c:(.text+0x1b887b): undefined reference to `bcma_core_pci_irq_ctl'
> drivers/built-in.o: In function `b43_bus_bcma_device_disable':
> bus.c:(.text+0x1b9d46): undefined reference to `bcma_core_disable'
> drivers/built-in.o: In function `b43_bus_bcma_device_enable':
> bus.c:(.text+0x1b9d55): undefined reference to `bcma_core_enable'
> drivers/built-in.o: In function `b43_bus_bcma_device_is_enabled':
> bus.c:(.text+0x1b9d64): undefined reference to `bcma_core_is_enabled'
> drivers/built-in.o: In function `b43_nphy_channel_setup':
> phy_n.c:(.text+0x1c8fe5): undefined reference to `bcma_pmu_spuravoid_pllupdate'
> drivers/built-in.o: In function `b43_phy_initn':
> phy_n.c:(.text+0x1cb853): undefined reference to `bcma_chipco_gpio_control'
> drivers/built-in.o: In function `b43_dma_init':
> (.text+0x1d5790): undefined reference to `bcma_core_dma_translation'
> drivers/built-in.o: In function `b43_init':
> main.c:(.init.text+0xa07a): undefined reference to `__bcma_driver_register'
> main.c:(.init.text+0xa09f): undefined reference to `bcma_driver_unregister'
> drivers/built-in.o: In function `b43_exit':
> main.c:(.exit.text+0x153a): undefined reference to `bcma_driver_unregister'
>
>
> Probably mostly due to B43=y and BCMA=m.

Does any Kconfig wizard know the magic incantation to accomplish the following:

1. Ensure that if SSB and BMCA are both selected, then both are either "m" or "y"

2. Ensure that BRCMSMAC is not "y" if BMCA is "m".

3. Ensure that B43 is not "y" if SSB and/or BCMA is "m".

Thanks,

Larry


