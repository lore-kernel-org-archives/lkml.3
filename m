Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbaIBUCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:02:41 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:36547 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaIBUCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:02:40 -0400
Message-ID: <5406225B.305@cogentembedded.com>
Date: Wed, 03 Sep 2014 00:02:35 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andy King <acking@vmware.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
CC: davem@davemloft.net, pv-drivers@vmware.com,
        penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [PATCH] VMXNET3: Check for map error in vmxnet3_set_mc
References: <1409675408-8440-1-git-send-email-acking@vmware.com>
In-Reply-To: <1409675408-8440-1-git-send-email-acking@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/02/2014 08:30 PM, Andy King wrote:

> We should check if the map of the table actually succeeds, and also free
> resources accordingly. This fixes the kernel panic reported by Tetsuo
> Handa.

    There's "Reported-by:" line for that.

> Version bumped to 1.2.1.0

> Acked-by: Shelley Gong <shelleygong@vmware.com>
> Acked-by: Bhavesh Davda <bhavesh@vmware.com>
> Signed-off-by: Andy King <acking@vmware.com>
> ---
>   drivers/net/vmxnet3/vmxnet3_drv.c |   14 ++++++++------
>   drivers/net/vmxnet3/vmxnet3_int.h |    4 ++--
>   2 files changed, 10 insertions(+), 8 deletions(-)

> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index d6e90c7..f450010 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
[...]
> @@ -2091,11 +2093,11 @@ vmxnet3_set_mc(struct net_device *netdev)
>   			       VMXNET3_CMD_UPDATE_MAC_FILTERS);
>   	spin_unlock_irqrestore(&adapter->cmd_lock, flags);
>
> -	if (new_table) {
> +	if (new_table_pa)
>   		dma_unmap_single(&adapter->pdev->dev, new_table_pa,
>   				 rxConf->mfTableLen, PCI_DMA_TODEVICE);
> +	if (new_table)
>   		kfree(new_table);

    The above *if* is not needed -- kfree() already checks for NULL.

[...]

WBR, Sergei

