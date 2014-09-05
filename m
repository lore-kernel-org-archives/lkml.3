Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbaIEOiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:38:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45389 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757144AbaIEOiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:38:06 -0400
Message-ID: <5409CA9E.2060807@arm.com>
Date: Fri, 05 Sep 2014 15:37:18 +0100
From: Andre Przywara <andre.przywara@arm.com>
Organization: ARM Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC PATCH 1/1] drivers: introduce ARM SBSA generic UART driver
References: <1409328803-1953-1-git-send-email-andre.przywara@arm.com> <540596A6.8000608@arm.com> <CAL_Jsq+Rs5MXC7s7EeWAEAPxxqaShAVGt=cdQxud5Us+-Zp6jw@mail.gmail.com> <3749748.k4a1nSHDdj@wuerfel> <CAL_JsqKGbSd5BymnFhT8KBjbBCPO8wsrHhG9Qn20c7mrrxTDDA@mail.gmail.com>
In-Reply-To: <CAL_JsqKGbSd5BymnFhT8KBjbBCPO8wsrHhG9Qn20c7mrrxTDDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 02/09/14 18:38, Rob Herring wrote:
> On Tue, Sep 2, 2014 at 8:48 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Tuesday 02 September 2014 08:20:53 Rob Herring wrote:
>>>>>
>>>>> This alone is not okay. There is no such implementation of hardware.
>>>>
>>>> But the SBSA explicitly allows this. I don't know of any vendor who just
>>>> implements the subset, but I've been told that this has been asked for.
>>>
>>> To use baudrate as an example, that must be configurable somehow
>>> either with pl011 registers or in a vendor specific way. I suppose you
>>> could do an actual implementation with all those things hardcoded in
>>> the design, but that seems unlikely.
>>
>> Why does the baudrate need to be configurable? I think it's completely
>> reasonable to specify a console port that has a fixed (as in the
>> OS must not care) rate, and that can be implemented either as a UART
>> with a programmable rate or as a set of registers that directly talks
>> to a remote system management device over whatever hardware protocol
>> they choose.
> 
> Sure. It is also completely reasonable that baudrate is configurable
> and vendors can implement it however they choose since the SBSA does
> not specify it.

But this would be a different driver for a different hardware then and
not covered by the SBSA version - so to some degree not our problem ;-)
I don't see how we could really cover this problem for every possibly
upcoming implementation.

If I got the spec correctly, then exposing the baudrate setting for SBSA
hardware is not meaningful in the sense of the spec.
If you want to go with a configurable UART complying to the spec, you'd
probably use a full featured PL011.

> IIRC, the enabling and disabling bits are not
> specified either.

Correct, also the FIFO is always on and the word format is fixed to 8n1.

Regards,
Andre.

> 
> Not having configurability is simply one variation on possible implementations.
> 
> Rob
> 
