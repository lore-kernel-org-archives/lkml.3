Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaFJJhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:37:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaFJJhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:37:45 -0400
Date: Tue, 10 Jun 2014 12:38:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the vhost tree
Message-ID: <20140610093806.GB7423@redhat.com>
References: <20140610141217.50d98cd6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610141217.50d98cd6@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 02:12:17PM +1000, Stephen Rothwell wrote:
> Hi Michael,
> 
> After merging the vhost tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/vhost/scsi.c: In function 'vhost_scsi_handle_vq':
> drivers/vhost/scsi.c:1043:14: error: 'struct vhost_dev' has no member named 'acked_features'
>    if (vs->dev.acked_features & VIRTIO_SCSI_F_T10_PI) {
>               ^
> 
> Commit 95e7c4341b8e ("vhost/scsi: Enable T10 PI IOV -> SGL memory
> mapping") from the target-updates tree interacting with commit
> 10350a292160 ("vhost: move acked_features to VQs") from the vhost tree.
> 
> I applied the following patch which seems right, but may not be.
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 10 Jun 2014 14:08:21 +1000
> Subject: [PATCH] vhost/scsi: fixup for acked_features move
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

This is exactly the correct resolution of this conflict.
ACK

> ---
>  drivers/vhost/scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 78ff1f64d759..6d7dd85365fe 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1040,7 +1040,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>  			break;
>  		}
>  
> -		if (vs->dev.acked_features & VIRTIO_SCSI_F_T10_PI) {
> +		if (vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI)) {
>  			req = &v_req_pi;
>  			lunp = &v_req_pi.lun[0];
>  			target = &v_req_pi.lun[1];
> -- 
> 2.0.0
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


