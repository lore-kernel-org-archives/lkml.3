Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaE1OLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:11:06 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:54812 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbaE1OLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:11:02 -0400
Message-ID: <5385EE7A.2030501@cogentembedded.com>
Date: Wed, 28 May 2014 18:11:06 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>,
        Samuel Chessman <chessman@tux.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] tlan: Make autonegotiation faster
References: <1401226727-5508-1-git-send-email-linux@rainbow-software.org> <1401226727-5508-8-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1401226727-5508-8-git-send-email-linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/28/2014 01:38 AM, Ondrej Zary wrote:

> Reduce the autonegotiation poll interval from 8 seconds to 2.
> This greatly reduces the time needed to detect link presence,
> especially on Olicom cards at 10 Mbps (two autonegoatiations required).

> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
>   drivers/net/ethernet/ti/tlan.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
> index 628a779..007c2fe 100644
> --- a/drivers/net/ethernet/ti/tlan.c
> +++ b/drivers/net/ethernet/ti/tlan.c
> @@ -2699,7 +2699,7 @@ static void tlan_phy_finish_auto_neg(struct net_device *dev)
>   		/* Wait for 8 sec to give the process
>   		 * more time.  Perhaps we should fail after a while.
>   		 */
> -		tlan_set_timer(dev, (8*HZ), TLAN_TIMER_PHY_FINISH_AN);
> +		tlan_set_timer(dev, (2*HZ), TLAN_TIMER_PHY_FINISH_AN);

    The inner () not needed but space around * wouldn't hurt.

>   		return;
>   	}

WBR, Sergei

