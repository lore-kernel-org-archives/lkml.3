Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab3GBRPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:15:55 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:47463 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab3GBRPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:15:53 -0400
Message-ID: <51D30AC5.9000701@free-electrons.com>
Date: Tue, 02 Jul 2013 19:15:49 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Jonathan Cameron <jic23@cam.ac.uk>, brian@crystalfontz.com,
        linux-doc@vger.kernel.org, linux-iio@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, jimwall@q.com,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCHv3 2/3] ARM: mxs: cfa10049: Switch bus i2c1 to bitbanging
References: <1372094699-3832-1-git-send-email-alexandre.belloni@free-electrons.com> <51D2BEA1.6010206@free-electrons.com> <51D2DE5B.9060309@free-electrons.com> <201307021833.04282.marex@denx.de>
In-Reply-To: <201307021833.04282.marex@denx.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 18:33, Marek Vasut wrote:
> Dear Alexandre Belloni,
> 
>> On 02/07/2013 13:50, Alexandre Belloni wrote:
>>> On 02/07/2013 13:45, Fabio Estevam wrote:
>>>> Shouldn't this be
>>>>
>>>>          i2c@1 {
>>>>          
>>>>                  reg = <1>; ?
>>>
>>> No, we have 4 devices on that mux and 2 pins to select the muxing.
>>
>> OK, got it working.
>>
>> So, the results:
>>
>> bitbanging:
>>
>> # time cat /sys/bus/iio/devices/iio\:device1/in_voltage0_raw
>> 2637
>> real	0m 0.09s
>> user	0m 0.01s
>> sys	0m 0.01s
>>
>>
>> i2c-mxs PIO mode:
>>
>> # time cat /sys/bus/iio/devices/iio\:device1/in_voltage0_raw
>> [   35.007650] [sched_delayed] sched: RT throttling activated
>> 2627
>> real	0m 7.14s
>> user	0m 0.02s
>> sys	0m 0.01s
>>
>>
>> i2c-mxs PIO mode without LRADC:
>>
>> # time cat /sys/bus/iio/devices/iio\:device1/in_voltage0_raw
>> [   18.007432] [sched_delayed] sched: RT throttling activated
>> 2629
>> real	0m 7.09s
>> user	0m 0.00s
>> sys	0m 0.03s
>>
>>
>> i2c-mxs DMA mode:
>>
>> # time cat /sys/bus/iio/devices/iio\:device1/in_voltage0_raw
>> 2631
>> real	0m 0.12s
>> user	0m 0.01s
>> sys	0m 0.01s
>>
>>
>> It seems fine for me.
> 
> I think I'm getting a little lost in these gazilions of i2c and lradc threads. 
> Can we not create one thread and keep the related stuff in there instead of 
> discussing it all around !?
> 
> Only one question comes to mind with this email -- what do LRADC and I2C have to 
> do with each other here ?
> 

Yeah, sorry, I meant the lradc touchscreen support. This seemed to
trigger the issue for Fabio but as my testing shows, this is not the
case for me, I get the issue with PIO, whether the lradc touchscreen
support is activated or not.

I think Torsten is the one that investigated it the most :

http://www.spinics.net/lists/linux-i2c/msg12619.html


> It'd be nice if someone could summarize on what I should focus and possibly 
> prepare a testcase.
> 

On my setup, it happens on every i2c read that are done in PIO mode.
But, my setup may be a bit unconventional as we are using a i2c gpio muxer.

Regards,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
