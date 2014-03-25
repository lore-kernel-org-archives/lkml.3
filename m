Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaCYIFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:05:39 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:59717 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaCYIFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:05:36 -0400
Date: Tue, 25 Mar 2014 09:05:23 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-gpio@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [bisected] NULL pointer dereference in acpi_gpiochip_add (on
 modprobe ssb)
Message-ID: <20140325080523.GD25669@kria>
References: <20140324154944.GB25669@kria>
 <20140324180033.GM19349@intel.com>
 <20140324181112.GN19349@intel.com>
 <20140324183111.GC25669@kria>
 <20140325072530.GP19349@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140325072530.GP19349@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-25, 09:25:30 +0200, Mika Westerberg wrote:
> On Mon, Mar 24, 2014 at 07:31:11PM +0100, Sabrina Dubroca wrote:
> > > Actually gpiolib seems to handle ->dev as optional. Can you try this patch
> > > instead? Thanks.
> > > 
> > > diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> > > index bf0f8b476696..642b2bf3360e 100644
> > > --- a/drivers/gpio/gpiolib-acpi.c
> > > +++ b/drivers/gpio/gpiolib-acpi.c
> > > @@ -501,6 +501,9 @@ void acpi_gpiochip_add(struct gpio_chip *chip)
> > >  	acpi_handle handle;
> > >  	acpi_status status;
> > >  
> > > +	if (!chip || !chip->dev)
> > > +		return;
> > > +
> > >  	handle = ACPI_HANDLE(chip->dev);
> > >  	if (!handle)
> > >  		return;
> > > @@ -531,6 +534,9 @@ void acpi_gpiochip_remove(struct gpio_chip *chip)
> > >  	acpi_handle handle;
> > >  	acpi_status status;
> > >  
> > > +	if (!chip || !chip->dev)
> > > +		return;
> > > +
> > >  	handle = ACPI_HANDLE(chip->dev);
> > >  	if (!handle)
> > >  		return;
> > 
> > Thanks, this patch solves the problem.
> 
> Great thanks for testing. Can I add your tested-by to the patch?
> 
> I'll submit a formal patch for this next week as I'm currently on vacation.

Sure:

Tested-by: Sabrina Dubroca <sd@queasysnail.net>


Thanks again,

-- 
Sabrina
