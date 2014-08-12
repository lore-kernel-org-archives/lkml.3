Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaHLI2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 04:28:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49852 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651AbaHLI2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 04:28:13 -0400
Date: Tue, 12 Aug 2014 09:28:11 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, sameo@linux.intel.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        cw00.choi@samsung.com, robh+dt@kernel.org, galak@codeaurora.org,
        lee.jones@linaro.org
Subject: Re: [alsa-devel] [PATCH 1/2] mfd: arizona: Add support for
	INn_MODE register control
Message-ID: <20140812082811.GB15833@opensource.wolfsonmicro.com>
References: <20140809173138.767b97fd@songinha-Samsung-DeskTop-System>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140809173138.767b97fd@songinha-Samsung-DeskTop-System>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 05:31:38PM +0900, Inha Song wrote:
> Some boards need to set the INn_MODE[1:0] register to change
> the input signal patch. This wlf,inmode property is optional.
> If present values must be specified by the number of
> ARIZONA_MAX_INPUT.
> 
> Example:
>    - wlf,inmode = <2 0 2 0>;	/* IN1, IN3 use DMIC */
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---
>  drivers/mfd/arizona-core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index 10a0cb9..4b2eb73 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -560,6 +560,10 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
>  			ret);
>  	}
>  
> +	of_property_read_u32_array(arizona->dev->of_node,
> +					 "wlf,inmode",
> +					 arizona->pdata.inmode,
> +					 ARRAY_SIZE(arizona->pdata.inmode));

Might be better to allow the device tree to be shorter than the
array in pdata, should this get expanded on future devices.

Thanks,
Charles
