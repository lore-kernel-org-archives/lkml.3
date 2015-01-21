Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbbAUAht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:37:49 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34352 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbAUAhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:37:48 -0500
Message-ID: <54BEF4CF.806@gmail.com>
Date: Tue, 20 Jan 2015 16:37:35 -0800
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        netdev@vger.kernel.org
CC: "David S . Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: Re: [PATCH] net: dsa: set slave MII bus PHY mask
References: <1421799212-2028-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1421799212-2028-2-git-send-email-vivien.didelot@savoirfairelinux.com>
In-Reply-To: <1421799212-2028-2-git-send-email-vivien.didelot@savoirfairelinux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/15 16:13, Vivien Didelot wrote:
> When registering a mdio bus, Linux assumes than every port has a PHY and tries
> to scan it. If a switch port has no PHY registered, DSA will fail to register
> the slave MII bus. To fix this, set the slave MII bus PHY mask to the switch
> PHYs mask.
> 
> As an example, if we use a Marvell MV88E6352 (which is a 7-port switch with no
> registered PHYs for port 5 and port 6), with the following declared names:
> 
> 	static struct dsa_chip_data switch_cdata = {
> 		[...]
> 		.port_names[0] = "sw0",
> 		.port_names[1] = "sw1",
> 		.port_names[2] = "sw2",
> 		.port_names[3] = "sw3",
> 		.port_names[4] = "sw4",
> 		.port_names[5] = "cpu",
> 	};
> 
> DSA will fail to create the switch instance. With the PHY mask set for the
> slave MII bus, only the PHY for ports 0-4 will be scanned and the instance will
> be successfully created.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  net/dsa/slave.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 515569f..589aafd 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -46,6 +46,7 @@ void dsa_slave_mii_bus_init(struct dsa_switch *ds)
>  	snprintf(ds->slave_mii_bus->id, MII_BUS_ID_SIZE, "dsa-%d:%.2x",
>  			ds->index, ds->pd->sw_addr);
>  	ds->slave_mii_bus->parent = ds->master_dev;
> +	ds->slave_mii_bus->phy_mask = ~ds->phys_mii_mask;
>  }
>  
>  
> 


-- 
Florian
