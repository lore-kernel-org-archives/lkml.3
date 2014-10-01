Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaJAQ2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:28:09 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47126 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaJAQ2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:28:06 -0400
Date: Wed, 1 Oct 2014 09:28:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 13/15] input: gpio_keys_polled - Add ACPI probing
 support
Message-ID: <20141001162802.GD23115@dtor-glaptop>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1852462.V1jlbi8OPt@vostro.rjw.lan>
 <17237242.r7oKCjnQJM@vostro.rjw.lan>
 <20141001074846.GA17700@dtor-glaptop>
 <20141001091535.GZ1786@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001091535.GZ1786@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 12:15:35PM +0300, Mika Westerberg wrote:
> On Wed, Oct 01, 2014 at 12:48:46AM -0700, Dmitry Torokhov wrote:
> > On Wed, Oct 01, 2014 at 04:20:43AM +0200, Rafael J. Wysocki wrote:
> > > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > 
> > > Allow the driver to probe from ACPI namespace.
> > > 
> > > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  drivers/input/keyboard/gpio_keys_polled.c |    7 +++++++
> > >  1 file changed, 7 insertions(+)
> > > 
> > > Index: linux-pm/drivers/input/keyboard/gpio_keys_polled.c
> > > ===================================================================
> > > --- linux-pm.orig/drivers/input/keyboard/gpio_keys_polled.c
> > > +++ linux-pm/drivers/input/keyboard/gpio_keys_polled.c
> > > @@ -181,6 +181,12 @@ static const struct of_device_id gpio_ke
> > >  };
> > >  MODULE_DEVICE_TABLE(of, gpio_keys_polled_of_match);
> > >  
> > > +static const struct acpi_device_id gpio_keys_polled_acpi_match[] = {
> > > +	{ "PRP0001" }, /* Device Tree shoehorned into ACPI */
> > > +	{ },
> > > +};
> > > +MODULE_DEVICE_TABLE(acpi, gpio_keys_polled_acpi_match);
> > > +
> > >  static int gpio_keys_polled_probe(struct platform_device *pdev)
> > >  {
> > >  	struct device *dev = &pdev->dev;
> > > @@ -309,6 +315,7 @@ static struct platform_driver gpio_keys_
> > >  		.name	= DRV_NAME,
> > >  		.owner	= THIS_MODULE,
> > >  		.of_match_table = gpio_keys_polled_of_match,
> > > +		.acpi_match_table = gpio_keys_polled_acpi_match,
> > o
> > Hmm, why do we need the generic "PRP0001" in every driver? The ACPI device
> > should have PRP0001 and ACPI bus should know to look into OF matching table
> > for such devices.
> 
> Arnd had a good idea for this. How about,
> 
> 	.acpi_match_table = acpi_match_by_of_compatible,
> 
> where acpi_match_by_of_compatible is provided by ACPI core? Does that
> work better for you?

I still do not see the point. ACPI core knows how to handle
drv->of_match_table, so unless we need to support ACPI_only binding in a
given driver I do not understand why we need to add boilerplate code.

Thanks.

-- 
Dmitry
