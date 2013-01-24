Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab3AXT2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:28:51 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:59567 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754939Ab3AXT2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:28:48 -0500
Message-ID: <51018BC7.20100@metafoo.de>
Date: Thu, 24 Jan 2013 20:30:15 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Doug Anderson <dianders@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        Naveen Krishna <naveenkrishna.ch@gmail.com>
Subject: Re: [PATCH] iio: adc: add exynos5 adc driver under iio framwork
References: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com> <CAD=FV=VRKqeRxvcV1-aQCbu0FoTpMiVVXoNiVEx5SxLe3N_tgQ@mail.gmail.com> <51017B4D.7000105@metafoo.de> <1523320.h6ZorTqNLc@flatron>
In-Reply-To: <1523320.h6ZorTqNLc@flatron>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 08:15 PM, Tomasz Figa wrote:
> Hi,
> 
> On Thursday 24 of January 2013 19:19:57 Lars-Peter Clausen wrote:
>> On 01/24/2013 05:12 PM, Doug Anderson wrote:
>>> Lars,
>>>
>>> Thank you for your comments / thoughts...
>>
>> Hi,
>>
>>> On Thu, Jan 24, 2013 at 1:54 AM, Lars-Peter Clausen <lars@metafoo.de> 
> wrote:
>>>> adc: adc@12D10000 {
>>>>
>>>>         #io-channel-cells = <1>;
>>>>         io-channel-output-names = "adc1", "adc2", ...;
>>>>         
>>>>         ncp15wb473@0 {
>>>>         
>>>>                 compatible = "ntc,ncp15wb473";
>>>>                 ...
>>>>                 io-channels = <&adc 0>; // First ADC channel
>>>
>>> I'm not an expert, but I think the typical way is:
>>> * No need to include a handle to &adc.  It's logically our parent.  In
>>> a similar way i2c devices don't specify their parent bus--they are
>>> just listed under it.
>>> * The "0" should be specified with reg = <0>
>>
>> The relationship between the IIO sensor device and the consumer device
>> is not always a parent child relationship. In this case it makes sense
>> to have the ADC as the parent for the thermistors. But for other cases
>> this may not be true. E.g. take a touchscreen or power monitoring
>> platform device which uses the IIO device to do measurements.
> 
> The policy is to use children with reg property only inside a node 
> representing a bus controller through which the child device is being 
> accessed (like I2C, SPI).
> 
> I would see IIO bindings similar to what we have with GPIOs, interrupts or 
> regulators, so io-channels = <&iio-controller channel> seems fine (or 
> rather iio-channels) with the node under appropriate parent.

IIO is a very Linux specific term, the device tree bindings should be as OS
agnostic as possible, so io-channels is probably the better term.


> 
>>> To implement this I'd imagine that we'll need a new API call, right?
>>> In this case the thermistor driver won't know the name of the channel.
>>>
>>>  It can find the ADC (the struct device and probably other things) and
>>>
>>> knows a channel index.  Am I understanding properly?
>>
>> This can be done by adding a new api call, but it would be best if both
>> dt and non-dt based consumers can use the same function. I outlined one
>> possible solution how this can be done in the previous mail to Naveen.
> 
> In case of the solution I mentioned, implementation would be almost 
> identical to what is done with GPIOs (see drivers/gpio/gpiolib-of.c).

Although similar to the GPIO bindings, the clk bindings are in my opinion an
even better example.

- Lars
