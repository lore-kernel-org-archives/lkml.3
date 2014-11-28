Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaK1IfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:35:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaK1IfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:35:21 -0500
Date: Fri, 28 Nov 2014 08:43:01 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v6 29/46] vhost: add memory access wrappers
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, thuth@linux.vnet.ibm.com,
        kvm@vger.kernel.org, rusty@au1.ibm.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, dahi@linux.vnet.ibm.com,
        pbonzini@redhat.com, David Miller <davem@davemloft.net>
Message-Id: <1417163701.5822.8@smtp.corp.redhat.com>
In-Reply-To: <1417118789-18231-30-git-send-email-mst@redhat.com>
References: <1417118789-18231-1-git-send-email-mst@redhat.com>
	<1417118789-18231-30-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, Nov 28, 2014 at 4:10 AM, Michael S. Tsirkin <mst@redhat.com> 
wrote:
> Add guest memory access wrappers to handle virtio endianness
> conversions.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/vhost/vhost.h | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index c624b09..1f321fd 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -176,4 +176,35 @@ static inline int vhost_has_feature(struct 
> vhost_virtqueue *vq, int bit)
>  {
>  	return vq->acked_features & (1ULL << bit);
>  }
> +
> +/* Memory accessors */
> +static inline u16 vhost16_to_cpu(struct vhost_virtqueue *vq, 
> __virtio16 val)
> +{
> +	return __virtio16_to_cpu(vhost_has_feature(vq, VIRTIO_F_VERSION_1), 
> val);
> +}
> +
> +static inline __virtio16 cpu_to_vhost16(struct vhost_virtqueue *vq, 
> u16 val)
> +{
> +	return __cpu_to_virtio16(vhost_has_feature(vq, VIRTIO_F_VERSION_1), 
> val);
> +}
> +
> +static inline u32 vhost32_to_cpu(struct vhost_virtqueue *vq, 
> __virtio32 val)
> +{
> +	return __virtio32_to_cpu(vhost_has_feature(vq, VIRTIO_F_VERSION_1), 
> val);
> +}
> +
> +static inline __virtio32 cpu_to_vhost32(struct vhost_virtqueue *vq, 
> u32 val)
> +{
> +	return __cpu_to_virtio32(vhost_has_feature(vq, VIRTIO_F_VERSION_1), 
> val);
> +}
> +
> +static inline u64 vhost64_to_cpu(struct vhost_virtqueue *vq, 
> __virtio64 val)
> +{
> +	return __virtio64_to_cpu(vhost_has_feature(vq, VIRTIO_F_VERSION_1), 
> val);
> +}
> +
> +static inline __virtio64 cpu_to_vhost64(struct vhost_virtqueue *vq, 
> u64 val)
> +{
> +	return __cpu_to_virtio64(vhost_has_feature(vq, VIRTIO_F_VERSION_1), 
> val);
> +}
>  #endif
> -- 
> MST

Reviewed-by: Jason Wang <jasowang@redhat.com>

