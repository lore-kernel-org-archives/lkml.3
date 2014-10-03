Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaJCPHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:07:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46773 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753330AbaJCPHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:07:07 -0400
Date: Fri, 3 Oct 2014 17:07:03 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: dan.carpenter@oracle.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: pxa168_eth: avoid using signed char for bitops
Message-ID: <20141003150703.GA20398@kwain>
References: <1412348517-20352-1-git-send-email-antoine.tenart@free-electrons.com>
 <1412348517-20352-2-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412348517-20352-2-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 05:01:54PM +0200, Antoine Tenart wrote:
> Signedness bugs may occur when using signed char for bitops,
> depending on if the highest bit is ever used.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> 
> Dan reported a static checker warning:
> http://marc.info/?l=kernel-janitors&m=141218246222535&w=2
> 
> This patch fixes it. Instead of using sa->sa_data we now use
> dev->dev_addr (of type unsigned char *) to avoid possible
> signedness issues.

Well, this patch shouldn't be in this thread. I'm resending it.
Sorry for the noise.

Antoine

> 
>  drivers/net/ethernet/marvell/pxa168_eth.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
> index 24de41231593..c3b209cd0660 100644
> --- a/drivers/net/ethernet/marvell/pxa168_eth.c
> +++ b/drivers/net/ethernet/marvell/pxa168_eth.c
> @@ -634,12 +634,12 @@ static int pxa168_eth_set_mac_address(struct net_device *dev, void *addr)
>  	memcpy(oldMac, dev->dev_addr, ETH_ALEN);
>  	memcpy(dev->dev_addr, sa->sa_data, ETH_ALEN);
>  
> -	mac_h = sa->sa_data[0] << 24;
> -	mac_h |= sa->sa_data[1] << 16;
> -	mac_h |= sa->sa_data[2] << 8;
> -	mac_h |= sa->sa_data[3];
> -	mac_l = sa->sa_data[4] << 8;
> -	mac_l |= sa->sa_data[5];
> +	mac_h = dev->dev_addr[0] << 24;
> +	mac_h |= dev->dev_addr[1] << 16;
> +	mac_h |= dev->dev_addr[2] << 8;
> +	mac_h |= dev->dev_addr[3];
> +	mac_l = dev->dev_addr[4] << 8;
> +	mac_l |= dev->dev_addr[5];
>  	wrl(pep, MAC_ADDR_HIGH, mac_h);
>  	wrl(pep, MAC_ADDR_LOW, mac_l);
>  
> -- 
> 1.9.1
> 

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
