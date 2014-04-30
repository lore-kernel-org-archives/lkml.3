Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbaD3Tjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:39:51 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56293 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759107AbaD3Tjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:39:49 -0400
Message-ID: <5361517D.8000106@gmail.com>
Date: Wed, 30 Apr 2014 21:39:41 +0200
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
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com> <1398862602-29595-8-git-send-email-sebastian.hesselbarth@gmail.com> <20140430164236.GC12944@obsidianresearch.com>
In-Reply-To: <20140430164236.GC12944@obsidianresearch.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 06:42 PM, Jason Gunthorpe wrote:
> On Wed, Apr 30, 2014 at 02:56:34PM +0200, Sebastian Hesselbarth wrote:
>> All SoCs have the same pinctrl setting for NAND, UART0/1, SPI, TWSI0,
>> and GBE1. Move it to the common pinctrl node that we now have.
> 
> There are two possible choices for UART0, UART1, and SPI on kirkwood..
> 
> For instance I use this on my board:
> 
>                                 pmx_spi0: pmx-spi0 {
>                                         marvell,pins = "mpp7", "mpp10", "mpp11", "mpp12";
>                                         marvell,function = "spi";
>                                 };
> 
> vs
> 
>> +
>> +			pmx_spi: pmx-spi {
>> +				marvell,pins = "mpp0", "mpp1", "mpp2", "mpp3";
>> +				marvell,function = "spi";
>> +			};
> 
> It looks like all the boards in the kernel use the same choice, so it
> makes some sense to consolidate, but I assume a board file can
> override the marvell,pins?

Yes, there are already some boards (e.g. t5325 with spi0) overwriting
pinctrl settings instead of overwriting the pinctrl-0 property. I
thought, I keep this behavior and note it above each pinctrl node in
some of the following patches.

But your comment reminded me of something more important: there is
one set of boards using kirkwood-lsxl.dtsi which does not explicitly
set spi's pinctrl property. So this consolidation potentially breaks
spi on those boards.

An explicit Tested-by for Buffalo Linkstation LS-CHLv2 and/or LS-XHL
would be good.

> Otherwise the rest of your patchset looked sane to me.

I count that as a

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Thanks!

Sebastian

