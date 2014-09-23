Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbaIWOcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:32:17 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62019 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751755AbaIWOcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:32:16 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Felipe Balbi <balbi@ti.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/4] ACPI / platform: provide default DMA mask
Date: Tue, 23 Sep 2014 16:52:01 +0200
Message-ID: <1487657.QLes1WRKBI@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140923121712.GD18814@xps8300>
References: <1408535728-10518-1-git-send-email-heikki.krogerus@linux.intel.com> <1408535728-10518-3-git-send-email-heikki.krogerus@linux.intel.com> <20140923121712.GD18814@xps8300>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 23, 2014 03:17:12 PM Heikki Krogerus wrote:
> On Wed, Aug 20, 2014 at 02:55:26PM +0300, Heikki Krogerus wrote:
> > Most devices are configured for 32-bit DMA addresses.
> > Setting the mask to 32-bit here removes the need for the
> > drivers to do it separately.
> 
> Rafael, is this OK?

Fine by me, but it should go in via dwc3 I think.

> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > ---
> >  drivers/acpi/acpi_platform.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
> > index 2bf9082..8d099e6 100644
> > --- a/drivers/acpi/acpi_platform.c
> > +++ b/drivers/acpi/acpi_platform.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/err.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > +#include <linux/dma-mapping.h>
> >  #include <linux/platform_device.h>
> >  
> >  #include "internal.h"
> > @@ -102,6 +103,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
> >  	pdevinfo.res = resources;
> >  	pdevinfo.num_res = count;
> >  	pdevinfo.acpi_node.companion = adev;
> > +	pdevinfo.dma_mask = DMA_BIT_MASK(32);
> >  	pdev = platform_device_register_full(&pdevinfo);
> >  	if (IS_ERR(pdev))
> >  		dev_err(&adev->dev, "platform device creation failed: %ld\n",
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
