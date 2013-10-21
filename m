Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab3JUGsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 02:48:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:39926 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab3JUGsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 02:48:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="377545759"
Date: Mon, 21 Oct 2013 09:53:42 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Benson Leung <bleung@chromium.org>
Cc: wsa@the-dreams.de, khali@linux-fr.org, andriy.shevchenko@linux.intel.com,
        jacmet@sunsite.dk, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, dlaurie@chromium.org
Subject: Re: [PATCH 1/2] i2c-designware-pci: Add Haswell ULT device IDs
Message-ID: <20131021065342.GW3521@intel.com>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
 <1382326010-4554-2-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382326010-4554-2-git-send-email-bleung@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 08:26:49PM -0700, Benson Leung wrote:
> From: Duncan Laurie <dlaurie@chromium.org>
> 
> Add the necessary PCI Device IDs to use the Haswell ULT
> I2C controller in PCI mode.
> 
> Set the bus numbers to -1 so it will use dynamic assignment
> rather than hardcoded.
> 
> Signed-off-by: Duncan Laurie <dlaurie@chromium.org>
> Signed-off-by: Benson Leung <bleung@chromium.org>

Looks good to me, except one thing...

> ---
>  drivers/i2c/busses/i2c-designware-pcidrv.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
> index f6ed06c..e4cbbdf 100644
> --- a/drivers/i2c/busses/i2c-designware-pcidrv.c
> +++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
> @@ -54,6 +54,9 @@ enum dw_pci_ctl_id_t {
>  	medfield_3,
>  	medfield_4,
>  	medfield_5,
> +
> +	haswell_0,
> +	haswell_1,
>  };
>  
>  struct dw_pci_controller {
> @@ -132,6 +135,20 @@ static struct  dw_pci_controller  dw_pci_controllers[] = {
>  		.rx_fifo_depth = 32,
>  		.clk_khz      = 25000,
>  	},
> +	[haswell_0] = {
> +		.bus_num     = -1,
> +		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_STD,
> +		.tx_fifo_depth = 32,
> +		.rx_fifo_depth = 32,
> +		.clk_khz      = 25000,

The input clock for I2C in Haswell is 100MHz, not 25MHz.

> +	},
> +	[haswell_1] = {
> +		.bus_num     = -1,
> +		.bus_cfg   = INTEL_MID_STD_CFG | DW_IC_CON_SPEED_STD,
> +		.tx_fifo_depth = 32,
> +		.rx_fifo_depth = 32,
> +		.clk_khz      = 25000,

Ditto.

> +	},
>  };
