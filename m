Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbaDHI1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:27:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51710 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbaDHI1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:27:19 -0400
Message-ID: <5343B2E0.4060001@ti.com>
Date: Tue, 8 Apr 2014 11:27:12 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>, Kishon Vijay Abraham I <kishon@ti.com>
CC: LKML <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] phy: restore OMAP_CONTROL_PHY dependencies
References: <20140408102036.2de12394@endymion.delvare>
In-Reply-To: <20140408102036.2de12394@endymion.delvare>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 11:20 AM, Jean Delvare wrote:
> When OMAP_CONTROL_USB was renamed to OMAP_CONTROL_PHY (commit
> 14da699b), its dependencies were lost in the process. Nothing in the
> commit message indicates that this removal was intentional, so I think
> it was by accident and the dependencies should be restored.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Roger Quadros <rogerq@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>

Acked-by: Roger Quadros <rogerq@ti.com>

cheers,
-roger

> ---
>  drivers/phy/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-3.15-rc0.orig/drivers/phy/Kconfig	2014-04-07 10:23:06.031199592 +0200
> +++ linux-3.15-rc0/drivers/phy/Kconfig	2014-04-08 10:12:16.448317340 +0200
> @@ -33,6 +33,7 @@ config PHY_MVEBU_SATA
>  
>  config OMAP_CONTROL_PHY
>  	tristate "OMAP CONTROL PHY Driver"
> +	depends on ARCH_OMAP2PLUS || COMPILE_TEST
>  	help
>  	  Enable this to add support for the PHY part present in the control
>  	  module. This driver has API to power on the USB2 PHY and to write to
> 
> 

