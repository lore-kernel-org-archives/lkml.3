Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3AXTPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:15:19 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:37092 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3AXTPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:15:17 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Doug Anderson <dianders@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        Naveen Krishna <naveenkrishna.ch@gmail.com>
Subject: Re: [PATCH] iio: adc: add exynos5 adc driver under iio framwork
Date: Thu, 24 Jan 2013 20:15:14 +0100
Message-ID: <1523320.h6ZorTqNLc@flatron>
User-Agent: KMail/4.9.5 (Linux/3.7.2-gentoo; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51017B4D.7000105@metafoo.de>
References: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com> <CAD=FV=VRKqeRxvcV1-aQCbu0FoTpMiVVXoNiVEx5SxLe3N_tgQ@mail.gmail.com> <51017B4D.7000105@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 24 of January 2013 19:19:57 Lars-Peter Clausen wrote:
> On 01/24/2013 05:12 PM, Doug Anderson wrote:
> > Lars,
> > 
> > Thank you for your comments / thoughts...
> 
> Hi,
> 
> > On Thu, Jan 24, 2013 at 1:54 AM, Lars-Peter Clausen <lars@metafoo.de> 
wrote:
> >> adc: adc@12D10000 {
> >> 
> >>         #io-channel-cells = <1>;
> >>         io-channel-output-names = "adc1", "adc2", ...;
> >>         
> >>         ncp15wb473@0 {
> >>         
> >>                 compatible = "ntc,ncp15wb473";
> >>                 ...
> >>                 io-channels = <&adc 0>; // First ADC channel
> > 
> > I'm not an expert, but I think the typical way is:
> > * No need to include a handle to &adc.  It's logically our parent.  In
> > a similar way i2c devices don't specify their parent bus--they are
> > just listed under it.
> > * The "0" should be specified with reg = <0>
> 
> The relationship between the IIO sensor device and the consumer device
> is not always a parent child relationship. In this case it makes sense
> to have the ADC as the parent for the thermistors. But for other cases
> this may not be true. E.g. take a touchscreen or power monitoring
> platform device which uses the IIO device to do measurements.

The policy is to use children with reg property only inside a node 
representing a bus controller through which the child device is being 
accessed (like I2C, SPI).

I would see IIO bindings similar to what we have with GPIOs, interrupts or 
regulators, so io-channels = <&iio-controller channel> seems fine (or 
rather iio-channels) with the node under appropriate parent.

> > To implement this I'd imagine that we'll need a new API call, right?
> > In this case the thermistor driver won't know the name of the channel.
> > 
> >  It can find the ADC (the struct device and probably other things) and
> > 
> > knows a channel index.  Am I understanding properly?
> 
> This can be done by adding a new api call, but it would be best if both
> dt and non-dt based consumers can use the same function. I outlined one
> possible solution how this can be done in the previous mail to Naveen.

In case of the solution I mentioned, implementation would be almost 
identical to what is done with GPIOs (see drivers/gpio/gpiolib-of.c).

Best regards,
Tomasz

