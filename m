Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3IVEmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 00:42:32 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34032 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3IVEma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 00:42:30 -0400
Date: Sun, 22 Sep 2013 09:42:16 +0500
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH V11 0/3] iio: input: ti_am335x_adc: Add continuous
 sampling support
Message-ID: <20130922044214.GA2989@gmail.com>
References: <1379571876-12420-1-git-send-email-zubair.lutfullah@gmail.com>
 <523D7A65.5010303@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523D7A65.5010303@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 11:52:21AM +0100, Jonathan Cameron wrote:
> Hi Zubair,
> 
> Thanks for persevering with this patch set.  Now this
> gets to be the example for dealing with hardware buffer
> equipped devices ;)
> 
> Applied to the togreg branch of
>  git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

Thank-you very much for the quick feedbacks and accepting these patches!
:)

Zubair

> 
> On 09/19/13 07:24, Zubair Lutfullah wrote:
> > Hi,
> > 
> > These apply to the togreg branch in iio.
> > 
> > Round 11
> > - Optimized memory usage based on list feedback
> > - Changed devm_*_irq to normal *_irq functions
> > 
> > Round 10 updates
> > - Removed devm_free as not needed
> > 
> > Round 9 updates
> > 
> > - Removed Trigger.
> > - Restructured everything for INDIO_BUFFERED_HARDWARE mode.
> > - Threaded IRQ with top/bottom halfs. Top half HW IRQ wakes
> > bottom half threaded worker that pushes samples to iio/userspace.
> > - Removed some of the patchwork to the driver that was irrelevant to the
> > continuous sampling patch.
> > 
> > Cleanup will be done separately once this goes through.
> > Hope these patches meet the mighty kernel standards :)
> > 
> > Zubair
> > 
> > Zubair Lutfullah (3):
> >   input: ti_am335x_tsc: Enable shared IRQ for TSC
> >   iio: ti_am335x_adc: optimize memory usage.
> >   iio: ti_am335x_adc: Add continuous sampling support
> > 
> >  drivers/iio/adc/ti_am335x_adc.c           |  217 ++++++++++++++++++++++++++++-
> >  drivers/input/touchscreen/ti_am335x_tsc.c |   12 +-
> >  include/linux/mfd/ti_am335x_tscadc.h      |    9 ++
> >  3 files changed, 228 insertions(+), 10 deletions(-)
> > 
