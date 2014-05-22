Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaEVXHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:07:21 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:40659
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684AbaEVXGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:06:37 -0400
X-IronPort-AV: E=Sophos;i="4.98,890,1392159600"; 
   d="scan'208";a="63295339"
Date: Fri, 23 May 2014 07:06:10 +0800 (SGT)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: =?ISO-8859-15?Q?Manuel_Sch=F6lling?= <manuel.schoelling@gmx.de>
cc: davem@davemloft.net, jg1.han@samsung.com, dingtianhong@huawei.com,
        ebiederm@xmission.com, Julia.Lawall@lip6.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] micrel: Use time_before_eq()
In-Reply-To: <1400781165-26498-1-git-send-email-manuel.schoelling@gmx.de>
Message-ID: <alpine.DEB.2.10.1405230705350.2606@hadrien>
References: <1400781165-26498-1-git-send-email-manuel.schoelling@gmx.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-849477787-1400799994=:2606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-849477787-1400799994=:2606
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 22 May 2014, Manuel Schölling wrote:

> To be future-proof and for better readability the time comparisons are modified
> to use time_before_eq() instead of plain, error-prone math.

I had the impression that the real reason for these functions was that
they were somehow sensitive to the possibility of overflow of jiffies?

julia

> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
> ---
>  drivers/net/ethernet/micrel/ksz884x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
> index 14ac0e2..90fa5f3 100644
> --- a/drivers/net/ethernet/micrel/ksz884x.c
> +++ b/drivers/net/ethernet/micrel/ksz884x.c
> @@ -4930,7 +4930,7 @@ static void netdev_tx_timeout(struct net_device *dev)
>  		 * Only reset the hardware if time between calls is long
>  		 * enough.
>  		 */
> -		if (jiffies - last_reset <= dev->watchdog_timeo)
> +		if (time_before_eq(jiffies, last_reset + dev->watchdog_timeo))
>  			hw_priv = NULL;
>  	}
>
> --
> 1.7.10.4
>
>
--8323329-849477787-1400799994=:2606--
