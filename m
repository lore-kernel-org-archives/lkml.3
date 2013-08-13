Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab3HMKkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:40:37 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:45172 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3HMKkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:40:35 -0400
Message-ID: <520A0D1D.4050609@gmail.com>
Date: Tue, 13 Aug 2013 12:40:29 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Bjorn Helgaas <bhelgaas@google.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 4/9] PCI: mvebu: add support for reset on GPIO
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376333215-12885-5-git-send-email-sebastian.hesselbarth@gmail.com> <20130813080956.GE9316@ulmo> <20130813103030.1e4156a1@skate> <20130813100348.GA28762@ulmo>
In-Reply-To: <20130813100348.GA28762@ulmo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/13 12:03, Thierry Reding wrote:
> On Tue, Aug 13, 2013 at 10:30:30AM +0200, Thomas Petazzoni wrote:
>> Dear Thierry Reding,
>>
>> On Tue, 13 Aug 2013 10:09:56 +0200, Thierry Reding wrote:
>>
>>>> +- reset-gpios: optional gpio to PERST#
>>>> +- reset-delay-ms: delay in ms to wait after reset de-assertion
>>>
>>> I remember some recent discussion about this, and we now have this reset
>>> framework, so perhaps it makes more sense to use the reset binding for
>>> this? Cc'ing Stephen (as part of the device tree bindings maintainers
>>> team) who was involved in that recent reset bindings discussion.
>>
>> I also thought about this, but the reset framework seems to be designed
>> for "reset controller" IPs, i.e special IPs that are controlling reset
>> signals. Looking at Documentation/devicetree/bindings/reset/reset.txt,
>> I'm not sure to see how this would apply to GPIO-controlled reset
>> signals.
>
> See:
>
> 	http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg36900.html
>
> which seems to have carried over to this at some point:
>
> 	http://www.spinics.net/lists/devicetree/msg00521.html
>
> Some of the messages in between I can't find in any archive, sorry.

Thierry, Sascha,

thanks for the input. Flipping through the above discussion, I guess
using "reset-gpios" and "reset-delay-us" should be fine?

I can also remove the delay property for now, as I cannot find a final
conclusion about the configurable delay.

In the driver, I will stick to bare gpiolib and wait for gpio-reset
driver to become available. Currently, we don't have sophisticated
reset handling in pci-mvebu anyway.

Sebastian

