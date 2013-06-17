Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3FQXQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:16:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3FQXQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:16:07 -0400
Date: Mon, 17 Jun 2013 16:16:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/8] FMC: add core bus driver
Message-ID: <20130617231606.GB12984@kroah.com>
References: <cover.1371018406.git.rubini@gnudd.com>
 <3e9f6b2fb7cd202da9bbb6371b27ff302ca8b860.1371018406.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e9f6b2fb7cd202da9bbb6371b27ff302ca8b860.1371018406.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 09:13:47AM +0200, Alessandro Rubini wrote:
> --- a/drivers/fmc/fmc-core.c
> +++ b/drivers/fmc/fmc-core.c
> @@ -1,13 +1,285 @@
> -/* Temporary placeholder so the empty code can build */
> +/*
> + * Copyright (C) 2012 CERN (www.cern.ch)
> + * Author: Alessandro Rubini <rubini@gnudd.com>
> + *
> + * Released according to the GNU GPL, version 2 or any later version.

I have to ask, do you really mean "or any later version"?

> +int fmc_driver_register(struct fmc_driver *drv)
> +{
> +	if (fmc_check_version(drv->version, drv->driver.name))
> +		return -EINVAL;
> +	drv->driver.bus = &fmc_bus_type;
> +	return driver_register(&drv->driver);
> +}
> +EXPORT_SYMBOL(fmc_driver_register);
> +
> +void fmc_driver_unregister(struct fmc_driver *drv)
> +{
> +	driver_unregister(&drv->driver);
> +}
> +EXPORT_SYMBOL(fmc_driver_unregister);

Any specific reason these aren't EXPORT_SYMBOL_GPL()?

Again, just have to ask.

thanks,

greg k-h
