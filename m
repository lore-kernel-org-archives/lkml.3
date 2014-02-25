Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaBYANf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:13:35 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:34253 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaBYANd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:13:33 -0500
Message-ID: <1393287410.10384.23.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] vhost/scsi: Check LUN structure byte 0 is set to 1, per
 spec
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, target-devel <target-devel@vger.kernel.org>
Date: Mon, 24 Feb 2014 16:16:50 -0800
In-Reply-To: <20140224221332.GA32725@google.com>
References: <20140224221332.GA32725@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venkatesh,

On Mon, 2014-02-24 at 14:13 -0800, Venkatesh Srinivas wrote:
> The virtio spec requires byte 0 of the virtio-scsi LUN structure
> to be '1'.
> 
> Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>
> ---
>   drivers/vhost/scsi.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 0a025b8..e48d4a6 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1001,6 +1001,12 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>   			break;
>   		}
>   
> +		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
> +		if (unlikely(v_req.lun[0] != 1)) {
> +			vhost_scsi_send_bad_target(vs, vq, head, out);
> +			continue;
> +		}
> +
>   		/* Extract the tpgt */
>   		target = v_req.lun[1];
>   		tpg = ACCESS_ONCE(vs_tpg[target]);

Applied to target-pending/master, and including in the next v3.14-rc
PULL request.

Thanks!

--nab

