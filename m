Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab3CSQRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:17:41 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2685 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab3CSQRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:17:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Mar 2013 09:17:39 -0700
Message-ID: <51488FA2.2090509@nvidia.com>
Date: Tue, 19 Mar 2013 12:17:38 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [Patch v3 2/4] mfd: tps65090: Add resources for charger
References: <1363126089-9071-1-git-send-email-rklein@nvidia.com> <1363126089-9071-3-git-send-email-rklein@nvidia.com>
In-Reply-To: <1363126089-9071-3-git-send-email-rklein@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2013 6:08 PM, Rhyland Klein wrote:
> Add irq resources to pass to the charger mfd sub dev so
> the charger can listen for interrupts.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
> v3:
>  - no changes since v2
> v2:
>  - no changes since v1
> 
>  drivers/mfd/tps65090.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
> index 98edb5be..88846ae 100644
> --- a/drivers/mfd/tps65090.c
> +++ b/drivers/mfd/tps65090.c
> @@ -56,12 +56,22 @@
>  #define TPS65090_INT2_MASK_OVERLOAD_FET6		6
>  #define TPS65090_INT2_MASK_OVERLOAD_FET7		7
>  
> +static struct resource charger_resources[] = {
> +	{
> +		.start  = TPS65090_IRQ_VAC_STATUS_CHANGE,
> +		.end    = TPS65090_IRQ_VAC_STATUS_CHANGE,
> +		.flags  = IORESOURCE_IRQ,
> +	}
> +};
> +
>  static struct mfd_cell tps65090s[] = {
>  	{
>  		.name = "tps65090-pmic",
>  	},
>  	{
>  		.name = "tps65090-charger",
> +		.num_resources = ARRAY_SIZE(charger_resources),
> +		.resources = &charger_resources[0],
>  	},
>  };
>  
> 

Samuel, Anton merged patches 3 & 4 of this series. Have you had a chance
to review patches 1 & 2 ?

-rhyland

-- 
nvpublic
