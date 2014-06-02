Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaFBIng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:43:36 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:42319 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaFBInd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:43:33 -0400
Message-ID: <538C3931.6060300@6wind.com>
Date: Mon, 02 Jun 2014 10:43:29 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: stable@vger.kernel.org, Cong Wang <amwang@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.10 47/86] vti: dont allow to add the same tunnel twice
References: <20140529043513.451722422@linuxfoundation.org> <20140529043519.840388349@linuxfoundation.org>
In-Reply-To: <20140529043519.840388349@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 29/05/2014 06:37, Greg Kroah-Hartman a écrit :
> 3.10-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>
> [ Upstream commit 8d89dcdf80d88007647945a753821a06eb6cc5a5 ]
>
> Before the patch, it was possible to add two times the same tunnel:
> ip l a vti1 type vti remote 10.16.0.121 local 10.16.0.249 key 41
> ip l a vti2 type vti remote 10.16.0.121 local 10.16.0.249 key 41
>
> It was possible, because ip_tunnel_newlink() calls ip_tunnel_find() with the
> argument dev->type, which was set only later (when calling ndo_init handler
> in register_netdevice()). Let's set this type in the setup handler, which is
> called before newlink handler.
>
> Introduced by commit b9959fd3b0fa ("vti: switch to new ip tunnel code").
Not sure to understand why this patch is backported:
$ git describe --contains b9959fd3b0fa
v3.12-rc1~132^2~479

In fact, the patch does not change anything.


Regards,
Nicolas

>
> CC: Cong Wang <amwang@redhat.com>
> CC: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   net/ipv4/ip_vti.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/net/ipv4/ip_vti.c
> +++ b/net/ipv4/ip_vti.c
> @@ -579,9 +579,9 @@ static void vti_dev_free(struct net_devi
>   static void vti_tunnel_setup(struct net_device *dev)
>   {
>   	dev->netdev_ops		= &vti_netdev_ops;
> +	dev->type		= ARPHRD_TUNNEL;
>   	dev->destructor		= vti_dev_free;
>
> -	dev->type		= ARPHRD_TUNNEL;
>   	dev->hard_header_len	= LL_MAX_HEADER + sizeof(struct iphdr);
>   	dev->mtu		= ETH_DATA_LEN;
>   	dev->flags		= IFF_NOARP;
>
>

