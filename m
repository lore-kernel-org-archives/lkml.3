Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3ETBSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 21:18:08 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:59420 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab3ETBSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 21:18:06 -0400
Date: Mon, 20 May 2013 10:18:02 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Axel Lin <axel.lin@ingics.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: renesas-tpu: Add missing pwmchip_remove() call in
 tpu_remove()
Message-ID: <20130520011801.GC16811@verge.net.au>
References: <1368942331.3455.2.camel@phoenix>
 <3914560.biJ8gxkuTL@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3914560.biJ8gxkuTL@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 04:22:21PM +0200, Laurent Pinchart wrote:
> Hi Axel,
> 
> Thank you for the patch.
> 
> On Sunday 19 May 2013 13:45:31 Axel Lin wrote:
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> > ---
> >  drivers/pwm/pwm-renesas-tpu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
> > index 8e6d8d7..351addd 100644
> > --- a/drivers/pwm/pwm-renesas-tpu.c
> > +++ b/drivers/pwm/pwm-renesas-tpu.c
> > @@ -444,7 +444,7 @@ static int tpu_remove(struct platform_device *pdev)
> > 
> >  	pm_runtime_disable(&pdev->dev);
> > 
> > -	return 0;
> > +	return pwmchip_remove(&tpu->chip);
> 
> Could you please move that line at the beginning of the function ? There would 
> be a race condition otherwise, as the user could reenable PWM between the 
> tpu_pwm_timer_stop() calls and the pwmchip_remove() call.
> 
> Apart from that, the patch looks good.

Also, could you please CC linux-sh@vger.kernel.org,
that will help me track the change through patchwork.

Thanks!

> 
> >  }
> > 
> >  static struct platform_driver tpu_driver = {
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
