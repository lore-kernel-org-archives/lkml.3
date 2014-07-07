Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaGGH5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 03:57:31 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40302 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaGGH50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 03:57:26 -0400
Date: Mon, 7 Jul 2014 10:57:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: fbdev: sis: init.c:  Cleaning up redundant
 condition is always true
Message-ID: <20140707075709.GI25934@mwanda>
References: <1404422121-11298-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404422121-11298-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 11:15:21PM +0200, Rickard Strandqvist wrote:
> diff --git a/drivers/video/fbdev/sis/init.c b/drivers/video/fbdev/sis/init.c
> index bd40f5e..9e2dd96 100644
> --- a/drivers/video/fbdev/sis/init.c
> +++ b/drivers/video/fbdev/sis/init.c
> @@ -355,12 +355,12 @@ SiS_GetModeID(int VGAEngine, unsigned int VBFlags, int HDisplay, int VDisplay,
>  		}
>  		break;
>  	case 400:
> -		if((!(VBFlags & CRT1_LCDA)) || ((LCDwidth >= 800) && (LCDwidth >= 600))) {
> +		if ((!(VBFlags & CRT1_LCDA)) || (LCDwidth >= 600)) {


It might be that this was supposed to be:

		if((!(VBFlags & CRT1_LCDA)) || ((LCDwidth <= 800) && (LCDwidth >= 600))) {

But why would people write a range from high to low?  That's crazy
people who write backwards code...

The second condition was supposed to do *something* although it's
unclear what.  I would normally say that we should leave the static
checker warning here instead of guessing.  Perhaps add a comment like
/* fixme:  huh?  What's with this nonsense condition? */  But in this
case it's all dead code because LCDwidth is always zero and the code
hasn't changed since 2.6.12 so I don't care.

regards,
dan carpenter

