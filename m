Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3HTHWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:22:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:7093 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab3HTHWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:22:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,918,1367996400"; 
   d="scan'208";a="365344749"
Date: Tue, 20 Aug 2013 10:28:20 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jerry Snitselaar <jerry.snitselaar@oracle.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] acpi_i2c: set MODULE_LICENSE, MODULE_AUTHOR, and
 MODULE_DESCRIPTION
Message-ID: <20130820072820.GT4898@intel.com>
References: <1376702795-25912-1-git-send-email-jerry.snitselaar@oracle.com>
 <2870377.GVGv4QBgQK@vostro.rjw.lan>
 <20130819233528.GA4587@cantor.us.oracle.com>
 <1838503.PYpZe7GJ51@vostro.rjw.lan>
 <20130820033403.GD4587@cantor.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820033403.GD4587@cantor.us.oracle.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 08:34:03PM -0700, Jerry Snitselaar wrote:
> On Tue Aug 20 13, Rafael J. Wysocki wrote:
> > On Monday, August 19, 2013 04:35:29 PM Jerry Snitselaar wrote:
> > > On Tue Aug 20 13, Rafael J. Wysocki wrote:
> > > > On Monday, August 19, 2013 09:16:14 AM Mika Westerberg wrote:
> > > > > On Fri, Aug 16, 2013 at 06:26:35PM -0700, Jerry Snitselaar wrote:
> > > > > > Without MODULE_LICENSE set, I get the following with modprobe:
> > > > > > 
> > > > > > acpi_i2c: module license 'unspecified' taints kernel.
> > > > > > acpi_i2c: Unknown symbol i2c_new_device (err 0)
> > > > > > acpi_i2c: Unknown symbol acpi_dev_get_resources (err 0)
> > > > > > acpi_i2c: Unknown symbol acpi_dev_resource_interrupt (err 0)
> > > > > > acpi_i2c: Unknown symbol acpi_dev_free_resource_list (err 0)
> > > > > > 
> > > > > > Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
> > > > > 
> > > > > Looks good to me.
> > > > > 
> > > > > Acked-by: Mika Westerbeg <mika.westerberg@linux.intel.com>
> > > > 
> > > > Well, OK, but do we need to be able to build that as a module?
> > > > 
> > > > Maybe it should just be yes or no?
> > > > 
> > > > Rafael
> > > > 
> > > 
> > > Perhaps have depends on I2C=y and be a bool instead of tristate?
> > 
> > Yes, that's the idea.
> > 
> Does this look okay Mika?
> 
> [PATCH] acpi_i2c: do not build as loadable module
> 
> Change from tristate to bool, and depend on I2C=y

I'm not sure about this. Does the below mean that we can't build the ACPI
I2C enumeration at all if I2C core is compiled as module?

> 
> Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
> ---
>  drivers/acpi/Kconfig | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 100bd72..183a309 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -181,8 +181,9 @@ config ACPI_DOCK
>           drive bays such as the IBM Ultrabay and the Dell Module Bay.
>  
>  config ACPI_I2C
> -       def_tristate I2C
> -       depends on I2C
> +       bool "I2C"
> +       depends on I2C=y
> +       default n
>         help
>           ACPI I2C enumeration support.
>  
> -- 
> 1.8.4.rc3.2.g2c2b664
