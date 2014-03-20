Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbaCTJhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:37:47 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:23303 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbaCTJhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:37:45 -0400
Message-ID: <532AB68C.1040003@huawei.com>
Date: Thu, 20 Mar 2014 17:36:12 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Zheng Li <zheng.x.li@oracle.com>, <netdev@vger.kernel.org>,
        <fubar@us.ibm.com>, <andy@greyhouse.net>
CC: <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <joe.jin@oracle.com>
Subject: Re: [PATCH] bonding: Inactive slaves should keep inactive flag's
 value to 1.
References: <1395305504-29973-1-git-send-email-zheng.x.li@oracle.com>
In-Reply-To: <1395305504-29973-1-git-send-email-zheng.x.li@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/20 16:51, Zheng Li wrote:
> Except bond mode 1, in other bond modes, inactive slaves should keep inactive flag to
> 1 to refuse to receive broadcast packets. Now, active slave send broadcast packets
> (for example ARP requests) which will arrive inactive slaves on same host from switch,
> but inactive slave's inactive flag is zero that cause bridge receive the broadcast
> packets to produce a wrong entry in forward table. Typical situation is domu send some
> ARP request which go out from dom0 bond's active slave, then the ARP broadcast request
> packets go back to inactive slave from switch, because the inactive slave's inactive
> flag is zero, kernel will receive the packets and pass them to bridge, that cause dom0's
> bridge map domu's MAC address to port of bond, bridge should map domu's MAC to port of vif.
> 
> Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
> ---
>  drivers/net/bonding/bond_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index e5628fc..2f73f18 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3063,7 +3063,7 @@ static int bond_open(struct net_device *bond_dev)
>  				bond_set_slave_inactive_flags(slave,
>  							      BOND_SLAVE_NOTIFY_NOW);
>  			} else {
> -				bond_set_slave_active_flags(slave,
> +				bond_set_slave_state(slave, BOND_STATE_ACTIVE,
>  							    BOND_SLAVE_NOTIFY_NOW);

This patch could be applied?

Ding

>  			}
>  		}
> 


