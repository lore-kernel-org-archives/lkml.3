Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab3LSEUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 23:20:23 -0500
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:12936
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab3LSEUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 23:20:22 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MY1D7J-08-08U-02
X-M-MSG: 
Date: Thu, 19 Dec 2013 12:00:43 +0800
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>
CC: Roger Quadros <rogerq@ti.com>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: usbtest: Add timetout to simple_io()
Message-ID: <20131219040042.GB19091@hr-dev.amd.com>
References: <1387361411-15139-1-git-send-email-rogerq@ti.com>
 <20131218144603.GA19091@hr-dev.amd.com>
 <20131218163445.GI4970@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131218163445.GI4970@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 10:37:44AM -0600, Felipe Balbi wrote:
> On Wed, Dec 18, 2013 at 10:46:03PM +0800, Huang Rui wrote:
> > Hi Roger,
> > 
> > On Wed, Dec 18, 2013 at 03:40:10PM +0530, Roger Quadros wrote:
> > > Without a timetout some tests e.g. test_halt() can remain stuck forever.
> > > 
> > > Signed-off-by: Roger Quadros <rogerq@ti.com>
> > > Reviewed-by: Felipe Balbi <balbi@ti.com>
> > > ---
> > >  drivers/usb/misc/usbtest.c | 14 +++++++++++---
> > >  1 file changed, 11 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
> > > index b415282..6294e1b 100644
> > > --- a/drivers/usb/misc/usbtest.c
> > > +++ b/drivers/usb/misc/usbtest.c
> > > @@ -10,6 +10,7 @@
> > >  
> > >  #include <linux/usb.h>
> > >  
> > > +#define SIMPLE_IO_TIMEOUT	10000	/* in milliseconds */
> > >  
> > 
> > Only one question, how do you confirm the timeout value?
> 
> dude, it's just a timeout. It could be anything, really. 10 seconds is
> just large enough value that would allow even the slowest scenarios
> (host + device) to complete, while not being so slow that you would
> wanna kill yourself after waiting for such a long time ;-)
> 

OK. I've tested in my side.

Acked-by: Huang Rui <ray.huang@amd.com>


