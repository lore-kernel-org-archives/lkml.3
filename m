Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbaIEO2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:28:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45124 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932443AbaIEO2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:28:05 -0400
Message-ID: <5409C84A.90000@arm.com>
Date: Fri, 05 Sep 2014 15:27:22 +0100
From: Andre Przywara <andre.przywara@arm.com>
Organization: ARM Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robherring2@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC PATCH 1/1] drivers: introduce ARM SBSA generic UART driver
References: <1409328803-1953-1-git-send-email-andre.przywara@arm.com> <3749748.k4a1nSHDdj@wuerfel> <CAL_JsqKGbSd5BymnFhT8KBjbBCPO8wsrHhG9Qn20c7mrrxTDDA@mail.gmail.com> <2856634.LN9gbfSP9v@wuerfel>
In-Reply-To: <2856634.LN9gbfSP9v@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/09/14 20:34, Arnd Bergmann wrote:
> On Tuesday 02 September 2014 12:38:23 Rob Herring wrote:
>> On Tue, Sep 2, 2014 at 8:48 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Tuesday 02 September 2014 08:20:53 Rob Herring wrote:
>>>>>>
>>>>>> This alone is not okay. There is no such implementation of hardware.
>>>>>
>>>>> But the SBSA explicitly allows this. I don't know of any vendor who just
>>>>> implements the subset, but I've been told that this has been asked for.
>>>>
>>>> To use baudrate as an example, that must be configurable somehow
>>>> either with pl011 registers or in a vendor specific way. I suppose you
>>>> could do an actual implementation with all those things hardcoded in
>>>> the design, but that seems unlikely.
>>>
>>> Why does the baudrate need to be configurable? I think it's completely
>>> reasonable to specify a console port that has a fixed (as in the
>>> OS must not care) rate, and that can be implemented either as a UART
>>> with a programmable rate or as a set of registers that directly talks
>>> to a remote system management device over whatever hardware protocol
>>> they choose.
>>
>> Sure. It is also completely reasonable that baudrate is configurable
>> and vendors can implement it however they choose since the SBSA does
>> not specify it. IIRC, the enabling and disabling bits are not
>> specified either.
>>
>> Not having configurability is simply one variation on possible
>> implementations.
> 
> It's not obvious to me though that we are served better by a
> pl011 driver that allows any possible subset of the features,
> rather than having the existing driver for pl011, and a new driver
> for the sbsa subset, which then won't allow any of the optional
> features.
> 
> Yes, there is some duplication, but a driver for this kind of
> dumb console port should be doable in very little code, at
> least less than the proposed implementation.

I see your point, but as long as this means to introduce another serial
prefix I would rather avoid it.
As said in the other mail, I think the integration into PL011 does not
look too bad, so we can discuss again this when I post the code later.

Cheers,
Andre.
