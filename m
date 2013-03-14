Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3CNUXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:23:54 -0400
Received: from kiruna.synopsys.com ([198.182.44.80]:43454 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3CNUXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:23:52 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build failure after merge of the final tree
 (staging tree related)
Thread-Topic: linux-next: build failure after merge of the final tree
 (staging tree related)
Thread-Index: AQHOH60rGdLqbw7L2kaHJYPoFithBpilopag
Date: Thu, 14 Mar 2013 20:23:39 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458D8ED91@US01WEMBX2.internal.synopsys.com>
References: <20130313163935.ea2f414d3ccc6ed1434d92b8@canb.auug.org.au>
In-Reply-To: <20130313163935.ea2f414d3ccc6ed1434d92b8@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Tuesday, March 12, 2013 10:40 PM
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/staging/dwc2/hcd.c: In function '_dwc2_hcd_urb_enqueue':
> drivers/staging/dwc2/hcd.c:2387:3: error: implicit declaration of function 'bus_to_virt' [-Werror=implicit-function-declaration]
> drivers/staging/dwc2/hcd.c:2387:7: warning: assignment makes pointer from integer without a cast [enabled by default]
> 
> Caused by commit 7359d482eb4d ("staging: HCD files for the DWC2 driver").
> 
> From Documentation/bus-virt-phys-mapping.txt:
> 
> "[ NOTE: The virt_to_bus() and bus_to_virt() functions have been
>         superseded by the functionality provided by the PCI DMA interface
>         (see Documentation/DMA-API-HOWTO.txt).  They continue
>         to be documented below for historical purposes, but new code
>         must not use them. --davidm 00/12/12 ]"
> 
> See also Documentation/DMA-API-HOWTO.txt.
> 
> I have added this patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 13 Mar 2013 16:35:50 +1100
> Subject: [PATCH] staging: the DWC2 driver uses bus_to_virt
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/staging/dwc2/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/dwc2/Kconfig b/drivers/staging/dwc2/Kconfig
> index 610418a..bc4cdfe 100644
> --- a/drivers/staging/dwc2/Kconfig
> +++ b/drivers/staging/dwc2/Kconfig
> @@ -1,6 +1,7 @@
>  config USB_DWC2
>  	tristate "DesignWare USB2 DRD Core Support"
>  	depends on USB
> +	depends on VIRT_TO_BUS
>  	select USB_OTG_UTILS
>  	help
>  	  Say Y or M here if your system has a Dual Role HighSpeed
> --

Hi Greg,

Do you apply these sort of patches automatically, or do you need an ack from me?
In case you do:

Acked-by: Paul Zimmerman <paulz@synopsys.com>

