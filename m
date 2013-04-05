Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162040Ab3DEQcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:32:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:3328 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161978Ab3DEQck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:32:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,415,1363158000"; 
   d="scan'208";a="289974780"
Date: Fri, 5 Apr 2013 18:32:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        swarren@wwwdotorg.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, mturquette@linaro.org, linus.walleij@linaro.org,
        cooloney@gmail.com, sfr@canb.auug.org.au, rpurdie@rpsys.net,
        akpm@linux-foundation.org, wim@iguana.be, lgirdwood@gmail.com,
        gg@slimlogic.co.uk, j-keerthy@ti.com, ldewangan@nvidia.com,
        t-kristo@ti.com
Subject: Re: [PATCH v10 03/12] mfd: palmas add variant and OTP detection
Message-ID: <20130405163223.GO17363@zurbaran>
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
 <1363964122-19201-4-git-send-email-ian@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363964122-19201-4-git-send-email-ian@slimlogic.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Fri, Mar 22, 2013 at 02:55:13PM +0000, Ian Lartey wrote:
> @@ -278,20 +329,20 @@ static void palmas_dt_to_pdata(struct i2c_client *i2c,
>  	int ret;
>  	u32 prop;
>  
> -	ret = of_property_read_u32(node, "ti,mux_pad1", &prop);
> +	ret = of_property_read_u32(node, "ti,mux-pad1", &prop);
>  	if (!ret) {
>  		pdata->mux_from_pdata = 1;
>  		pdata->pad1 = prop;
>  	}
>  
> -	ret = of_property_read_u32(node, "ti,mux_pad2", &prop);
> +	ret = of_property_read_u32(node, "ti,mux-pad2", &prop);
>  	if (!ret) {
>  		pdata->mux_from_pdata = 1;
>  		pdata->pad2 = prop;
>  	}
>  
>  	/* The default for this register is all masked */
> -	ret = of_property_read_u32(node, "ti,power_ctrl", &prop);
> +	ret = of_property_read_u32(node, "ti,power-ctrl", &prop);
>  	if (!ret)
>  		pdata->power_ctrl = prop;
>  	else
> @@ -309,7 +360,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
>  	struct palmas_platform_data *pdata;
>  	struct device_node *node = i2c->dev.of_node;
>  	int ret = 0, i;
> -	unsigned int reg, addr;
> +	unsigned int reg;
>  	int slave;
>  	struct mfd_cell *children;
The '-' to '_' fix has been sent by J Keerthy and is on my mfd-next tree
aready. Would you mind removing it from this patch ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
