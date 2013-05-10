Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab3EJR5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 13:57:34 -0400
Received: from sauhun.de ([89.238.76.85]:55849 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab3EJR5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 13:57:32 -0400
Date: Fri, 10 May 2013 19:58:54 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [RFC 27/42] drivers/tty/serial: don't check resource with
 devm_ioremap_resource
Message-ID: <20130510175850.GB2912@katana>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-28-git-send-email-wsa@the-dreams.de>
 <20130510152636.GJ11227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510152636.GJ11227@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 08:26:36AM -0700, Greg Kroah-Hartman wrote:
> On Fri, May 10, 2013 at 10:17:12AM +0200, Wolfram Sang wrote:
> > devm_ioremap_resource does sanity checks on the given resource. No need to
> > duplicate this in the driver.
> > 
> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> > ---
> >  drivers/tty/serial/serial-tegra.c |    6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
> > index 9799d04..9570b55 100644
> > --- a/drivers/tty/serial/serial-tegra.c
> > +++ b/drivers/tty/serial/serial-tegra.c
> > @@ -1295,13 +1295,9 @@ static int tegra_uart_probe(struct platform_device *pdev)
> >  	tup->cdata = cdata;
> >  
> >  	platform_set_drvdata(pdev, tup);
> > -	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > -	if (!resource) {
> > -		dev_err(&pdev->dev, "No IO memory resource\n");
> > -		return -ENODEV;
> > -	}
> >  
> >  	u->mapbase = resource->start;
> > +	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> 
> You need to look at your scripts, as again, this is totally wrong.

Yes, brown paper bag mistake :( Will fix!

