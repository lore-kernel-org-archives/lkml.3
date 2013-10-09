Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab3JIJSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:18:42 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2686 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3JIJSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:18:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 09 Oct 2013 02:14:30 -0700
Message-ID: <5255254D.4090108@nvidia.com>
Date: Wed, 9 Oct 2013 15:13:41 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Nishanth Menon <nm@ti.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        J Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH V3] clk: palmas: add clock driver for palmas
References: <1381238480-18852-1-git-send-email-ldewangan@nvidia.com> <525408B3.1000107@ti.com> <5254193A.70104@nvidia.com> <20131008152812.GA4981@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131008152812.GA4981@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 October 2013 08:58 PM, Mark Rutland wrote:
> On Tue, Oct 08, 2013 at 03:39:54PM +0100, Laxman Dewangan wrote:
>>
>>>> +
>>>> +     Optional subnode properties:
>>>> +     ti,clock-boot-enable: Enable clock at the time of booting.
>>> Dumb question: Why is this needed? should'nt relevant drivers do a
>>> clk_get to enable the relevant clocks?
>> If some board needs this clock to be always available for rest of system
>> to work without any specific driver then this flag is useful.
> Do we _actually_ need this right now, or is this hypothetical?
>
> If we don't need it now, remove it. If you think we need it know, please
> describe exactly why (i.e. what device needs the clock to work, why does
> this affect the rest of the board if we don't ahve a driver for that
> device, why don't we just write a driver for that device).
>

Ok, I will remove it. Going with nothing free of cost for the 
driver/system and client need to call the proper APIs.

>>
>>>> +     ti,external-sleep-control: The clock is enable/disabled by state
>>>> +             of external enable input pins ENABLE, ENABLE2 and NSLEEP.
>>>> +             The valid value for the external pins are:
>>>> +                     1 for ENABLE1
>>>> +                     2 for ENABLE2
>>>> +                     3 for NSLEEP.
> I asked this on the last version (before having noticed this one). What
> actually drives those pins to control the clock(s)?
>
> Is this for setting the clock to be controlled by the external pin, or
> is the clock hard-wired to a particular pin?
>

This is for setting the clock to be controlled by the external pin.

