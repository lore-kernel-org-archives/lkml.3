Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161202AbaDQGy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 02:54:29 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48805 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaDQGy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 02:54:27 -0400
Message-ID: <534F7A9C.2080609@gmail.com>
Date: Thu, 17 Apr 2014 08:54:20 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Jisheng Zhang <jszhang@marvell.com>,
        =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: "chris@printf.net" <chris@printf.net>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] ARM: dts: berlin: add the SDHCI nodes for the BG2Q
References: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com> <1397652011-21284-4-git-send-email-antoine.tenart@free-electrons.com> <20140417113306.545ca4a7@xhacker>
In-Reply-To: <20140417113306.545ca4a7@xhacker>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 05:33 AM, Jisheng Zhang wrote:
> On Wed, 16 Apr 2014 05:40:10 -0700
> Antoine Ténart <antoine.tenart@free-electrons.com> wrote:
>> Add the SDHCI nodes for the Marvell Berlin BG2Q, using the berlin-sdhci
>> driver.
[...]
>> +		sdhci0: sdhci@ab0000 {
>> +			compatible = "marvell,berlin2q-sdhci";
>> +			reg = <0xab0000 0x200>;
>> +			clocks = <&sdio1clk>;
>> +			interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
>> +			keep-power-in-suspend;
>> +			enable-sdio-wakeup;
>> +			broken-cd;
>> +			status = "disabled";
>> +		};
>> +
>> +		sdhci1: sdhci@ab0800 {
>> +			compatible = "marvell,berlin2q-sdhci";
>> +			reg = <0xab0800 0x200>;
>> +			clocks = <&sdio1clk>;
>> +			interrupts = <GIC_SPI 20 IRQ_TYPE_LEVEL_HIGH>;
>> +			keep-power-in-suspend;
>> +			enable-sdio-wakeup;
>> +			status = "disabled";
>> +		};
>> +
>> +		sdhci2: sdhci@ab1000 {
>> +			compatible = "marvell,berlin2q-sdhci";
>> +			reg = <0xab1000 0x200>;
>> +			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
>> +			clocks = <&sdio1clk>;
>> +			keep-power-in-suspend;
>> +			enable-sdio-wakeup;
>> +			broken-cd;
>> +			status = "disabled";
>> +		};
> 
> could we put sdhci@ab1000 at the first of sdhci lists? For two reasons:

Don't reorder the nodes, but use aliases.

> 1. sdhci@ab0000 and sdhci@ab0800 is called as sdhci1 and sdhci2 in mrvl
> internal discussion, so this would make the name consistent when we
> upgrade linux kernel to one mainline version.

How about we only move the node labels?

> 2. sdhci@ab1000 is always used for emmc. if sdhci@ab0800 is put at the
> head of sdhci@ab1000, and there's one sdcard in it, mmcblock0 would be
> the sdcard rather than emmc.

And label this one sdhci0?

> I dunno whether there's elegant solutions for these two issues. alias? Could
> anyone kindly help?

Have a look at drivers/mmc/host/dw_mmc.c:

ctrl_id = of_alias_get_id(host->dev->of_node, "mshc");

this also requires an aliases node in berlin2foo.dtsi:

aliases {
	mshc0 = &sdhci0;
	mshc1 = &sdhci1;
	mshc2 = &sdhci2;
};

Rather than using "mshc", I'd prefer something like "sdio" or "mmc".

Also, if that alias would be part of generic mmc OF code would be
good too, but we'll have to wait for Chris' call here.

Sebastian
