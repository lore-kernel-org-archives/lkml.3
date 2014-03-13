Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaCMBro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 21:47:44 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:50914 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaCMBrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 21:47:42 -0400
Date: Thu, 13 Mar 2014 10:47:39 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 1/4] serial: sh-sci: Replace printk() by pr_*()
Message-ID: <20140313014739.GO25813@verge.net.au>
References: <1394532680-4264-1-git-send-email-geert@linux-m68k.org>
 <1738100.8MZc8BUIum@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1738100.8MZc8BUIum@avalon>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 11:30:52AM +0100, Laurent Pinchart wrote:
> Hi Geert,
> 
> Thank you for the patches.
> 
> I had patches similar to 3/4 and 4/4 in my tree, that's a sign you're going in 
> the right direction (or at least the direction I consider to be right :-)). 
> For the whole series,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Simon Horman <horms@verge.net.au>

Greg, could you pick up this series?

> On Tuesday 11 March 2014 11:11:17 Geert Uytterhoeven wrote:
> > From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> > 
> > Make banner const while we're at it
> > 
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> > ---
> >  drivers/tty/serial/sh-sci.c |    7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
> > index 7958115e6a51..24ec6ef67984 100644
> > --- a/drivers/tty/serial/sh-sci.c
> > +++ b/drivers/tty/serial/sh-sci.c
> > @@ -428,7 +428,7 @@ static int sci_probe_regmap(struct plat_sci_port *cfg)
> >  		cfg->regtype = SCIx_HSCIF_REGTYPE;
> >  		break;
> >  	default:
> > -		printk(KERN_ERR "Can't probe register map for given port\n");
> > +		pr_err("Can't probe register map for given port\n");
> >  		return -EINVAL;
> >  	}
> > 
> > @@ -2389,8 +2389,7 @@ static inline int sci_probe_earlyprintk(struct
> > platform_device *pdev)
> > 
> >  #endif /* CONFIG_SERIAL_SH_SCI_CONSOLE */
> > 
> > -static char banner[] __initdata =
> > -	KERN_INFO "SuperH (H)SCI(F) driver initialized\n";
> > +static const char banner[] __initconst = "SuperH (H)SCI(F) driver
> > initialized";
> > 
> >  static struct uart_driver sci_uart_driver = {
> >  	.owner		= THIS_MODULE,
> > @@ -2616,7 +2615,7 @@ static int __init sci_init(void)
> >  {
> >  	int ret;
> > 
> > -	printk(banner);
> > +	pr_info("%s\n", banner);
> > 
> >  	ret = uart_register_driver(&sci_uart_driver);
> >  	if (likely(ret == 0)) {
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
