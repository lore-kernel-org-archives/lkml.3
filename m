Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab3LKIHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 03:07:48 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:53772 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3LKIHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 03:07:46 -0500
Message-ID: <52A81D50.8080805@atmel.com>
Date: Wed, 11 Dec 2013 09:07:44 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        "kbuild test robot" <fengguang.wu@intel.com>
Subject: Re: [PATCH] net: macb: Fix build warning
References: <1386737877-16531-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1386737877-16531-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 05:57, Soren Brinkmann :
> When adjusting the link speed, the target frequency is determined by a
> 'swith (LINK_SPEED)' statement, that assigns the target rate only for
> valid and expected LINK_SPEED values. This incomplete switch statement
> leads to the following build warning:
>       drivers/net/ethernet/cadence/macb.c: In function 'macb_handle_link_change':
>    >> drivers/net/ethernet/cadence/macb.c:241:14: warning: 'rate' may be used uninitialized in this function [-Wmaybe-uninitialized]
>          netdev_warn(dev, "unable to generate target frequency: %ld Hz\n",
>                     ^
>       drivers/net/ethernet/cadence/macb.c:215:13: note: 'rate' was declared here
>         long ferr, rate, rate_rounded;
>
> Fixing this by bailing out of that function in the switch's default case
> before the rate variable is used.
>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   drivers/net/ethernet/cadence/macb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index 419529a9309d..3190d38e16fb 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -225,7 +225,7 @@ static void macb_set_tx_clk(struct clk *clk, int speed, struct net_device *dev)
>   		rate = 125000000;
>   		break;
>   	default:
> -		break;
> +		return;
>   	}
>
>   	rate_rounded = clk_round_rate(clk, rate);
>


-- 
Nicolas Ferre
