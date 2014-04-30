Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbaD3TyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:54:09 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:46834 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759303AbaD3TyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:54:07 -0400
Message-ID: <536154D8.2010600@gmail.com>
Date: Wed, 30 Apr 2014 21:54:00 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 07/15] ARM: dts: kirkwood: consolidate common pinctrl
 settings
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com> <1398862602-29595-8-git-send-email-sebastian.hesselbarth@gmail.com> <20140430164236.GC12944@obsidianresearch.com> <5361517D.8000106@gmail.com> <20140430194437.GB17365@obsidianresearch.com>
In-Reply-To: <20140430194437.GB17365@obsidianresearch.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 09:44 PM, Jason Gunthorpe wrote:
> On Wed, Apr 30, 2014 at 09:39:41PM +0200, Sebastian Hesselbarth wrote:
>> On 04/30/2014 06:42 PM, Jason Gunthorpe wrote:
>>> On Wed, Apr 30, 2014 at 02:56:34PM +0200, Sebastian Hesselbarth wrote:
>>>> All SoCs have the same pinctrl setting for NAND, UART0/1, SPI, TWSI0,
>>>> and GBE1. Move it to the common pinctrl node that we now have.
> 
>> Yes, there are already some boards (e.g. t5325 with spi0) overwriting
>> pinctrl settings instead of overwriting the pinctrl-0 property. I
>> thought, I keep this behavior and note it above each pinctrl node in
>> some of the following patches.
> 
> That all makes sense, I think the commit message just seemed to say
> something else.

Well, this patch is about moving the pinctrl nodes to the common SoC
dtsi. The next 6 patches are about setting the default pinctrl property.

> Maybe more like:
> 
> NAND and TWSI0 have only one valid pin control choice on Kirkwood,
> move those definitions into the common dtsi.
> 
> For UART0/1 and SPI, which have two choices, move the definition that
> is used in the majority of the board files into the common dtsi.
> Board files that are different will override.

Ok, I see. Well, strictly speaking the setting node itself is always
valid, no matter if the board uses it. So that is why I first moved
them into kirkwood.dtsi and did set the pinctrl-0 property in the
later patches, e.g. commit message of Patch 9 reads:

"""
Most boards use the default UART0/1 pinctrl setting without RTS/CTS.
Add the pinctrl setting to the toplevel SoC UART nodes and put a note
in front of the corresponding pinctrl node to overwrite the setting
on board level. Currently, both boards using a different UART pinctrl
setting (Openblocks A6, A7) already overwrite the pinctrl node.
"""

But I can, of course, reword this commit message.

Sebastian

