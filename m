Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaK3Poj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 10:44:39 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:35118 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaK3Poh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 10:44:37 -0500
Message-ID: <547B3B61.3090801@cogentembedded.com>
Date: Sun, 30 Nov 2014 18:44:33 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
CC: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v7 28/46] vhost: make features 64 bit
References: <1417359787-10138-1-git-send-email-mst@redhat.com> <1417359787-10138-29-git-send-email-mst@redhat.com>
In-Reply-To: <1417359787-10138-29-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/30/2014 6:11 PM, Michael S. Tsirkin wrote:

> We need to use bit 32 for virtio 1.0

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/vhost/vhost.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 3eda654..c624b09 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -106,7 +106,7 @@ struct vhost_virtqueue {
>   	/* Protected by virtqueue mutex. */
>   	struct vhost_memory *memory;
>   	void *private_data;
> -	unsigned acked_features;
> +	u64 acked_features;
>   	/* Log write descriptors */
>   	void __user *log_base;
>   	struct vhost_log *log;
> @@ -174,6 +174,6 @@ enum {
>
>   static inline int vhost_has_feature(struct vhost_virtqueue *vq, int bit)
>   {
> -	return vq->acked_features & (1 << bit);
> +	return vq->acked_features & (1ULL << bit);

    Erm, wouldn't the high word be just dropped when returning *int*? I think 
you need !!(vq->acked_features & (1ULL << bit)).

[...]

WBR, Sergei

