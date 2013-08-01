Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab3HABdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:33:24 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:35105
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112Ab3HABdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:33:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Thu, 1 Aug 2013 09:33:12 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
CC: Peter Chen <hzpeterchen@gmail.com>, Mark Brown <broonie@kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        <kernel@pengutronix.de>, Tejun Heo <htejun@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jeff Garzik <jeff@garzik.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] chipidea: Use devm_request_irq()
Message-ID: <20130801013311.GH8540@nchen-desktop>
References: <20130731090512.GD9858@sirena.org.uk>
 <20130731094434.GC1754@pengutronix.de>
 <20130731095411.GA2810@htj.dyndns.org>
 <20130731111853.GJ9858@sirena.org.uk>
 <20130731113244.GI2810@htj.dyndns.org>
 <20130731115027.GN9858@sirena.org.uk>
 <20130731115527.GR2810@htj.dyndns.org>
 <20130731132708.GQ9858@sirena.org.uk>
 <CAL411-qQm9vgDHswEM6PEvFKAaqd=e3qm-zViUbNztv0tJYa8Q@mail.gmail.com>
 <20130731141512.GU2810@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130731141512.GU2810@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 10:15:12AM -0400, Tejun Heo wrote:
> hello,
> 
> On Wed, Jul 31, 2013 at 09:55:26PM +0800, Peter Chen wrote:
> > I think the main point is we should allocate managed resource which is used
> > at interrupt handler before devm_request_irq, and all resources used
> > at interrupt
> > handler should be managed.
> > 
> > If we use non-managed resource at interrupt handler, but using managed interrupt
> > handler, things still will go wrong if there is an odd (unexpected)
> > interrupt after
> > we finish deactivation at removal.
> 
> In general, applying devm partially isn't a good idea.  It's very easy
> to get into trouble thanks to release order dependency which isn't
> immediately noticeable and there have been actual bugs caused by that.
> The strategies which seem to work are either
> 
> * Convert everything over to devm by wrapping deactivation in a devres
>   callback too.  As long as your init sequence is sane (ie. irq
>   shouldn't be request before things used by irq are ready).
> 
> * Allocate all resources using devres but shut down the execution
>   engine in the remove_one().  Again, as all releases are controlled
>   by devres, you won't have to worry about messing up the release
>   sequencing.
> 

thanks, Tejun. So, Alex and Fabio, this patch may not be suitable currently,
since many resources at both EHCI and device side are non-managed.
-- 

Best Regards,
Peter Chen

