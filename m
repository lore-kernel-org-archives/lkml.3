Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaEVXNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:13:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38776 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaEVXNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:13:20 -0400
Message-ID: <537E848C.5010204@wwwdotorg.org>
Date: Thu, 22 May 2014 17:13:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: fwu@marvell.com, linus.walleij@linaro.org, tony@atomide.com
CC: linux-kernel@vger.kernel.org, swarren@nvidia.com, cxie4@marvell.com,
        ylmao@marvell.com, njiang1@marvell.com, tianxf@marvell.com,
        fswu@marvell.com
Subject: Re: [PATCH v2] pinctrl: add params in disable_setting for different
 usage
References: <1400728210-17863-1-git-send-email-fwu@marvell.com>
In-Reply-To: <1400728210-17863-1-git-send-email-fwu@marvell.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 09:10 PM, fwu@marvell.com wrote:
> From: Fan Wu <fwu@marvell.com>
> 
> What the patch did:
> 1.To call pinmux_disable_setting ahead of pinmux_enable_setting in each time of
>   calling pinctrl_select_state
> 2.Remove the HW disable operation in in pinmux_disable_setting function.
> 
...
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index c0fe609..c97491a 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -993,25 +993,13 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
>  		 * may not be identical to the set of groups with a mux setting
>  		 * in the new state. While this might be unusual, it's entirely
>  		 * possible for the "user"-supplied mapping table to be written
> -		 * that way. For each group that was configured in the old state
> -		 * but not in the new state, this code puts that group into a
> -		 * safe/disabled state.
> +		 * that way. This code is used for each group that was
> +		 * configured in the old state but not in the new state


Looking at the code, it's run for every group in the state, not "each
group that was configured in the old state but not in the new state"

> @@ -515,9 +514,6 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
>  				 pins[i], desc->name, gname);
>  		}
>  	}
> -
> -	if (ops->disable)
> -		ops->disable(pctldev, setting->data.mux.func, setting->data.mux.group);
>  }

Should that op be removed from the header file and all drivers too?

