Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaGJI0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:26:39 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62605 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaGJI0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:26:34 -0400
Message-ID: <53BE4DEC.7030909@gmail.com>
Date: Thu, 10 Jul 2014 13:55:16 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v7 15/33] net: xen-netback - set name assign type
References: <1404980258-30853-1-git-send-email-teg@jklm.no> <1404980258-30853-16-git-send-email-teg@jklm.no>
In-Reply-To: <1404980258-30853-16-git-send-email-teg@jklm.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 01:47 PM, Tom Gundersen wrote:
> The name contains then xen handle, which is not guaranteed to be
> stable between restarts, so label this NET_NAME_ENUM.
>
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Cc: Ian Campbell <ian.campbell@citrix.com>
> Cc: Wei Liu <wei.liu2@citrix.com>
> Cc: xen-devel@lists.xenproject.org
> ---
>   drivers/net/xen-netback/interface.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
> index 793275d..da906d1 100644
> --- a/drivers/net/xen-netback/interface.c
> +++ b/drivers/net/xen-netback/interface.c
> @@ -418,8 +418,8 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
>   	 * When the guest selects the desired number, it will be updated
>   	 * via netif_set_real_num_*_queues().
>   	 */
> -	dev = alloc_netdev_mq(sizeof(struct xenvif), name, NET_NAME_UNKNOWN,
> -			      ether_setup, xenvif_max_queues);
> +	dev = alloc_netdev_mq(sizeof(struct xenvif), name, NET_NAME_ENUM, ether_setup,
> +			      xenvif_max_queues);

What i am suggesting is irrelavent to this patch. But also consider this suggestion

In place sizeof(struct xenvif) --> sizeof(*vif) ???

>   	if (dev == NULL) {
>   		pr_warn("Could not allocate netdev for %s\n", name);
>   		return ERR_PTR(-ENOMEM);


-- 
Regards,
Varka Bhadram.

