Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab3AaHXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 02:23:51 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:44012 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3AaHXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 02:23:48 -0500
Date: Thu, 31 Jan 2013 08:23:32 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>
Subject: Re: [PATCH v2] i2c-i801: SMBus patch for Intel Avoton DeviceIDs
Message-ID: <20130131082332.1f3235c6@endymion.delvare>
In-Reply-To: <1359595532-5365-1-git-send-email-seth.heasley@intel.com>
References: <1359595532-5365-1-git-send-email-seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 17:25:32 -0800, Seth Heasley wrote:
> This patch adds the PCU SMBus DeviceID for the Intel Avoton SOC.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> ---
> Change notes for v2:
> * corrected order of DeviceID defines
> 
>  Documentation/i2c/busses/i2c-i801 |    1 +
>  drivers/i2c/busses/Kconfig        |    1 +
>  drivers/i2c/busses/i2c-i801.c     |    3 +++
>  3 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
> index 157416e..8d71d57 100644
> --- a/Documentation/i2c/busses/i2c-i801
> +++ b/Documentation/i2c/busses/i2c-i801
> @@ -22,6 +22,7 @@ Supported adapters:
>    * Intel Panther Point (PCH)
>    * Intel Lynx Point (PCH)
>    * Intel Lynx Point-LP (PCH)
> +  * Intel Avoton (SOC)
>     Datasheets: Publicly available at the Intel website
>  
>  On Intel Patsburg and later chipsets, both the normal host SMBus controller
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index bdca511..77d2887 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -106,6 +106,7 @@ config I2C_I801
>  	    Panther Point (PCH)
>  	    Lynx Point (PCH)
>  	    Lynx Point-LP (PCH)
> +	    Avoton (SOC)
>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called i2c-i801.
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index 3092387..b00c29d 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -53,6 +53,7 @@
>    Panther Point (PCH)   0x1e22     32     hard     yes     yes     yes
>    Lynx Point (PCH)      0x8c22     32     hard     yes     yes     yes
>    Lynx Point-LP (PCH)   0x9c22     32     hard     yes     yes     yes
> +  Avoton (SOC)          0x1f3c     32     hard     yes     yes     yes
>  
>    Features supported by this driver:
>    Software PEC                     no
> @@ -162,6 +163,7 @@
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF1	0x1d71
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF2	0x1d72
>  #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS	0x1e22
> +#define PCI_DEVICE_ID_INTEL_AVOTON_SMBUS	0x1f3c
>  #define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
>  #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
>  #define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
> @@ -798,6 +800,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_AVOTON_SMBUS) },
>  	{ 0, }
>  };
>  

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
