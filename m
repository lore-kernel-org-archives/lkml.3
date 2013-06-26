Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881Ab3FZDin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 23:38:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3FZDim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 23:38:42 -0400
Date: Tue, 25 Jun 2013 20:39:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/8] pch_uart: Add uart_clk selection for the MinnowBoard
Message-ID: <20130626033926.GA27165@kroah.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
 <6cc125b9eb85dd3cae4a2496fdb7f0d17b18f930.1372211451.git.dvhart@linux.intel.com>
 <20130626023143.GB23320@kroah.com>
 <1372216578.8177.9.camel@envy.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372216578.8177.9.camel@envy.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 08:16:18PM -0700, Darren Hart wrote:
> On Tue, 2013-06-25 at 19:31 -0700, Greg Kroah-Hartman wrote:
> > On Tue, Jun 25, 2013 at 06:53:22PM -0700, Darren Hart wrote:
> >   
> > >  struct pch_uart_buffer {
> > >  	unsigned char *buf;
> > > @@ -398,6 +399,10 @@ static int pch_uart_get_uartclk(void)
> > >  		    strstr(cmp, "nanoETXexpress-TT")))
> > >  		return NTC1_UARTCLK;
> > >  
> > > +	cmp = dmi_get_system_info(DMI_BOARD_NAME);
> > > +	if (cmp && strstr(cmp, "MinnowBoard"))
> > > +		return MINNOW_UARTCLK;
> > > +
> > 
> > You know, we do have the DMI interface to handle this in a much nicer
> > way instead of just randomly trying different strings over and over
> > until we find one that matches...
> 
> I was aiming for minimal change. Partly because I'm lazy. Partly
> because I don't have all of the impacted hardware to test. Partly
> because I wanted to keep it simple so I could push this to 3.8 stable.

Then you should have marked it for the stable tree by putting the proper
Cc: in the body of the patch...

> I can rewrite this detection to use the DMI interface. Would you allow
> it as a follow-on, to keep the changes to stable minimal?
> 
> Also, I do have a PCI subsystem ID for this particular board which I
> could trigger on, but since that mechanism didn't exist in the driver
> already and the other boards don't do it, I just followed what was
> already there (yeah, so I wrote most of what was already there...
> but.... anyway) :-)
> 
> What do you prefer? Rewrite, then add Minnow, or use this, then
> rewrite?

How about this, which makes it easy to backport, then you fix it up
properly for 3.12?  This comes after my tree is pretty much closed for
3.11, but a simple device id addition like this is acceptable, but I'll
not get to it until after 3.11-rc1 is out...

thanks,

greg k-h
