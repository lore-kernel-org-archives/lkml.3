Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaBXW1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:27:43 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:34930 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaBXW1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:27:42 -0500
Date: Mon, 24 Feb 2014 17:27:39 -0500 (EST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nab@linux-iscsi.org
Message-ID: <1662106574.8578383.1393280859359.JavaMail.zimbra@redhat.com>
In-Reply-To: <20140224221332.GA32725@google.com>
References: <20140224221332.GA32725@google.com>
Subject: Re: [PATCH] vhost/scsi: Check LUN structure byte 0 is set to 1, per
 spec
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF26 (Linux)/8.0.6_GA_5922)
Thread-Topic: vhost/scsi: Check LUN structure byte 0 is set to 1, per spec
Thread-Index: kHEEaA4Z3INLRK1Q7bRn92CWiuxLCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> @@ -1001,6 +1001,12 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct
> vhost_virtqueue *vq)
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
> --
> 1.8.5.3
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
