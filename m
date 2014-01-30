Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaA3Suo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:50:44 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:34516 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbaA3Sum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:50:42 -0500
Message-ID: <52EA9EFA.1030609@gmail.com>
Date: Thu, 30 Jan 2014 19:50:34 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/21] pinctrl: mvebu: restructure and remove hardcoded
 addresses from Dove pinctrl
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com> <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140130182925.GM10864@lunn.ch>
In-Reply-To: <20140130182925.GM10864@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 07:29 PM, Andrew Lunn wrote:
> On Tue, Jan 28, 2014 at 01:39:12AM +0100, Sebastian Hesselbarth wrote:
>> This patch set is one required step for Dove to hop into mach-mvebu.
>> Until now, pinctrl-dove was hardcoding some registers that do not
>> directly belong to MPP core registers. This is not compatible with
>> what we want for mach-mvebu.
>
> I think there might be something wrong here....

There _is_ something wrong. I'll have a look at it. For the record,
what SoC are you testing with? From the base address, I guess it is
Kirkwood?

Sebastian

> /debug/pinctrl/f1010000.pinctrl/pinconf-groups used to contain:
>
> Pin config settings per pin group
> Format: group (name): configs
> 0 (mpp0):current: spi(cs), available = [ gpio(io) nand(io2) ]
> 1 (mpp1):current: spi(mosi), available = [ gpo(o) nand(io3) ]
> 2 (mpp2):current: spi(sck), available = [ gpo(o) nand(io4) ]
> 3 (mpp3):current: spi(miso), available = [ gpo(o) nand(io5) ]
> 4 (mpp4):current: sata1(act), available = [ gpio(io) nand(io6) uart0(rxd) lcd(hsync) ]
> 5 (mpp5):current: sata0(act), available = [ gpo(o) nand(io7) uart0(txd) lcd(vsync) ]
> 6 (mpp6):current: sysrst(out), available = [ spi(mosi) ]
> ...
>
> It now has:
>
> Pin config settings per pin group
> Format: group (name): configs
> 0 (mpp0):current: gpio(io), available = [ nand(io2) spi(cs) ]
> 1 (mpp1):current: gpo(o), available = [ nand(io3) spi(mosi) ]
> 2 (mpp2):current: gpo(o), available = [ nand(io4) spi(sck) ]
> 3 (mpp3):current: gpo(o), available = [ nand(io5) spi(miso) ]
> 4 (mpp4):current: gpio(io), available = [ nand(io6) uart0(rxd) sata1(act) lcd(hsync) ]
> 5 (mpp5):current: gpo(o), available = [ nand(io7) uart0(txd) sata0(act) lcd(vsync) ]
> 6 (mpp6):current: UNKNOWN, available = [ sysrst(out) spi(mosi) ]
>
> The device i'm testing on does use spi and sata, so i would say the
> old contents was correct and the new is wrong.


