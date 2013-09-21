Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3IUJwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 05:52:04 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55914 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab3IUJwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 05:52:01 -0400
Message-ID: <523D7A65.5010303@kernel.org>
Date: Sat, 21 Sep 2013 11:52:21 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        bigeasy@linutronix.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH V11 0/3] iio: input: ti_am335x_adc: Add continuous sampling
 support
References: <1379571876-12420-1-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1379571876-12420-1-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zubair,

Thanks for persevering with this patch set.  Now this
gets to be the example for dealing with hardware buffer
equipped devices ;)

Applied to the togreg branch of
 git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

On 09/19/13 07:24, Zubair Lutfullah wrote:
> Hi,
> 
> These apply to the togreg branch in iio.
> 
> Round 11
> - Optimized memory usage based on list feedback
> - Changed devm_*_irq to normal *_irq functions
> 
> Round 10 updates
> - Removed devm_free as not needed
> 
> Round 9 updates
> 
> - Removed Trigger.
> - Restructured everything for INDIO_BUFFERED_HARDWARE mode.
> - Threaded IRQ with top/bottom halfs. Top half HW IRQ wakes
> bottom half threaded worker that pushes samples to iio/userspace.
> - Removed some of the patchwork to the driver that was irrelevant to the
> continuous sampling patch.
> 
> Cleanup will be done separately once this goes through.
> Hope these patches meet the mighty kernel standards :)
> 
> Zubair
> 
> Zubair Lutfullah (3):
>   input: ti_am335x_tsc: Enable shared IRQ for TSC
>   iio: ti_am335x_adc: optimize memory usage.
>   iio: ti_am335x_adc: Add continuous sampling support
> 
>  drivers/iio/adc/ti_am335x_adc.c           |  217 ++++++++++++++++++++++++++++-
>  drivers/input/touchscreen/ti_am335x_tsc.c |   12 +-
>  include/linux/mfd/ti_am335x_tscadc.h      |    9 ++
>  3 files changed, 228 insertions(+), 10 deletions(-)
> 
