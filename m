Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbaIWMRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:17:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:56067 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbaIWMRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:17:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,579,1406617200"; 
   d="scan'208";a="595544977"
Date: Tue, 23 Sep 2014 15:17:12 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/4] ACPI / platform: provide default DMA mask
Message-ID: <20140923121712.GD18814@xps8300>
References: <1408535728-10518-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1408535728-10518-3-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408535728-10518-3-git-send-email-heikki.krogerus@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 02:55:26PM +0300, Heikki Krogerus wrote:
> Most devices are configured for 32-bit DMA addresses.
> Setting the mask to 32-bit here removes the need for the
> drivers to do it separately.

Rafael, is this OK?

> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>  drivers/acpi/acpi_platform.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
> index 2bf9082..8d099e6 100644
> --- a/drivers/acpi/acpi_platform.c
> +++ b/drivers/acpi/acpi_platform.c
> @@ -16,6 +16,7 @@
>  #include <linux/err.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/dma-mapping.h>
>  #include <linux/platform_device.h>
>  
>  #include "internal.h"
> @@ -102,6 +103,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
>  	pdevinfo.res = resources;
>  	pdevinfo.num_res = count;
>  	pdevinfo.acpi_node.companion = adev;
> +	pdevinfo.dma_mask = DMA_BIT_MASK(32);
>  	pdev = platform_device_register_full(&pdevinfo);
>  	if (IS_ERR(pdev))
>  		dev_err(&adev->dev, "platform device creation failed: %ld\n",
> -- 
> 2.1.0

-- 
heikki
