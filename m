Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbaFRVcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:32:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbaFRVcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:32:41 -0400
Date: Wed, 18 Jun 2014 14:36:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Fred Brooks <frederick.brooks@microchip.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] staging: comedi: ni_daq_700: add AI range and
 input mode switching
Message-ID: <20140618213640.GA10913@kroah.com>
References: <1401362147-5965-3-git-send-email-abbotti@mev.co.uk>
 <1401366566-6209-1-git-send-email-abbotti@mev.co.uk>
 <DC148C5AA1CEBA4E87973D432B1C2D8825E80AF7@P3PWEX4MB008.ex4.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825E80AF7@P3PWEX4MB008.ex4.secureserver.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 04:47:00PM +0000, Hartley Sweeten wrote:
> On Thursday, May 29, 2014 5:29 AM, Ian Abbott wrote:
> > From: Fred Brooks <frederick.brooks@microchip.com>
> >
> > Add support for switching the input range and the single-ended/
> > differential input mode for the AI subdevice.  We needed to clear the
> > FIFO of data before the conversion to handle card mode switching
> > glitches.
> >
> > [ Minor whitespace fixes and driver comment reformatting.  - Ian ]
> >
> > Signed-off-by: Fred Brooks <frederick.brooks@microchip.com>
> > Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> > ---
> > v2: Set authorship to Fred Brooks and updated patch description as
> > suggested by Dan Carpenter.
> > ---
> >  drivers/staging/comedi/drivers/ni_daq_700.c | 53 +++++++++++++++++++++++------
> >  1 file changed, 43 insertions(+), 10 deletions(-)
> 
> Ian,
> 
> I couple nitpicks on this patch but nothing big. Ignore all of these
> comments if you wish.
> 
> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> > diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
> > index 55d80ef..e66c0b9 100644
> > --- a/drivers/staging/comedi/drivers/ni_daq_700.c
> > +++ b/drivers/staging/comedi/drivers/ni_daq_700.c
> > @@ -24,21 +24,30 @@
> >   *   based on ni_daq_dio24 by Daniel Vecino Castel <dvecino@able.es>
> >   * Devices: [National Instruments] PCMCIA DAQ-Card-700 (ni_daq_700)
> >   * Status: works
> > - * Updated: Wed, 19 Sep 2012 12:07:20 +0000
> > + * Updated: Wed, 21 May 2014 12:07:20 +0000
> >   *
> >   * The daqcard-700 appears in Comedi as a  digital I/O subdevice (0) with
> > - * 16 channels and a analog input subdevice (1) with 16 single-ended channels.
> > + * 16 channels and a analog input subdevice (1) with 16 single-ended channels
> > + * or 8 differential channels, and three input ranges.
> >   *
> >   * Digital:  The channel 0 corresponds to the daqcard-700's output
> >   * port, bit 0; channel 8 corresponds to the input port, bit 0.
> >   *
> >   * Digital direction configuration: channels 0-7 output, 8-15 input.
> >   *
> > - * Analog: The input  range is 0 to 4095 for -10 to +10 volts
> > + * Analog: The input  range is 0 to 4095 with a default of -10 to +10 volts.
> > + * Valid ranges:
> > + *       0 for -10 to 10V bipolar
> > + *       1 for -5 to 5V bipolar
> > + *       2 for -2.5 to 2.5V bipolar
> > + *
> >   * IRQ is assigned but not used.
> >   *
> >   * Version 0.1	Original DIO only driver
> >   * Version 0.2	DIO and basic AI analog input support on 16 se channels
> > + * Version 0.3	Add SE or DIFF mode and range switching +-10,+-5,+-2.5
> > + *		Clear the FIFO of data before the conversion to handle card
> > + *		mode switching glitches.
> 
> Is this version information really necessary? 

No, it should all be removed from in-kernel drivers.

> > @@ -260,5 +293,5 @@ module_comedi_pcmcia_driver(daq700_driver, daq700_cs_driver);
> >  MODULE_AUTHOR("Fred Brooks <nsaspook@nsaspook.com>");
> >  MODULE_DESCRIPTION(
> >  	"Comedi driver for National Instruments PCMCIA DAQCard-700 DIO/AI");
> > -MODULE_VERSION("0.2.00");
> > +MODULE_VERSION("0.3.00");
> 
> Is the MODULE_VERSION necessary? The vmk80xx and this driver are the only
> ones that have it.

It should be removed, it makes no sense for in-kernel modules.

I'll take this as-is, but further cleanups are always appreciated :)

thanks,

greg k-h
