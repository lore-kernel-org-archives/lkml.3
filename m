Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736Ab3GSQXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:23:21 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.194]:56342 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760643Ab3GSQXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:23:18 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-13.tower-46.messagelabs.com!1374250995!30543641!5
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <51E967D8.8020001@digi.com>
Date: Fri, 19 Jul 2013 18:22:48 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2 5/5] iio: mxs-lradc: add write_raw function to modify
 scale
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com> <201307191639.01240.marex@denx.de> <51E95BEC.5080703@digi.com> <201307191817.27102.marex@denx.de>
In-Reply-To: <201307191817.27102.marex@denx.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Marek,

On 07/19/2013 06:17 PM, Marek Vasut wrote:
>> Here you have three entries per channel:
>> in_voltageX_raw		-> the sample raw value
>> in_voltageX_scale	-> the scale to multiply the raw value to get the
> voltage
>> in mV in_voltageX_scale_available -> lists the available scales of the
>> channel
>>
>> For example for channel 0:
>>
>> # cat in_voltage0_scale_available
>> 0.451660156 0.903320312	(two scales available, first with divider by two
>> disabled, second with divider by two enabled)
>>
>> # cat in_voltage0_scale
>> 0.451660156			(divider by two is currently disabled)
>>
>> # cat in_voltage0_raw		(shows measured value)
>> 1000
>>
>> If you multiply the value by the scale you get: 1000 * 0.451660156 = 451.6
>> mV
>>
>> # echo 0.903320312 > in_voltage0_scale	(enables the divider by two)
>
> Ok, so I have to remember this value : '0.903320312' in case I want to enable
> divide-by-two functionality?

No you don't. That's why there is a 'in_voltage_scale_available' that lists the 
available values.

> Hmmmm ... why would this interface not work:
> echo 2 > in_voltage0_scale
>
> or
>
> echo 1 > in_voltage0_scale

An easy thing like that is what I first submitted, but it was rejected and I was told 
to use the scale_available descriptor instead, which is the common interface the rest 
of drivers use.

Best regards,
--
Hector Palacios
