Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab3BMODw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:03:52 -0500
Received: from smtp-out-084.synserver.de ([212.40.185.84]:1137 "EHLO
	smtp-out-083.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757353Ab3BMODu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:03:50 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16015
Message-ID: <511B9D95.2030803@metafoo.de>
Date: Wed, 13 Feb 2013 15:05:09 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
CC: Guenter Roeck <linux@roeck-us.net>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        dianders@chromium.org, gregkh@linuxfoundation.org
Subject: Re: iio: adc: add exynos5 adc driver under iio framwork
References: <1358917086-4148-1-git-send-email-ch.naveen@samsung.com> <20130212210732.GA8634@roeck-us.net> <CAHfPSqCwqD2gzB9eiTi1hSQvRgwbsjp9NfEb3RKpy+_+DbdhzQ@mail.gmail.com> <CAHfPSqAJN8C6d6Oa=1UDpJ+hTXbEOGBio4Ob__ZphsKq=Rvppg@mail.gmail.com> <511B9575.1050506@metafoo.de> <CAHfPSqD3-sxJANEznbuvL0in4ObPSStgCJHVLucMdzz-jVa1Fw@mail.gmail.com>
In-Reply-To: <CAHfPSqD3-sxJANEznbuvL0in4ObPSStgCJHVLucMdzz-jVa1Fw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 02:53 PM, Naveen Krishna Ch wrote:
[...]
>>> ADC driver will use of_platform_populate() to populate the child nodes
>>> (ntc thermistors in my case)
>>>
>>> I've modified the NTC driver to support DT. in probe
>>> chan = iio_channel_get(&pdev->dev, "adcX");
>>> and using "id" field to use respective ADC channel to do the raw_read()
>>
>> The beauty of the interface is that the consumer doesn't need to know the
>> number of the channel it is using. This is already fully described in the
>> io-channels property. Since you only have one channel per consumer just use
>>
>>         iio_chanel_get(&pdev->dev, NULL)
> Right this helped me get the channels properly.
> 
> I've a doubt in the driver posted at https://lkml.org/lkml/2013/1/24/2
> i don't need to use this anymore right use iio_map_array_register() Right.
> 
> Thats so simple then.. Thanks

Yes, if you are using devicetree you don't need to use
iio_map_array_register() anymore :)

- Lars

