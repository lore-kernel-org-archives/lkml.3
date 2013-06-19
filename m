Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934735Ab3FSMfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:35:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44331 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934022Ab3FSMfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:35:30 -0400
Message-ID: <51C1A55E.9040500@ti.com>
Date: Wed, 19 Jun 2013 07:34:38 -0500
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Roger Quadros <rogerq@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ARM: dts: omap4-panda: Add USB Host support
References: <1371571487-14389-1-git-send-email-rogerq@ti.com> <1371571487-14389-2-git-send-email-rogerq@ti.com> <51C106A1.9030001@ti.com> <51C15F7E.5020305@ti.com> <20130619074605.GW5523@atomide.com> <51C183AC.8040801@ti.com> <20130619122715.GA5523@atomide.com>
In-Reply-To: <20130619122715.GA5523@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 06/19/2013 07:27 AM, Tony Lindgren wrote:
> * Benoit Cousson <b-cousson@ti.com> [130619 03:17]:
>> On 06/19/2013 02:46 AM, Tony Lindgren wrote:
>>>
>>> We have a similar issue with the MMC1 PBIAS. I think in the long run we
>>> should expand regulator (and possibly pinctrl) framework(s) to handle
>>> comparators. We could just assume that a comparatator is a regulator,
>>> and have a comparator binding that just uses the regulator code.
>>
>> In the case of pbias, the pinctrl seems to be a much better fit for
>> my point of view. pinctrl can handle pin configuration and this is
>> what the pbias is in the case of MMC pins.
>
> Well just recently Linus W specifically wanted us to use regulator
> framework for the MMC1 PBIAS rather than pinctrl. That's because
> from consumer driver point of view, it changes voltage and there's
> a delay involved. So I guess no conclusion yet, and it's best to
> do stand alone drivers to deal with those that use pinctrl for the
> pinctrl specific parts and export it as a regulator for the consumer
> devices.

In the case of pbias, the boundary is not that clear, and it is true 
that writing a complete pinctrl driver is really overkill.
I've tried in the past, and gave up due to the complexity of fmwk and 
the lack of time. I still think, it is a much better fmwk to handle pin 
configuration than the regulator fmwk.

> That's pretty much along the lines what Roger has done,
> except the transceiver could use the pinctrl-single,bits for the
> muxing and pinconf.

Well, in that case, this is a reset line, so it does not have anything 
to do with voltage :-)

Anyway, thanks to Florian, we know that there is a real solution to that 
problem. It is just not merged now :-(

Regards,
Benoit
