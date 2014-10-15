Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaJOV5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 17:57:24 -0400
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:38841 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbaJOV5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 17:57:07 -0400
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <543EEDAC.7050800@mev.co.uk>
Date: Wed, 15 Oct 2014 22:57:00 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
CC: trivial@kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: ii_pci20kc: add CONFIG_HAS_IOMEM dependence
References: <1413408339-12816-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1413408339-12816-1-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/14 22:25, David Cohen wrote:
> ii_pci20kc uses io memory which makes it not compilable on architectures
> without HAS_IOMEM such as UML:
>
>    CC      drivers/net/wireless/ti/wl1251/main.o
> drivers/staging/comedi/drivers/ii_pci20kc.c: In function ‘ii20k_attach’:
> drivers/staging/comedi/drivers/ii_pci20kc.c:442:2: error: implicit
> declaration of function ‘ioremap’
> [-Werror=implicit-function-declaration]
>    dev->mmio = ioremap(membase, II20K_SIZE);
>    ^
> drivers/staging/comedi/drivers/ii_pci20kc.c:442:12: warning: assignment
> makes pointer from integer without a cast
>    dev->mmio = ioremap(membase, II20K_SIZE);
>              ^
> drivers/staging/comedi/drivers/ii_pci20kc.c: In function ‘ii20k_detach’:
> drivers/staging/comedi/drivers/ii_pci20kc.c:512:3: error: implicit
> declaration of function ‘iounmap’
> [-Werror=implicit-function-declaration]
>     iounmap(dev->mmio);
>     ^
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>   drivers/staging/comedi/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
> index a8bc2b567789..56be2112c731 100644
> --- a/drivers/staging/comedi/Kconfig
> +++ b/drivers/staging/comedi/Kconfig
> @@ -425,6 +425,7 @@ config COMEDI_AIO_IIRO_16
>   	  called aio_iiro_16.
>
>   config COMEDI_II_PCI20KC
> +	depends on HAS_IOMEM
>   	tristate "Intelligent Instruments PCI-20001C carrier support"
>   	---help---
>   	  Enable support for Intelligent Instruments PCI-20001C carrier
>

The same fix was already submitted by Chen Gang:

https://lkml.org/lkml/2014/10/2/318

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
