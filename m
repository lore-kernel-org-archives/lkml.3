Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab3AXSTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:19:05 -0500
Received: from smtp-out-079.synserver.de ([212.40.185.79]:1100 "EHLO
	smtp-out-078.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753503Ab3AXSTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:19:02 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11146
Message-ID: <51017B4D.7000105@metafoo.de>
Date: Thu, 24 Jan 2013 19:19:57 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        Naveen Krishna <naveenkrishna.ch@gmail.com>
Subject: Re: [PATCH] iio: adc: add exynos5 adc driver under iio framwork
References: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com> <1358917086-4148-1-git-send-email-ch.naveen@samsung.com> <50FFDD2A.9040102@metafoo.de> <CAD=FV=VgrpPSLrwwrzFDFLBXTw+-t3C=UwnS6b53o41hxM_AyQ@mail.gmail.com> <510104BD.2020500@metafoo.de> <CAD=FV=VRKqeRxvcV1-aQCbu0FoTpMiVVXoNiVEx5SxLe3N_tgQ@mail.gmail.com>
In-Reply-To: <CAD=FV=VRKqeRxvcV1-aQCbu0FoTpMiVVXoNiVEx5SxLe3N_tgQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 05:12 PM, Doug Anderson wrote:
> Lars,
> 
> Thank you for your comments / thoughts...
> 

Hi,

> 
> On Thu, Jan 24, 2013 at 1:54 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> adc: adc@12D10000 {
>>
>>         #io-channel-cells = <1>;
>>         io-channel-output-names = "adc1", "adc2", ...;
>>
>>         ncp15wb473@0 {
>>                 compatible = "ntc,ncp15wb473";
>>                 ...
>>                 io-channels = <&adc 0>; // First ADC channel
> 
> I'm not an expert, but I think the typical way is:
> * No need to include a handle to &adc.  It's logically our parent.  In
> a similar way i2c devices don't specify their parent bus--they are
> just listed under it.
> * The "0" should be specified with reg = <0>

The relationship between the IIO sensor device and the consumer device is
not always a parent child relationship. In this case it makes sense to have
the ADC as the parent for the thermistors. But for other cases this may not
be true. E.g. take a touchscreen or power monitoring platform device which
uses the IIO device to do measurements.

> 
> To implement this I'd imagine that we'll need a new API call, right?
> In this case the thermistor driver won't know the name of the channel.
>  It can find the ADC (the struct device and probably other things) and
> knows a channel index.  Am I understanding properly?

This can be done by adding a new api call, but it would be best if both dt
and non-dt based consumers can use the same function. I outlined one
possible solution how this can be done in the previous mail to Naveen.

- Lars

