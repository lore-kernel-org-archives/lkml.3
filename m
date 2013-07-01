Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3GAQNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:13:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2043 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3GAQNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:13:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 01 Jul 2013 09:13:05 -0700
Message-ID: <51D1AA9E.2000909@nvidia.com>
Date: Mon, 1 Jul 2013 12:13:18 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Anton Vorontsov <anton@enomsg.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] power_supply: Add of_node_put to fix refcount
References: <1370899602-22123-1-git-send-email-rklein@nvidia.com> <1370899602-22123-2-git-send-email-rklein@nvidia.com> <20130629012255.GA20924@lizard>
In-Reply-To: <20130629012255.GA20924@lizard>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/2013 9:22 PM, Anton Vorontsov wrote:
> On Mon, Jun 10, 2013 at 05:26:39PM -0400, Rhyland Klein wrote:
>> of_parse_phandle increments the refcount for a dt node before returning
>> it. Add of_node_put where needed to properly decrement the refcount
>> when we are done using a given node.
>>
>> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
>> ---
> 
> With CONFIG_OF=n I got this:
> 
>   CC      drivers/power/sbs-battery.o
>   drivers/power/sbs-battery.c: In function ‘sbs_probe’:
>   drivers/power/sbs-battery.c:707:20: error: ‘struct power_supply’ has no
>   member named ‘of_node’
>   make[1]: *** [drivers/power/sbs-battery.o] Error 1
> 
> I fixed this by the patch below and applied your 1-3 series.
> 
> Thanks!
> 
> Anton
> 
> commit b50df95c8f0703c95625181d2eaf53855c5ebee5
> Author: Anton Vorontsov <anton@enomsg.org>
> Date:   Fri Jun 28 18:17:22 2013 -0700
> 
>     power_supply: Move of_node out of the #ifdef CONFIG_OF
>     
>     Similar to linux/device.h, move of_node struct member out of the #ifdef
>     CONFIG_OF so that the drivers won't have to mess with #ifdefs in .c files.
>     
>     Signed-off-by: Anton Vorontsov <anton@enomsg.org>
> 
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 3828cef..804b906 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -162,6 +162,8 @@ union power_supply_propval {
>  	const char *strval;
>  };
>  
> +struct device_node;
> +
>  struct power_supply {
>  	const char *name;
>  	enum power_supply_type type;
> @@ -173,9 +175,7 @@ struct power_supply {
>  
>  	char **supplied_from;
>  	size_t num_supplies;
> -#ifdef CONFIG_OF
>  	struct device_node *of_node;
> -#endif
>  
>  	int (*get_property)(struct power_supply *psy,
>  			    enum power_supply_property psp,
> 

Thanks!

-rhyland

-- 
nvpublic
