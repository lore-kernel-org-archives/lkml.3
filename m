Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3FYVq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:46:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38913 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab3FYVq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:46:27 -0400
Message-ID: <51CA0FB0.7090608@wwwdotorg.org>
Date: Tue, 25 Jun 2013 15:46:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Heiko_St=FC?= =?ISO-8859-1?Q?bner?= 
	<heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 3/4] pinctrl: remove slew-rate parameter from tz1090
References: <201306251455.01540.heiko@sntech.de> <201306251456.36499.heiko@sntech.de> <51C99581.2010403@imgtec.com> <CACRpkdaVsKCNzQ9zAG5DXfDO2BFpcCzw5VbmARazOrXCW1kmeQ@mail.gmail.com> <51C9AFC4.1020305@imgtec.com>
In-Reply-To: <51C9AFC4.1020305@imgtec.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 08:57 AM, James Hogan wrote:
> On 25/06/13 14:22, Linus Walleij wrote:
>> Can't we just try to come up with a patch that nails down the meaning of
>> slew rate in some meaningful manner then?
>>
>> So according to:
>> http://en.wikipedia.org/wiki/Slew_rate
>> a proper expression for slew rate would be dV/dt i.e.
>> something like microvolts per microsecond (which then just
>> becomes volts/second).
>>
>> What we need to figure out is what range will be applicable within
>> reasonable doubt for current scenarios and the next few years.
>>
>> What are your datasheets specifying here, and what would be
>> a proper measure?
> 
> My datasheet says:
> 
> 0: slow (half frequency)
> 1: fast
> 
> I just got a reply back from a hardware engineer, who said that the
> relationship with the actual volts/usec will depend on both the drive
> strength and the load on the pad, and that a definite answer probably
> requires running a simulation.

Tegra is similar here. The docs just say (for a 2-bit field expressed in
binary) "Code 11 is the least slewing of the signal, code 00 is the
highest slewing of the signal".

I'm not sure that a generic parameter actually needs specific units. Why
can't we simply specify the units as HW-defined, even while using a
standardized DT property name and kernel-internal enum to represent the
concept of slew rate? Even the order of whether 0 or 3 is highest or
lowest need not be mandated by the spec?

Note also that Tegra has separate rising and falling slew-rate
configuration.

And the slew rate is influenced by a "low-power mode" setting.

And as for James, I imagine the actual dV/dT is influenced by the
voltage on the IO rail for a particular board, since I'm pretty sure we
have some IOs that can operate at multiple different voltages, simply
based on whatever voltage is supplied for that pin/block's VDD.
