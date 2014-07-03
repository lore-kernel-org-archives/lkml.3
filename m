Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbaGCUve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:51:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaGCUvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:51:32 -0400
Date: Thu, 3 Jul 2014 13:55:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Federico Vaga <federico.vaga@cern.ch>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipoctal: request_irq after configuration
Message-ID: <20140703205549.GA11109@kroah.com>
References: <1404377638-23387-1-git-send-email-federico.vaga@cern.ch>
 <1404377815.4537.20.camel@fourier>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404377815.4537.20.camel@fourier>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 10:56:55AM +0200, Samuel Iglesias Gonsálvez wrote:
> On Thu, 2014-07-03 at 10:53 +0200, Federico Vaga wrote:
> > The request for an IRQ handler must be done after whole configuration. This
> > was not the case for this driver which request the IRQ in the middle of
> > the configuration. Sometimes, it happens that something is not completely
> > configured, we recieve an interrupt thus we stumble into troubles in the
> > IRQ handler.
> > 
> > Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
> > ---
> >  drivers/ipack/devices/ipoctal.c |   15 ++++++++-------
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
> > index a7ec6f9..72fd761 100644
> > --- a/drivers/ipack/devices/ipoctal.c
> > +++ b/drivers/ipack/devices/ipoctal.c
> > @@ -344,13 +344,6 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
> >  			 &block_regs[i].w.imr);
> >  	}
> >  
> > -	/*
> > -	 * IP-OCTAL has different addresses to copy its IRQ vector.
> > -	 * Depending of the carrier these addresses are accesible or not.
> > -	 * More info in the datasheet.
> > -	 */
> > -	ipoctal->dev->bus->ops->request_irq(ipoctal->dev,
> > -				       ipoctal_irq_handler, ipoctal);
> >  	/* Dummy write */
> >  	iowrite8(1, ipoctal->mem8_space + 1);
> >  
> > @@ -411,6 +404,14 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
> >  		dev_set_drvdata(tty_dev, channel);
> >  	}
> >  
> > +	/*
> > +	 * IP-OCTAL has different addresses to copy its IRQ vector.
> > +	 * Depending of the carrier these addresses are accesible or not.
> > +	 * More info in the datasheet.
> > +	 */
> > +	ipoctal->dev->bus->ops->request_irq(ipoctal->dev,
> > +				       ipoctal_irq_handler, ipoctal);
> > +
> >  	return 0;
> >  }
> >  
> 
> Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> 
> Greg, Would you mind picking this patch through your driver-core tree?
> Together with "ipoctal: protect only the real critical section" patch.

Ok, will do, thanks.

greg k-h
