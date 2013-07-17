Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3GQG3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 02:29:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3GQG3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 02:29:41 -0400
Date: Tue, 16 Jul 2013 23:29:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@linaro.org, tony@atomide.com, balbi@ti.com, arnd@arndb.de,
        swarren@nvidia.com, sylvester.nawrocki@gmail.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        akpm@linux-foundation.org, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, benoit.cousson@linaro.org, mchehab@redhat.com,
        cesarb@cesarb.net, davem@davemloft.net, rnayak@ti.com,
        shawn.guo@linaro.org, santosh.shilimkar@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        nsekhar@ti.com, balajitk@ti.com, george.cherian@ti.com
Subject: Re: [PATCH v9 1/8] drivers: phy: add generic PHY framework
Message-ID: <20130717062944.GA24968@kroah.com>
References: <1372247257-30186-1-git-send-email-kishon@ti.com>
 <1372247257-30186-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372247257-30186-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 05:17:29PM +0530, Kishon Vijay Abraham I wrote:
> +menuconfig GENERIC_PHY
> +	tristate "PHY Subsystem"
> +	help
> +	  Generic PHY support.
> +
> +	  This framework is designed to provide a generic interface for PHY
> +	  devices present in the kernel. This layer will have the generic
> +	  API by which phy drivers can create PHY using the phy framework and
> +	  phy users can obtain reference to the PHY.

Shouldn't this be something that other drivers select?  How will anyone
know if they need this or not?

> --- /dev/null
> +++ b/drivers/phy/phy-core.c
> @@ -0,0 +1,544 @@
> +/*
> + * phy-core.c  --  Generic Phy framework.
> + *
> + * Copyright (C) 2013 Texas Instruments
> + *
> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.

You really mean "any later version" (I have to ask)?

> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.

Are these two paragraphs needed?  This isn't a "program", and they got a
copy of the GPL already with the kernel.

> +static struct class *phy_class;

Why do you need a class?

When modifying/adding new sysfs stuff, you need a Documentation/ABI/
entry as well.

thanks,

greg k-h
