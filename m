Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3HPWTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:19:38 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33058 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3HPWTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:19:36 -0400
Date: Fri, 16 Aug 2013 22:23:53 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de, gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 0/4] iio: input: ti_am335x_adc: Add continuous sampling
 support round 5
Message-ID: <20130816212353.GC2636@gmail.com>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
 <520BD308.7030709@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BD308.7030709@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 07:57:12PM +0100, Jonathan Cameron wrote:
> I'll actually look at these later, but please do put a version number
> in your cover letter patch subject.
> [PATCH V5 0/4] is pretty much the convention to reduce the chance of anyone
> looking at the wrong version.
Noted. 

I actually had round 4/5 at the end of the subjects..

Thanks
Zubair
> 
> Thanks,
> 
> Jonathan
> 
> On 08/13/13 21:04, Zubair Lutfullah wrote:
> > Round 5 updates. Fixed the define order in the header as guided by Lee.
> > 
> > Round 4 updates below.
> > 
> > Note: These apply to the fixes-togreg branch in IIO because of
> > a fix on the adc side in there.
> > 
> > The first few are for input which tweak the TSC driver to
> > allow ADC in continuous mode with irqs to work nicely together.
> > 
> > The last one is for iio which adds continuous mode to the adc side.
> > 
> > Received feedback on previous series.
> > 1. What if IRQs occur together?
> > This is handled now. Even if both assert.
> > They both work.
> > 
> > 2. IIO error handling wrong.
> > Fixed now.
> > 
> > 3. Headers wierd in IIO.
> > Fixed.
> > 
> > Apart from that, found a few bugs in continuous mode
> > here and there. And squashed them into the same patch.
> > 
> > Thanks
> > Zubair Lutfullah
> > 
> > Zubair Lutfullah (4):
> >   input: ti_am335x_tsc: correct step mask update after IRQ
> >   input: ti_am335x_tsc: Increase sequencer delay time
> >   input: ti_am335x_tsc: Enable shared IRQ for TSC, add overrun and
> >     underflow checks
> >   iio: ti_am335x_adc: Add continuous sampling and trigger support
> > 
> >  drivers/iio/adc/ti_am335x_adc.c           |  353 ++++++++++++++++++++++++-----
> >  drivers/input/touchscreen/ti_am335x_tsc.c |   45 +++-
> >  include/linux/mfd/ti_am335x_tscadc.h      |   14 ++
> >  3 files changed, 342 insertions(+), 70 deletions(-)
> > 
