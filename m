Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab3CLPba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:31:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39288 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211Ab3CLPb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:31:28 -0400
Message-ID: <513F47B4.2060004@ti.com>
Date: Tue, 12 Mar 2013 17:20:20 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: <balbi@ti.com>, <tony@atomide.com>, <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        "Ujfalusi, Peter" <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 1/8] usb: phy: nop: Add some parameters to platform data
References: <1363087466-32444-1-git-send-email-rogerq@ti.com> <1363087466-32444-2-git-send-email-rogerq@ti.com> <513F177D.40500@pengutronix.de> <513F37DD.9030301@ti.com> <513F38DF.5040404@pengutronix.de> <513F3B7E.8000002@ti.com> <513F3EF0.3030609@pengutronix.de>
In-Reply-To: <513F3EF0.3030609@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 04:42 PM, Marc Kleine-Budde wrote:
> On 03/12/2013 03:28 PM, Roger Quadros wrote:
>> On 03/12/2013 04:17 PM, Marc Kleine-Budde wrote:
>>> On 03/12/2013 03:12 PM, Roger Quadros wrote:
>>>> On 03/12/2013 01:54 PM, Marc Kleine-Budde wrote:
>>>>> On 03/12/2013 12:24 PM, Roger Quadros wrote:
>>>>>> Add clk_rate parameter to platform data. If supplied, the
>>>>>> NOP phy driver will program the clock to that rate during probe.
>>>>>>
>>>>>> Also add 2 flags, needs_vcc and needs_reset.
>>>>>> If the flag is set and the regulator couldn't be found
>>>>>> then the driver will bail out with -EPROBE_DEFER.
>>>>>
>>>>> Is there a platform which fills out pdata.needs_vcc and
>>>>> pdata.needs_reset? IMHO it makes no sense to add features for the non DT
>>>>> case, if there isn't any user for it.
>>>>>
>>>>
>>>> There can be a user in the non DT case as well. Consider the following example:
>>>
>>> I'm just saying, let the implementation up to a real user for the non DT
>>> case. Beagleboard is ARM and there's no point of implementing non DT
>>> fall backs for ARM, IMHO.
>>>
>>
>> Why do you say so?
>>
>> It doesn't depend on the CPU architecture. It depends on how the board designer
>> wired the board. A non ARM platform could also face the same problem as beagle.
> 
> Using -EPROBE_DEFER ist the way to solve the problem.

did you mean isn't? If you did then what is the other option?
> 
>> It is not a non DT fallback. I believe many are still using non DT boot and it
>> needs to work at least till we move all functionality to purely DT.
> 
> From my point of view, it makes no sense today to implement new features
> which have a fallback for the non-DT case, if there isn't a real user of
> this feature. So IMHO don't add needs_vcc and needs_reset flags to the
> pdata, just take the information from the DT. As soon as there is a
> non-DT user of this feature she/he can implement it or even better
> switch to DT.

Adding Peter to the loop. I faintly remember him mentioning this issue before
for beagle. We really need the deferred probe mechanism or we need to resort
to device registering order.

The first user for needs_vcc flag will be the beagleboard file. I just didn't
implement it in this patch [1].

On second thoughts, since [1] does work on beagleboard without requiring the
needs_vcc flag, I think we can just live without it.

Felipe, Peter, what do you think?

cheers,
-roger

[1] https://lkml.org/lkml/2013/3/12/244
