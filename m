Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3FQX5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:57:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:3180 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab3FQX4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:56:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="351358362"
Date: Tue, 18 Jun 2013 01:56:44 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tero Kristo <t-kristo@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: twl4030-power: Split from twl-core into a
 dedicated module
Message-ID: <20130617235644.GB7998@zurbaran>
References: <1369921916-7435-1-git-send-email-florian.vaussard@epfl.ch>
 <1369921916-7435-2-git-send-email-florian.vaussard@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369921916-7435-2-git-send-email-florian.vaussard@epfl.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Thu, May 30, 2013 at 03:51:54PM +0200, Florian Vaussard wrote:
> For now, the call to twl4030-power is hard-wired inside twl-core.
> To ease the future transition to DT, make twl4030-power as a
> separate module, like what is already done for twl4030-audio
> and others.
> 
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> ---
>  drivers/mfd/twl-core.c      |   12 ++++++---
>  drivers/mfd/twl4030-power.c |   54 +++++++++++++++++++++++++++++++++++--------
>  include/linux/i2c/twl.h     |    1 -
>  3 files changed, 52 insertions(+), 15 deletions(-)
Looks good, I only have one comment:

> +static struct platform_driver twl4030_power_driver = {
> +	.driver = {
> +		.name	= "twl4030_power",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= twl4030_power_probe,
> +	.remove		= twl4030_power_remove,
> +};
> +
> +static int __init twl4030_power_init(void)
> +{
> +	return platform_driver_register(&twl4030_power_driver);
>  }
> +subsys_initcall(twl4030_power_init);
> +
> +static void __exit twl4030_power_exit(void)
> +{
> +	platform_driver_unregister(&twl4030_power_driver);
> +}
> +module_exit(twl4030_power_exit);
Please use module_platform_driver() here.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
