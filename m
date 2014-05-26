Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaEZTjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:39:46 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57582 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaEZTjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:39:45 -0400
Date: Mon, 26 May 2014 21:40:06 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] driver core/platform: don't leak memory allocated
 for dma_mask
Message-ID: <20140526194006.GB23964@lianli>
References: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
 <20140526193046.GJ15585@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526193046.GJ15585@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 26, 2014 at 10:30:46PM +0300, Dan Carpenter wrote:
> On Mon, May 26, 2014 at 06:41:21PM +0200, Emil Goode wrote:
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 9e9227e..dd1fa07 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -166,6 +166,7 @@ EXPORT_SYMBOL_GPL(platform_add_devices);
> >  struct platform_object {
> >  	struct platform_device pdev;
> >  	char name[1];
> > +	u64 dma_mask;
> >  };
> 
> Heh.  No this doesn't work as patch #1.  You have to have name at the
> end of the struct.

Yes I missed that one, obviously the order is important here.

Best regards,

Emil Goode
