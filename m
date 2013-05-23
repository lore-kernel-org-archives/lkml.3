Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab3EWBji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 21:39:38 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:45928 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab3EWBjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 21:39:36 -0400
Date: Thu, 23 May 2013 10:39:34 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Axel Lin <axel.lin@ingics.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] pwm: renesas-tpu: Add missing pwmchip_remove() call
 in tpu_remove()
Message-ID: <20130523013933.GI22608@verge.net.au>
References: <1369057541.11578.1.camel@phoenix>
 <1454213.B1kNpQ6JtX@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1454213.B1kNpQ6JtX@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 03:46:59PM +0200, Laurent Pinchart wrote:
> Hi Axel,
> 
> Thank you for the patch.
> 
> On Monday 20 May 2013 21:45:41 Axel Lin wrote:
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks. I have queued this up for v3.11 in the pinmux branch
of my renesas tree on kernel.org.

> 
> > ---
> >  drivers/pwm/pwm-renesas-tpu.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
> > index 8e6d8d7..319a6fe 100644
> > --- a/drivers/pwm/pwm-renesas-tpu.c
> > +++ b/drivers/pwm/pwm-renesas-tpu.c
> > @@ -432,6 +432,11 @@ static int tpu_remove(struct platform_device *pdev)
> >  {
> >  	struct tpu_device *tpu = platform_get_drvdata(pdev);
> >  	unsigned int i;
> > +	int ret;
> > +
> > +	ret = pwmchip_remove(&tpu->chip);
> > +	if (ret)
> > +		return ret;
> > 
> >  	for (i = 0; i < ARRAY_SIZE(tpu->pwms); ++i) {
> >  		struct tpu_pwm_device *pwm = &tpu->pwms[i];
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
