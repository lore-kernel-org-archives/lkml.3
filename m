Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116Ab3HNR5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:57:18 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45014 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480Ab3HNR5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:57:15 -0400
Message-ID: <520BD308.7030709@kernel.org>
Date: Wed, 14 Aug 2013 19:57:12 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de, gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 0/4] iio: input: ti_am335x_adc: Add continuous sampling
 support round 5
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll actually look at these later, but please do put a version number
in your cover letter patch subject.
[PATCH V5 0/4] is pretty much the convention to reduce the chance of anyone
looking at the wrong version.

Thanks,

Jonathan

On 08/13/13 21:04, Zubair Lutfullah wrote:
> Round 5 updates. Fixed the define order in the header as guided by Lee.
> 
> Round 4 updates below.
> 
> Note: These apply to the fixes-togreg branch in IIO because of
> a fix on the adc side in there.
> 
> The first few are for input which tweak the TSC driver to
> allow ADC in continuous mode with irqs to work nicely together.
> 
> The last one is for iio which adds continuous mode to the adc side.
> 
> Received feedback on previous series.
> 1. What if IRQs occur together?
> This is handled now. Even if both assert.
> They both work.
> 
> 2. IIO error handling wrong.
> Fixed now.
> 
> 3. Headers wierd in IIO.
> Fixed.
> 
> Apart from that, found a few bugs in continuous mode
> here and there. And squashed them into the same patch.
> 
> Thanks
> Zubair Lutfullah
> 
> Zubair Lutfullah (4):
>   input: ti_am335x_tsc: correct step mask update after IRQ
>   input: ti_am335x_tsc: Increase sequencer delay time
>   input: ti_am335x_tsc: Enable shared IRQ for TSC, add overrun and
>     underflow checks
>   iio: ti_am335x_adc: Add continuous sampling and trigger support
> 
>  drivers/iio/adc/ti_am335x_adc.c           |  353 ++++++++++++++++++++++++-----
>  drivers/input/touchscreen/ti_am335x_tsc.c |   45 +++-
>  include/linux/mfd/ti_am335x_tscadc.h      |   14 ++
>  3 files changed, 342 insertions(+), 70 deletions(-)
> 
