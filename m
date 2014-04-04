Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbaDDSJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:09:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:14016 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbaDDSJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:09:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,796,1389772800"; 
   d="scan'208";a="507142171"
Date: Fri, 4 Apr 2014 21:16:13 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: "Du, Wenkai" <wenkai.du@intel.com>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-designware: Mask interrupts during i2c controller
 enable
Message-ID: <20140404181613.GB19349@intel.com>
References: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70E1F@ORSMSX109.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7286EAF50D3F4E4AADE7FEECEBF8B5A537A70E1F@ORSMSX109.amr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 08:05:23PM +0300, Du, Wenkai wrote:
> diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
> index 14c4b30..71a3fa9 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -417,6 +417,9 @@ static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
>  	 */
>  	dw_writel(dev, msgs[dev->msg_write_idx].addr | ic_tar, DW_IC_TAR);
>  
> +	/* disable interrupts */
> +	i2c_dw_disable_int(dev);
> +

Please move this to i2c_dw_init() as I previously commented. This can only
happen once the controller comes out of reset (either boot, or resume from
system sleep).

>  	/* Enable the adapter */
>  	__i2c_dw_enable(dev, true);
>  
> -- 
> 1.7.9.5
