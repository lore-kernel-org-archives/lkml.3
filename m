Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaETN6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:58:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47711 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaETN61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:58:27 -0400
Message-ID: <537B5F5E.9080703@ti.com>
Date: Tue, 20 May 2014 09:57:50 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 0/6] soc: ti: Add Keystone Navigator drivers
References: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
In-Reply-To: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Wednesday 23 April 2014 07:46 PM, Santosh Shilimkar wrote:
> Here is an updated version of the Keystone Navigator drivers after
> addressing comments from earlier version [1].
> 
> The QMSS found on Keystone SOCs is one of the main hardware sub
> system which forms the backbone of the Keystone Multi-core Navigator.
> QMSS consist of queue managers, packed-data structure processors(PDSP),
> linking RAM, descriptor pools and infrastructure DMA.
> 
> After the discussion and alignment [2] on Navigator DMA, now we pair
> this driver along with QMSS. Initially this driver was proposed as DMA
> engine driver but since the hardware is not typical DMA engine and doesn't
> comply with typical DMA engine driver needs, that approach was naked.
> 
> These two drivers works as infrastructure drivers for subsystems like
> Ethernet subsystem, SRIO subsystem, Crypto Engines etc on Keystone
> SOC families. Testing is done with NetCP(ethernet) subsystem drivers.
> 
> I would like to get these drivers merged in upcoming(3.16) window, so
> any help in terms of review is appreciated. Thanks
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> 
I plan to respin v3 of the series for the few device tree related
comments I received from Rob H (thanks Rob). Can you please have a
look and gsee if you have any comments so that I can include them
in next version.

thanks.

> Sandeep Nair (3):
>   firmware: add Keystone QMSS PDSP accumulator firmware blob
>   Documentation: dt: soc: add Keystone Navigator QMSS bindings
>   soc: ti: add Keystone Navigator QMSS driver
> 
> Santosh Shilimkar (3):
>   soc: Introduce drivers/soc place-holder for SOC specific drivers
>   Documentation: dt: soc: add Keystone Navigator DMA bindings
>   soc: ti: add Keystone Navigator DMA support
> 
>  .../bindings/soc/keystone-navigator-dma.txt        |  101 ++
>  .../bindings/soc/keystone-navigator-qmss.txt       |  232 +++
>  drivers/Kconfig                                    |    4 +
>  drivers/Makefile                                   |    3 +
>  drivers/soc/Kconfig                                |    5 +
>  drivers/soc/Makefile                               |    5 +
>  drivers/soc/ti/Kconfig                             |   31 +
>  drivers/soc/ti/Makefile                            |    5 +
>  drivers/soc/ti/knav_dma.c                          |  776 +++++++++
>  drivers/soc/ti/knav_qmss.h                         |  386 +++++
>  drivers/soc/ti/knav_qmss_acc.c                     |  591 +++++++
>  drivers/soc/ti/knav_qmss_queue.c                   | 1814 ++++++++++++++++++++
>  firmware/Makefile                                  |    1 +
>  .../keystone/qmss_pdsp_acc48_k2_le_1_0_0_8.fw.ihex |  110 ++
>  include/linux/soc/ti/knav_dma.h                    |  175 ++
>  include/linux/soc/ti/knav_qmss.h                   |   90 +
>  16 files changed, 4329 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/soc/keystone-navigator-dma.txt
>  create mode 100644 Documentation/devicetree/bindings/soc/keystone-navigator-qmss.txt
>  create mode 100644 drivers/soc/Kconfig
>  create mode 100644 drivers/soc/Makefile
>  create mode 100644 drivers/soc/ti/Kconfig
>  create mode 100644 drivers/soc/ti/Makefile
>  create mode 100644 drivers/soc/ti/knav_dma.c
>  create mode 100644 drivers/soc/ti/knav_qmss.h
>  create mode 100644 drivers/soc/ti/knav_qmss_acc.c
>  create mode 100644 drivers/soc/ti/knav_qmss_queue.c
>  create mode 100644 firmware/keystone/qmss_pdsp_acc48_k2_le_1_0_0_8.fw.ihex
>  create mode 100644 include/linux/soc/ti/knav_dma.h
>  create mode 100644 include/linux/soc/ti/knav_qmss.h
> 
> Regards,
> Santosh
> [1] https://lkml.org/lkml/2014/2/28/567
> [2] https://lkml.org/lkml/2014/3/18/340
> 

