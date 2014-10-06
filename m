Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaJFLqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:46:20 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37667 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaJFLqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:46:17 -0400
Message-ID: <54328107.5090400@cogentembedded.com>
Date: Mon, 06 Oct 2014 15:46:15 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/16] virtio-net: drop config_mutex
References: <1412525038-15871-1-git-send-email-mst@redhat.com> <1412525038-15871-10-git-send-email-mst@redhat.com>
In-Reply-To: <1412525038-15871-10-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/5/2014 8:07 PM, Michael S. Tsirkin wrote:

> config_mutex served two purposes: prevent multiple concurrent config
> change handlers, and synchronize access to config_enable flag.

> Since commit dbf2576e37da0fcc7aacbfbb9fd5d3de7888a3c1
>      workqueue: make all workqueues non-reentrant
> all workqueues are non-reentrant, and config_enable
> is now gone.

> Get rid of the unnecessary lock.

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/net/virtio_net.c | 7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)

> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index fa17afa..d80fef4 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
[...]
> @@ -1430,7 +1426,7 @@ static void virtnet_config_changed_work(struct work_struct *work)
>   		netif_tx_stop_all_queues(vi->dev);
>   	}
>   done:
> -	mutex_unlock(&vi->config_lock);
> +	return;

    There's no need for this *return*.

>   }
>
>   static void virtnet_config_changed(struct virtio_device *vdev)

WBR, Sergei

