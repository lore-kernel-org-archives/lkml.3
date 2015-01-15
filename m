Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbbAONa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:30:57 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:47963 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbbAONaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:30:55 -0500
Message-ID: <54B7C10D.1090008@atmel.com>
Date: Thu, 15 Jan 2015 14:30:53 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH 00/12] Atmel matrix, SMC and UDC rework
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/01/2015 17:21, Alexandre Belloni a écrit :
> Hi Felipe,
> 
> The following series replace the previous series sent by Boris named:
>  - [PATCH v5 00/11] memory: add Atmel EBI (External Bus Interface) driver
>  - [PATCH 00/11] usb: gadget: at91_udc: Rework for multi-platform support
> 
> The patches I left out are less urgent and will be resent later, probably for
> 3.21.
> 
> Because of the dependancy between the syscon addition and the at91_udc series,
> this can go through the AT91 tree if you giv your ack on the udc patches.
> 
> The first 4 patches introduce 2 syscon devices needed to configure the
> matrix and SMC.
> The following patches rework the at91_udc driver to prepare at91 for
> multi-platform support.
> 
> It also include several fixes:
>  - fix clock names to be consistent with other USB drivers
>  - document clocks and clock-names properties in atmel-usb DT bindings doc
> 
> and some cleanup changes:
>  - remove useless usb_clk
>  - allocate at91_udc instance instead of using the statically defined one
>  - simplify the probe and remove functions by using devm_ helpers
>  - remove !DT specific code
> 
> Changes from the previous series:
>  - rebased on 3.19-rc1
>
> Boris Brezillon (12):
>   mfd: syscon: Add atmel-matrix registers definition
>   mfd: syscon: Add Atmel Matrix bus DT binding documentation
>   mfd: syscon: Add atmel-smc registers definition
>   mfd: syscon: Add Atmel SMC binding doc

I already acknowledged these 4 patches as part of another series.

>   usb: gadget: at91_udc: Fix clock names
>   usb: gadget: at91_udc: Drop uclk clock
>   usb: gadget: at91_udc: Document DT clocks and clock-names property
>   usb: gadget: at91_udc: Remove non-DT handling code
>   usb: gadget: at91_udc: Simplify probe and remove functions
>   usb: gadget: at91_udc: Rework for multi-platform kernel support
>   usb: gadget: at91_udc: Update DT binding documentation
>   usb: gadget: at91_udc: Allocate udc instance

I'm fine with all this:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Great, I plan to add them all to the at91-3.20-drivers branch now.

Thanks, best regards.


>  .../devicetree/bindings/mfd/atmel-matrix.txt       |  24 +
>  .../devicetree/bindings/mfd/atmel-smc.txt          |  19 +
>  .../devicetree/bindings/usb/atmel-usb.txt          |  10 +-
>  drivers/usb/gadget/udc/Kconfig                     |   1 +
>  drivers/usb/gadget/udc/at91_udc.c                  | 525 +++++++++++----------
>  drivers/usb/gadget/udc/at91_udc.h                  |   9 +-
>  include/linux/mfd/syscon/atmel-matrix.h            | 117 +++++
>  include/linux/mfd/syscon/atmel-smc.h               | 173 +++++++
>  8 files changed, 623 insertions(+), 255 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/atmel-matrix.txt
>  create mode 100644 Documentation/devicetree/bindings/mfd/atmel-smc.txt
>  create mode 100644 include/linux/mfd/syscon/atmel-matrix.h
>  create mode 100644 include/linux/mfd/syscon/atmel-smc.h
> 


-- 
Nicolas Ferre
