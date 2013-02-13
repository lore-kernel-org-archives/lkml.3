Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876Ab3BMPuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:50:40 -0500
Received: from mail.active-venture.com ([67.228.131.205]:60319 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759762Ab3BMPui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:50:38 -0500
X-Originating-IP: 108.223.40.66
Date: Wed, 13 Feb 2013 07:51:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        dianders@chromium.org, gregkh@linuxfoundation.org, lars@metafoo.de
Subject: Re: iio: adc: add exynos5 adc driver under iio framwork
Message-ID: <20130213155100.GA7198@roeck-us.net>
References: <1358917086-4148-1-git-send-email-ch.naveen@samsung.com>
 <20130212210732.GA8634@roeck-us.net>
 <CAHfPSqCwqD2gzB9eiTi1hSQvRgwbsjp9NfEb3RKpy+_+DbdhzQ@mail.gmail.com>
 <CAHfPSqAJN8C6d6Oa=1UDpJ+hTXbEOGBio4Ob__ZphsKq=Rvppg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHfPSqAJN8C6d6Oa=1UDpJ+hTXbEOGBio4Ob__ZphsKq=Rvppg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 06:46:01PM +0530, Naveen Krishna Ch wrote:
[ ... ]
> 
> Hello Guenter,
> 
> I've rebase my adc driver on top of your (OF for IIO patch)
> 
> My setup is like the below one. kindly, help me find the right device
> tree node params
> 
> One ADC controller with 8 channels,
>   4 NTC thermistors are connected to channel 3, 4, 5 and 6 of ADC respectively
> 
> ADC ch - 0
> ADC ch - 1
> ADC ch - 2
> ADC ch - 3 ------------------NTC
> ADC ch - 4 ------------------NTC
> ADC ch - 5 ------------------NTC
> ADC ch - 6 ------------------NTC
> ADC ch - 7
> 
> I've started off with something like this.
> 
>         adc0: adc@12D10000 {
>                 compatible = "samsung,exynos5250-adc";
>                 reg = <0x12D10000 0x100>;
>                 interrupts = <0 106 0>;
>                 #io-channel-cells = <1>;
>         };
> 
>         adc0: adc@12D10000 {
>                 vdd-supply = <&buck5_reg>;
> 
>                 ncp15wb473@0 {
>                         compatible = "ntc,ncp15wb473";
>                         io-channels = <&adc0 3>;
>                         io-channel-names = "adc3";
>                         pullup-uV = <1800000>;
>                         pullup-ohm = <47000>;
>                         pulldown-ohm = <0>;
>                         id = <3>;
>                 };
> 
>                 ncp15wb473@1 {
>                         compatible = "ntc,ncp15wb473";
>                         pullup-uV = <1800000>;
>                         pullup-ohm = <47000>;
>                         pulldown-ohm = <0>;
>                         io-channels = <&adc0 4>;
>                         io-channel-names = "adc4";
>                         id = <4>;
>                 };
>                 ncp15wb473@2 {
>                         compatible = "ntc,ncp15wb473";
>                         pullup-uV = <1800000>;
>                         pullup-ohm = <47000>;
>                         pulldown-ohm = <0>;
>                         io-channels = <&adc0 5>;
>                         io-channel-names = "adc5";
>                         id = <5>;
>                 };
>                 ncp15wb473@3 {
>                         compatible = "ntc,ncp15wb473";
>                         pullup-uV = <1800000>;
>                         pullup-ohm = <47000>;
>                         pulldown-ohm = <0>;
>                         io-channels = <&adc0 6>;
>                         io-channel-names = "adc6";
>                         id = <6>;
>                 };
>         };
> 
> ADC driver will use of_platform_populate() to populate the child nodes
> (ntc thermistors in my case)
> 
> I've modified the NTC driver to support DT. in probe
> chan = iio_channel_get(&pdev->dev, "adcX");
> and using "id" field to use respective ADC channel to do the raw_read()
> 
> Issue:
> 1. I get weird device names for thermistors starting from ncp15wb473.2
> to ncp15wb473.5

I noticed that device IDs and names created when OF is active are sometimes
not as one would expect. I never managed to get the device IDs I tried to
configure. Ultimately, it did not matter and I never bothered to track it down.

Guenter
