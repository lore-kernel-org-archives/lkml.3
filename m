Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbaIJMaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 08:30:01 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51207 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750734AbaIJMaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 08:30:00 -0400
Date: Wed, 10 Sep 2014 15:29:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maciej Matraszek <m.matraszek@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] [media] v4l2-common: fix overflow in
 v4l_bound_align_image()
Message-ID: <20140910122953.GA2939@valkosipuli.retiisi.org.uk>
References: <1410275801-17627-1-git-send-email-m.matraszek@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410275801-17627-1-git-send-email-m.matraszek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

Thanks for the patch!

On Tue, Sep 09, 2014 at 05:16:41PM +0200, Maciej Matraszek wrote:
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index ccaa38f65cf1..506cf8b7763b 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -435,16 +435,13 @@ static unsigned int clamp_align(unsigned int x, unsigned int min,
>  	/* Bits that must be zero to be aligned */
>  	unsigned int mask = ~((1 << align) - 1);
>  
> +	/* Clamp to aligned min and max */
> +	x = clamp_t(unsigned int, x, (min + ~mask) & mask, max & mask);

I think you could use just clamp() since all the arguments are unsigned int.
With that considered,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +
>  	/* Round to nearest aligned value */
>  	if (align)
>  		x = (x + (1 << (align - 1))) & mask;
> 
> -	/* Clamp to aligned value of min and max */
> -	if (x < min)
> -		x = (min + ~mask) & mask;
> -	else if (x > max)
> -		x = max & mask;
> -
>  	return x;
>  }
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
