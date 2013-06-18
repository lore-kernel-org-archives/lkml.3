Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab3FRMbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:31:46 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:56200 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3FRMbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:31:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] clocksource: sh_cmt: Use devm_* managed helpers
Date: Tue, 18 Jun 2013 14:31:58 +0200
Message-ID: <2566074.m8COktZgTy@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CAK9yfHwq_OC6s5Lvh6j5RP5xCTzgkWxFLrUq7_5i_7gPfCDTXQ@mail.gmail.com>
References: <1371553171-23530-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAK9yfHwq_OC6s5Lvh6j5RP5xCTzgkWxFLrUq7_5i_7gPfCDTXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On Tuesday 18 June 2013 17:13:37 Sachin Kamat wrote:
> On 18 June 2013 16:29, Laurent Pinchart wrote:
> > This simplifies the main error path by getting rid of it.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/clocksource/sh_cmt.c | 40 ++++++++++++++-------------------------
> >  1 file changed, 14 insertions(+), 26 deletions(-)
> > 
> > The patch is based on top of renesas-next-20130618 plus Magnus'
> > "clocksource: sh_cmt: 32-bit control register support" patch.
> > 
> > diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
> > index 0965e98..7001e4d 100644
> > --- a/drivers/clocksource/sh_cmt.c
> > +++ b/drivers/clocksource/sh_cmt.c

[snip]

> > @@ -703,23 +701,23 @@ static int sh_cmt_setup(struct sh_cmt_priv *p,
> > struct platform_device *pdev)> 
> >         irq = platform_get_irq(p->pdev, 0);
> >         if (irq < 0) {
> >                 dev_err(&p->pdev->dev, "failed to get irq\n");
> > -               goto err0;
> > +               return -ENXIO;
> >         }
> >         
> >         /* map memory, let mapbase point to our channel */
> > -       p->mapbase = ioremap_nocache(res->start, resource_size(res));
> > +       p->mapbase = devm_ioremap_resource(&pdev->dev, res);
> >         if (p->mapbase == NULL) {
> 
> You should check for  IS_ERR (p->mapbase) and return PTR_ERR(p->mapbase)
> 
> >                 dev_err(&p->pdev->dev, "failed to remap I/O memory\n");
> 
> This error message is not required as devm_ioremap_resource prints its own.

Oops, my bad. I'll fix that and resubmit.

-- 
Regards,

Laurent Pinchart

