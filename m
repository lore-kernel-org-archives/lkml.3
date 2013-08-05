Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3HEQRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:17:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52925 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753157Ab3HEQRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:17:09 -0400
Message-ID: <1375719427.3133.31.camel@joe-AO722>
Subject: Re: [PATCH] trivial: adjust code alignment
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 05 Aug 2013 09:17:07 -0700
In-Reply-To: <20130805160645.GI5051@mwanda>
References: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1375714059-29567-5-git-send-email-Julia.Lawall@lip6.fr>
	 <20130805160645.GI5051@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 19:06 +0300, Dan Carpenter wrote:
> On Mon, Aug 05, 2013 at 04:47:39PM +0200, Julia Lawall wrote:
> > diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
[]
> > @@ -1369,8 +1369,8 @@ static int ov7670_s_exp(struct v4l2_subdev *sd, int value)
> >  	unsigned char com1, com8, aech, aechh;
> >  
> >  	ret = ov7670_read(sd, REG_COM1, &com1) +
> > -		ov7670_read(sd, REG_COM8, &com8);
> > -		ov7670_read(sd, REG_AECHH, &aechh);
> > +	ov7670_read(sd, REG_COM8, &com8);
> > +	ov7670_read(sd, REG_AECHH, &aechh);
> >  	if (ret)
> >  		return ret;
> >  
> 
> The new indenting isn't correct here and anyway the intent was to
> combine all the error codes together and return them as an error
> code jumble.  I'm not a fan of error code jumbles, probably the
> right thing is to check each function call or, barring that, to
> return -EIO.

ov7670_read via i2c_transfer can return a positive # too.
Perhaps all of these should be individually tested for "< 0".


