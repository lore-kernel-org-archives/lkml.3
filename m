Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3GTLZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 07:25:52 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45471 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3GTLZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 07:25:51 -0400
Message-ID: <51EA73BC.8050901@kernel.org>
Date: Sat, 20 Jul 2013 12:25:48 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: Re: [PATCH 00/15] iio: ti_am335x_adc: Add continuous mode take 2
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/18/2013 11:21 PM, Zubair Lutfullah wrote:
> Patches now give correct authorship.
> 
> and checkpatch.pl issues are checked for each patch.
> 
> I hope the actual code bashing can begin now.
> 
> A series of patches that add continuous sampling support
> for the adc drivers for the am335x.
> 
> These apply on top of mfd-next after the recent set of patches
> on this driver by Sebastian Andrzej Siewior
> 
> Tested on the Beaglebone Black running 3.11
> 
> Patil, Rachna (5):
>   MFD: ti_tscadc: disable TSC config registers in adc mode
>   iio: ti_am335x_adc: Fix wrong samples received on 1st read
>   input: ti_tsc: Enable shared IRQ for TSC
>   iio: mfd: input: ti_am335x_adc:Add support for continuous mode
>   MFD: ti_tscadc: ADC Clock check not required
> 
> Russ Dill (10):
>   iio: ti_am335x_adc: Handle set to clear IRQENABLE
>   iio: ti_am335x_adc: Handle set to clear IRQSTATUS
>   iio: ti_am335x_adc: Handle overrun before threshold event
>   iio: ti_am335x_adc: Avoid double threshold event
>   iio: ti_am335x_adc: Also clear threshold event when clearing overrun
>     event
>   iio: ti_am335x_adc: Print error and handle short FIFO events
>   iio: ti_am335x_adc: Fix allocation count of FIFO buffer.
>   iio: ti_am335x_adc: Fix capture operation during resume
>   iio: ti_am335x_adc: Reset and clear overrun status before capture
>   iio: ti_am335x_adc: Properly handle out of memory situation

I am a little irritated by the mess we have here.  Russ has clearly done
a lot of fine work cleaning up the earlier patches.  As a result
we have a series of initial buggy patches and then a series of patches
fixing them again.

As you are submitting these for mainline I would really like it all merged
down into a clean series of clear patches.

Part 1.  Any fixes that are unconnected to the rest of the series.  These will
  then get sent upstream within this cycle.

Part 2. Feature add patch. Here that is basically a single patch adding the
  continous mode support.

It is nice to maintain history and all but I would much rather have something
that is easy to review, with appropriate comments or if people will give
them, sign offs to reflect the various contributions.

Jonathan


> 
>  drivers/iio/adc/ti_am335x_adc.c           |  354 +++++++++++++++++++++++++----
>  drivers/input/touchscreen/ti_am335x_tsc.c |   17 +-
>  drivers/mfd/ti_am335x_tscadc.c            |   30 ++-
>  include/linux/mfd/ti_am335x_tscadc.h      |   27 ++-
>  4 files changed, 366 insertions(+), 62 deletions(-)
> 
