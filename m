Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaEOXBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 19:01:53 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51209 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaEOXBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 19:01:51 -0400
Date: Fri, 16 May 2014 01:01:44 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: clean up error handling
Message-ID: <20140515230144.GA10217@lianli>
References: <1400181871-10325-1-git-send-email-emilgoode@gmail.com>
 <20140515203212.GD8897@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515203212.GD8897@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan,

Thanks for the review and sorry for the late reply.

On Thu, May 15, 2014 at 11:32:13PM +0300, Dan Carpenter wrote:
> On Thu, May 15, 2014 at 09:24:30PM +0200, Emil Goode wrote:
> > If we fail to allocate struct platform_device pdev we
> > dereference it after the goto label err.
> > 
> > I have rearranged the error handling a bit to fix the issue
> > and also make it more clear.
> > 
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> > ---
> >  arch/arm/mach-imx/devices/platform-ipu-core.c |   22 +++++++++++++---------
> >  1 file changed, 13 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
> > index fc4dd7c..14d61d9 100644
> > --- a/arch/arm/mach-imx/devices/platform-ipu-core.c
> > +++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
> > @@ -77,34 +77,38 @@ struct platform_device *__init imx_alloc_mx3_camera(
> >  
> >  	pdev = platform_device_alloc("mx3-camera", 0);
> >  	if (!pdev)
> > -		goto err;
> > +		return ERR_PTR(ret);
> 
> It's more readable to say "return ERR_PTR(-ENOMEM);".

I think so to, will change this one but still use the ret variable at the
bottom of the function.

> 
> This patch is great but the subject should say "fix" and not "clean up"
> since it fixes a NULL dereference bug.  The people who call their
> checkpatch.pl clean ups "fixes" are also doing it wrong but those are
> newbies and not worth educating.

I agree, it's a bug fix and not a clean up.

Will resend tomorrow.

Best regards,

Emil Goode

> 
> regards,
> dan carpenter
> 
