Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab3HETVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:21:23 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:58440 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3HETVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:21:21 -0400
Date: Mon, 5 Aug 2013 20:21:14 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>, jic23@cam.ac.uk,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, gregkh@linuxfoundation.org,
        Russ.Dill@ti.com
Subject: Re: [PATCH 1/2] input: ti_tsc: Enable shared IRQ for TSC
Message-ID: <20130805192113.GA7041@gmail.com>
References: <1374882674-18403-1-git-send-email-zubair.lutfullah@gmail.com>
 <1374882674-18403-2-git-send-email-zubair.lutfullah@gmail.com>
 <51FE361B.5030900@kernel.org>
 <20130805161256.GA8794@core.coreip.homeip.net>
 <20130805170201.GA4310@gmail.com>
 <20130805174031.GA20093@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805174031.GA20093@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 10:40:31AM -0700, Dmitry Torokhov wrote:
> > 
> > FIFO 1 used only by ADC and FIFO1THRES handler is inside the iio/adc driver
> > FIFO 0 used only by TSC and FIFO0THRES handler is inside the input/touchscreen
> > 
> > Note: These are level interrupts.
> > 
> > I would like some input on how to handle such a situation. 
> 
> It looks like you need to have smart demultiplexing in MFD core of your
> driver instead of relying on shared interrupt handler.
> 
> Another option would be to check "your" bits, handle the data, clear the
> status and then check bits again and return IRQ_NONE instead of
> IRQ_HANDLED if other guys bits are set, but it is way too ugly.
> 
> Thanks.
> 
> -- 
> Dmitry

That is going to make a lot of changes in mfd, input and iio
And should require a separate patch series.

Is it possible to accept the current patches to add continuous mode 
to the ADC side as is before the next merge window?

This issue doesn't disturb each side individually..

I'll look into fixing the IRQs after settling continuous mode.

Thanks
Zubair Lutfullah
