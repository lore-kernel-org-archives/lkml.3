Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaCYHR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 03:17:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:33705 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaCYHRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 03:17:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,726,1389772800"; 
   d="scan'208";a="506051736"
Date: Tue, 25 Mar 2014 09:25:30 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [bisected] NULL pointer dereference in acpi_gpiochip_add (on
 modprobe ssb)
Message-ID: <20140325072530.GP19349@intel.com>
References: <20140324154944.GB25669@kria>
 <20140324180033.GM19349@intel.com>
 <20140324181112.GN19349@intel.com>
 <20140324183111.GC25669@kria>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140324183111.GC25669@kria>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 07:31:11PM +0100, Sabrina Dubroca wrote:
> > Actually gpiolib seems to handle ->dev as optional. Can you try this patch
> > instead? Thanks.
> > 
> > diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> > index bf0f8b476696..642b2bf3360e 100644
> > --- a/drivers/gpio/gpiolib-acpi.c
> > +++ b/drivers/gpio/gpiolib-acpi.c
> > @@ -501,6 +501,9 @@ void acpi_gpiochip_add(struct gpio_chip *chip)
> >  	acpi_handle handle;
> >  	acpi_status status;
> >  
> > +	if (!chip || !chip->dev)
> > +		return;
> > +
> >  	handle = ACPI_HANDLE(chip->dev);
> >  	if (!handle)
> >  		return;
> > @@ -531,6 +534,9 @@ void acpi_gpiochip_remove(struct gpio_chip *chip)
> >  	acpi_handle handle;
> >  	acpi_status status;
> >  
> > +	if (!chip || !chip->dev)
> > +		return;
> > +
> >  	handle = ACPI_HANDLE(chip->dev);
> >  	if (!handle)
> >  		return;
> 
> Thanks, this patch solves the problem.

Great thanks for testing. Can I add your tested-by to the patch?

I'll submit a formal patch for this next week as I'm currently on vacation.
