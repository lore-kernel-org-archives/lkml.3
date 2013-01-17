Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab3AQJj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:39:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37688 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081Ab3AQJjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:39:54 -0500
Message-ID: <50F7C6C7.3030400@ti.com>
Date: Thu, 17 Jan 2013 11:39:19 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <balbi@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <horms@verge.net.au>,
        <magnus.damm@gmail.com>, <cbou@mail.ru>, <dwmw2@infradead.org>,
        <alexander.shishkin@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <leoli@freescale.com>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>, <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 2/6] ARM: OMAP: USB: Add phy binding information
References: <1358348462-27693-1-git-send-email-kishon@ti.com> <1358348462-27693-3-git-send-email-kishon@ti.com>
In-Reply-To: <1358348462-27693-3-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 05:00 PM, Kishon Vijay Abraham I wrote:
> This is in preparation for the changes in PHY library to support adding
> and getting multiple PHYs of the same type. In the new design, the
> binding information between the PHY and the USB controller should be
> specified in the platform specific initialization code. So it's been
> done for OMAP platforms here.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
> This kind-of binding should be done in all the platforms (I've done only
> for OMAP platform). 
>  arch/arm/mach-omap2/usb-musb.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
> index 9d27e3f..bbe2fa5 100644
> --- a/arch/arm/mach-omap2/usb-musb.c
> +++ b/arch/arm/mach-omap2/usb-musb.c
> @@ -24,6 +24,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/io.h>
>  #include <linux/usb/musb.h>
> +#include <linux/usb/phy.h>
>  
>  #include "omap_device.h"
>  #include "soc.h"
> @@ -85,8 +86,12 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
>  	musb_plat.mode = board_data->mode;
>  	musb_plat.extvbus = board_data->extvbus;
>  
> -	if (cpu_is_omap44xx())
> +	if (cpu_is_omap44xx()) {
>  		musb_plat.has_mailbox = true;
> +		usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto");
> +	} else if (cpu_is_omap34xx()) {
> +		usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> +	}

Are you sure than these OMAP platforms cannot be wired in any other way
to the PHY?

If they can be then this association must come from the board files or
device tree.

>  
>  	if (soc_is_am35xx()) {
>  		oh_name = "am35x_otg_hs";
> 

--
cheers,
-roger
