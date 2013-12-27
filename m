Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3L0O4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 09:56:22 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:36323 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3L0O4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 09:56:20 -0500
Message-ID: <52BD9512.5040105@cogentembedded.com>
Date: Fri, 27 Dec 2013 18:56:18 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ding Tianhong <dingtianhong@huawei.com>, Ariel Elior <ariele@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 02/20] net: bnx2x: slight optimization of addr
 compare
References: <52BD22AD.3090702@huawei.com>
In-Reply-To: <52BD22AD.3090702@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 27-12-2013 10:48, Ding Tianhong wrote:

> Use the possibly more efficient ether_addr_equal or
> ether_addr_equal_unaligned to instead of memcmp.

> Cc: Ariel Elior <ariele@broadcom.com>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c    | 10 ++++------
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c |  2 +-
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c  |  2 +-
>   3 files changed, 6 insertions(+), 8 deletions(-)

> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> index 32c92ab..a83c67c 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
[...]
> @@ -696,8 +696,7 @@ static int bnx2x_check_vlan_mac_add(struct bnx2x *bp,
>
>   	list_for_each_entry(pos, &o->head, link)
>   		if ((data->vlan_mac.vlan == pos->u.vlan_mac.vlan) &&
> -		    (!memcmp(data->vlan_mac.mac, pos->u.vlan_mac.mac,
> -				  ETH_ALEN)) &&
> +		    (ether_addr_equal_unaligned(data->vlan_mac.mac, pos->u.vlan_mac.mac)) &&

    Pointless parens around function call again.

> @@ -716,7 +715,7 @@ static struct bnx2x_vlan_mac_registry_elem *
>   	DP(BNX2X_MSG_SP, "Checking MAC %pM for DEL command\n", data->mac.mac);
>
>   	list_for_each_entry(pos, &o->head, link)
> -		if ((!memcmp(data->mac.mac, pos->u.mac.mac, ETH_ALEN)) &&
> +		if ((ether_addr_equal(data->mac.mac, pos->u.mac.mac)) &&

    ... and again.

> @@ -751,8 +750,7 @@ static struct bnx2x_vlan_mac_registry_elem *
>
>   	list_for_each_entry(pos, &o->head, link)
>   		if ((data->vlan_mac.vlan == pos->u.vlan_mac.vlan) &&
> -		    (!memcmp(data->vlan_mac.mac, pos->u.vlan_mac.mac,
> -			     ETH_ALEN)) &&
> +		    (ether_addr_equal_unaligned(data->vlan_mac.mac, pos->u.vlan_mac.mac)) &&

    ... and again.

WBR, Sergei

