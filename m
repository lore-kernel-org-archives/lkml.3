Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaETIWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:22:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaETIWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:22:11 -0400
Date: Tue, 20 May 2014 16:22:04 +0800
From: Amos Kong <akong@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/qxl: return IRQ_NONE if it was not our irq
Message-ID: <20140520082204.GA17126@amosk.info>
References: <1399883739-14266-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399883739-14266-1-git-send-email-jasowang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 04:35:39PM +0800, Jason Wang wrote:
> Return IRQ_NONE if it was not our irq. This is necessary for the case
> when qxl is sharing irq line with a device A in a crash kernel. If qxl
> is initialized before A and A's irq was raised during this gap,
> returning IRQ_HANDLED in this case will cause this irq to be raised
> again after EOI since kernel think it was handled but in fact it was
> not.
> 
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/gpu/drm/qxl/qxl_irq.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/qxl/qxl_irq.c b/drivers/gpu/drm/qxl/qxl_irq.c
> index 28f84b4..3485bdc 100644
> --- a/drivers/gpu/drm/qxl/qxl_irq.c
> +++ b/drivers/gpu/drm/qxl/qxl_irq.c
> @@ -33,6 +33,9 @@ irqreturn_t qxl_irq_handler(int irq, void *arg)
>  
>  	pending = xchg(&qdev->ram_header->int_pending, 0);
>  
> +	if (!pending)
> +		return IRQ_NONE;
> +

Looks correct.

Revewed-by: Amos Kong <akong@redhat.com>

>  	atomic_inc(&qdev->irq_received);
>  
>  	if (pending & QXL_INTERRUPT_DISPLAY) {
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
			Amos.
