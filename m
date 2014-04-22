Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbaDVLhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:37:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:24150 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbaDVLhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:37:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,903,1389772800"; 
   d="scan'208";a="517192786"
Date: Tue, 22 Apr 2014 14:45:10 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, rjw@rjwysocki.net, awilliam@redhat.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Resend Patch 9/9] I2C/ACPI: Add CONFIG_I2C_ACPI config
Message-ID: <20140422114510.GM30677@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-10-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398147855-9868-10-git-send-email-tianyu.lan@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 02:24:15PM +0800, Lan Tianyu wrote:
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
> +

I'm wondering, can we provide some sort of wrapper function from ACPI core
that is guaranteed to be built in to the kernel image and use it instead of
adding new Kconfig options?
