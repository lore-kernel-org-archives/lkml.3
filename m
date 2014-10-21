Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaJUMs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:48:27 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58462 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755274AbaJUMsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:48:25 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [resend PATCH 1/3] ACPI / platform: provide default DMA mask
Date: Tue, 21 Oct 2014 15:08:44 +0200
Message-ID: <1885056.A9IZAntn96@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54465141.1080408@intel.com>
References: <1411545639-18741-1-git-send-email-heikki.krogerus@linux.intel.com> <2261149.pJ2DW810R9@vostro.rjw.lan> <54465141.1080408@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 21, 2014 03:27:45 PM Adrian Hunter wrote:
> On 24/09/14 16:49, Rafael J. Wysocki wrote:
> > On Wednesday, September 24, 2014 11:00:37 AM Heikki Krogerus wrote:
> >> Most devices are configured for 32-bit DMA addresses.
> >> Setting the mask to 32-bit here removes the need for the
> >> drivers to do it separately.
> >>
> >> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> >> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > 
> > ACK
> 
> Hi
> 
> I need this for another driver.  Did this patch go anywhere?

It's not in 3.18-rc1 as far as I can say.

> Note Heikki is away at the moment.

That's OK.  I guess I can queue up this one for you.

When do you need this to get into the Linus' tree?


> >> ---
> >>  drivers/acpi/acpi_platform.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
> >> index 2bf9082..8d099e6 100644
> >> --- a/drivers/acpi/acpi_platform.c
> >> +++ b/drivers/acpi/acpi_platform.c
> >> @@ -16,6 +16,7 @@
> >>  #include <linux/err.h>
> >>  #include <linux/kernel.h>
> >>  #include <linux/module.h>
> >> +#include <linux/dma-mapping.h>
> >>  #include <linux/platform_device.h>
> >>  
> >>  #include "internal.h"
> >> @@ -102,6 +103,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
> >>  	pdevinfo.res = resources;
> >>  	pdevinfo.num_res = count;
> >>  	pdevinfo.acpi_node.companion = adev;
> >> +	pdevinfo.dma_mask = DMA_BIT_MASK(32);
> >>  	pdev = platform_device_register_full(&pdevinfo);
> >>  	if (IS_ERR(pdev))
> >>  		dev_err(&adev->dev, "platform device creation failed: %ld\n",
> >>
> > 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
