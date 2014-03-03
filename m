Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaCCQlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:41:18 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52413 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaCCQlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:41:17 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 2/3] soc: keystone: add QMSS driver
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1393629520-12713-3-git-send-email-santosh.shilimkar@ti.com>
Date: Mon, 3 Mar 2014 10:41:10 -0600
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Sandeep Nair <sandeep_n@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1568CFCC-C778-4116-95F6-4EB407F096D6@codeaurora.org>
References: <1393629520-12713-1-git-send-email-santosh.shilimkar@ti.com> <1393629520-12713-3-git-send-email-santosh.shilimkar@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 28, 2014, at 5:18 PM, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:

> From: Sandeep Nair <sandeep_n@ti.com>
> 
> The QMSS (Queue Manager Sub System) found on Keystone SOCs is one of
> the main hardware sub system which forms the backbone of the Keystone
> Multi-core Navigator. QMSS consist of queue managers, packed-data structure
> processors(PDSP), linking RAM, descriptor pools and infrastructure
> Packet DMA.
> 
> The Queue Manager is a hardware module that is responsible for accelerating
> management of the packet queues. Packets are queued/de-queued by writing or
> reading descriptor address to a particular memory mapped location. The PDSPs
> perform QMSS related functions like accumulation, QoS, or event management.
> Linking RAM registers are used to link the descriptors which are stored in
> descriptor RAM. Descriptor RAM is configurable as internal or external memory.
> 
> The QMSS driver manages the PDSP setups, linking RAM regions,
> queue pool management (allocation, push, pop and notify) and descriptor
> pool management. The specifics on the device tree bindings for
> QMSS can be found in:
>        Documentation/devicetree/bindings/soc/keystone-qmss.txt
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
> .../devicetree/bindings/soc/keystone-qmss.txt      |  209 +++
> drivers/Kconfig                                    |    2 +
> drivers/Makefile                                   |    3 +
> drivers/soc/Kconfig                                |    2 +
> drivers/soc/Makefile                               |    5 +
> drivers/soc/keystone/Kconfig                       |   15 +
> drivers/soc/keystone/Makefile                      |    5 +
> drivers/soc/keystone/qmss_acc.c                    |  591 ++++++++
> drivers/soc/keystone/qmss_queue.c                  | 1533 ++++++++++++++++++++
> drivers/soc/keystone/qmss_queue.h                  |  236 +++

So this should be drivers/soc/ti, much like we use vendor in drivers/net/ethernet

> include/linux/soc/keystone_qmss.h                  |  390 +++++

include/linux/soc/ti/

> 11 files changed, 2991 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/soc/keystone-qmss.txt
> create mode 100644 drivers/soc/Makefile
> create mode 100644 drivers/soc/keystone/Kconfig
> create mode 100644 drivers/soc/keystone/Makefile
> create mode 100644 drivers/soc/keystone/qmss_acc.c
> create mode 100644 drivers/soc/keystone/qmss_queue.c
> create mode 100644 drivers/soc/keystone/qmss_queue.h
> create mode 100644 include/linux/soc/keystone_qmss.h

[snip]

> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 37f955f..3220516 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -146,6 +146,8 @@ source "drivers/remoteproc/Kconfig"
> 
> source "drivers/rpmsg/Kconfig"
> 
> +source "drivers/soc/Kconfig"
> +
> source "drivers/devfreq/Kconfig"
> 
> source "drivers/extcon/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 0d8e2a4..0c22db8 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -146,6 +146,9 @@ obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
> obj-$(CONFIG_REMOTEPROC)	+= remoteproc/
> obj-$(CONFIG_RPMSG)		+= rpmsg/
> 
> +# SOC specific drivers
> +obj-y				+= soc/
> +
> # Virtualization drivers
> obj-$(CONFIG_VIRT_DRIVERS)	+= virt/
> obj-$(CONFIG_HYPERV)		+= hv/
> diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
> index 2f9d7d0..59980bd 100644
> --- a/drivers/soc/Kconfig
> +++ b/drivers/soc/Kconfig
> @@ -1,3 +1,5 @@
> menu "SOC specific Drivers"
> 
> +source "drivers/soc/keystone/Kconfig"
> +
> endmenu
> diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
> new file mode 100644
> index 0000000..c5d141e
> --- /dev/null
> +++ b/drivers/soc/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for the Linux kernel SOC specific device drivers.
> +#
> +
> +obj-$(CONFIG_ARCH_KEYSTONE)		+= keystone/
> diff --git a/drivers/soc/keystone/Kconfig b/drivers/soc/keystone/Kconfig
> new file mode 100644
> index 0000000..0b3131b
> --- /dev/null
> +++ b/drivers/soc/keystone/Kconfig
> @@ -0,0 +1,15 @@
> +#
> +# TI Keystone Soc drivers
> +#
> +

We should have this be something like:

menuconfig SOC_TI
	bool “TI SoC support”
	

if SOC_TI

> +config KEYSTONE_QMSS
> +	tristate "Keystone Queue Manager Sub System"
> +	depends on ARCH_KEYSTONE
> +	help
> +	  Say y here to support the Keystone Hardware Queue Manager support.
> +	  The Queue Manager is a hardware module that is responsible for
> +	  accelerating management of the packet queues. Packets are queued/
> +	  de-queued by writing/reading descriptor address to a particular
> +	  memory mapped location in the Queue Manager module.
> +
> +	  If unsure, say N.

endif # SOC_TI

[snip]

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

