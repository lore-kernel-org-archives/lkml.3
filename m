Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3HEQHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:07:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20039 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3HEQHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:07:01 -0400
Date: Mon, 5 Aug 2013 19:06:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: adjust code alignment
Message-ID: <20130805160645.GI5051@mwanda>
References: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr>
 <1375714059-29567-5-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375714059-29567-5-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 04:47:39PM +0200, Julia Lawall wrote:
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index e8a1ce2..4a5a5dc 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -1369,8 +1369,8 @@ static int ov7670_s_exp(struct v4l2_subdev *sd, int value)
>  	unsigned char com1, com8, aech, aechh;
>  
>  	ret = ov7670_read(sd, REG_COM1, &com1) +
> -		ov7670_read(sd, REG_COM8, &com8);
> -		ov7670_read(sd, REG_AECHH, &aechh);
> +	ov7670_read(sd, REG_COM8, &com8);
> +	ov7670_read(sd, REG_AECHH, &aechh);
>  	if (ret)
>  		return ret;
>  

The new indenting isn't correct here and anyway the intent was to
combine all the error codes together and return them as an error
code jumble.  I'm not a fan of error code jumbles, probably the
right thing is to check each function call or, barring that, to
return -EIO.

regards,
dan carpenter

