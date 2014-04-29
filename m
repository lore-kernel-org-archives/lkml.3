Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbaD2IQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:16:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:32996 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336AbaD2IQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:16:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,949,1389772800"; 
   d="scan'208";a="530308843"
Date: Tue, 29 Apr 2014 11:16:09 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, rjw@rjwysocki.net, awilliam@redhat.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 9/9] I2C/ACPI: Add CONFIG_I2C_ACPI config
Message-ID: <20140429081609.GF1684@lahna.fi.intel.com>
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398695268-28645-1-git-send-email-tianyu.lan@intel.com>
 <1398695268-28645-10-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398695268-28645-10-git-send-email-tianyu.lan@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 10:27:48PM +0800, Lan Tianyu wrote:
> This patch is to add CONFIG_I2C_ACPI. Current there is a race between
> removing I2C ACPI operation region and ACPI AML code accessing.
> So make i2c core built-in if CONFIG_I2C_ACPI is set.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/i2c/Kconfig  | 17 ++++++++++++++++-
>  drivers/i2c/Makefile |  2 +-
>  include/linux/i2c.h  |  2 +-
>  3 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
> index 7b7ea32..c670d49 100644
> --- a/drivers/i2c/Kconfig
> +++ b/drivers/i2c/Kconfig
> @@ -2,7 +2,9 @@
>  # I2C subsystem configuration
>  #
>  
> -menuconfig I2C
> +menu "I2C support"
> +
> +config I2C
>  	tristate "I2C support"
>  	select RT_MUTEXES
>  	---help---
> @@ -21,6 +23,17 @@ menuconfig I2C
>  	  This I2C support can also be built as a module.  If so, the module
>  	  will be called i2c-core.
>  
> +config I2C_ACPI
> +	bool "I2C ACPI support"
> +	select I2C
> +	depends on ACPI
> +	default y
> +	help
> +	  Say Y here if you want to enable I2C ACPI function. ACPI table
> +	  provides I2C slave devices' information to enumerate these devices.
> +	  This option also allows ACPI AML code to access I2C slave devices
> +	  via I2C ACPI operation region to fulfill ACPI method.

I would prefer something like:

Say Y here if you want to enable ACPI I2C support. This includes support
for automatic enumeration of I2C slave devices and support for ACPI I2C
Operation Regions. Operation Regions allow firmware (BIOS) code to
access I2C slave devices, such as smart batteries through an I2C host
controller driver.

But it is really up to you so,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
