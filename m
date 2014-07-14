Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaGNIHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:07:34 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:55618 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbaGNIH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:07:26 -0400
Message-ID: <1405325243.8281.7.camel@x220>
Subject: Re: [PATCH char-misc-next v3 3/8] dma: MIC X100 DMA Driver
From: Paul Bolle <pebolle@tiscali.nl>
To: Siva Yerramreddy <yshivakrishna@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Date: Mon, 14 Jul 2014 10:07:23 +0200
In-Reply-To: <5ece7b7320491521bbfc167517a50d2620ccc276.1405109402.git.sudeep.dutt@intel.com>
References: <cover.1405109401.git.sudeep.dutt@intel.com>
	 <5ece7b7320491521bbfc167517a50d2620ccc276.1405109402.git.sudeep.dutt@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2014 08:07:24.0133 (UTC) FILETIME=[A4F2D150:01CF9F3A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 14:04 -0700, Sudeep Dutt wrote:
> From: Siva Yerramreddy <yshivakrishna@gmail.com>
> 
> This patch implements DMA Engine API for DMA controller on MIC X100
> Coprocessors. DMA h/w is shared between host and card s/w.
> Channels 0 to 3 are used by host and 4 to 7 are used by card.
> Since the DMA device doesn't show up as PCIe device, a virtual bus called mic
> bus is created and virtual devices are added on that bus to follow device model.
> Allowed dma transfer directions are host to card, card to host and card to card.
> 
> Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
> Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
> Signed-off-by: Siva Yerramreddy <yshivakrishna@gmail.com>
> ---
>  drivers/dma/Kconfig        |  19 ++
>  drivers/dma/Makefile       |   1 +
>  drivers/dma/mic_x100_dma.c | 774 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/dma/mic_x100_dma.h | 286 +++++++++++++++++
>  4 files changed, 1080 insertions(+)
>  create mode 100644 drivers/dma/mic_x100_dma.c
>  create mode 100644 drivers/dma/mic_x100_dma.h

This patch was first included in linux-next in next-20140714.

> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 1eca7b9..7c8b8c4 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -33,6 +33,25 @@ if DMADEVICES
>  
>  comment "DMA Devices"
>  
> +config INTEL_MIC_X100_DMA
> +	tristate "Intel MIC X100 DMA Driver"
> +	depends on 64BIT && X86 && INTEL_MIC_BUS
> +	select DMAENGINE

You probably meant
         select DMA_ENGINE

> +	default N

That should have been "default n". As (lowercase) "n" is the default
anyhow, that line might as well be dropped.

> +	help
> +	  This enables DMA support for the Intel Many Integrated Core
> +	  (MIC) family of PCIe form factor coprocessor X100 devices that
> +	  run a 64 bit Linux OS. This driver will be used by both MIC
> +	  host and card drivers.
> +
> +	  If you are building host kernel with a MIC device or a card
> +	  kernel for a MIC device, then say M (recommended) or Y, else
> +	  say N. If unsure say N.
> +
> +	  More information about the Intel MIC family as well as the Linux
> +	  OS and tools for MIC to use with this driver are available from
> +	  <http://software.intel.com/en-us/mic-developer>.
> +
>  config INTEL_MID_DMAC
>  	tristate "Intel MID DMA support for Peripheral DMA controllers"
>  	depends on PCI && X86

Should I submit the trivial, but untested, patch to fix this or do you
prefer to do that yourself?


Paul Bolle

