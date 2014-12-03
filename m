Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaLCJQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:16:58 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53486 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaLCJQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:16:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141127115042.GE857@leverpostej>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1416917818-10506-4-git-send-email-chunyan.zhang@spreadtrum.com>
	<20141127115042.GE857@leverpostej>
Date: Wed, 3 Dec 2014 17:16:52 +0800
Message-ID: <CAAfSe-tf8WMRPnPZuEsDYbjMjBHnkSud_aX4ksu6yvnEDD-SAw@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "artagnon@gmail.com" <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        Will Deacon <Will.Deacon@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hytszk@gmail.com" <hytszk@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        marc.zyngier@arm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>> +       gic: interrupt-controller@12001000 {
>> +               compatible = "arm,cortex-a15-gic", "arm,cortex-a9-gic";
>> +               #interrupt-cells = <3>;
>> +               interrupt-controller;
>> +               reg = <0 0x12001000 0 0x1000>,
>> +                     <0 0x12002000 0 0x1000>,
>> +                     <0 0x12004000 0 0x2000>,
>> +                     <0 0x12006000 0 0x2000>;
>> +       };
>
> I believe GICC should be 8KiB here.
>
Yes, I'll correct it in next patch.
>> +
>> +       psci {
>> +               compatible = "arm,psci-0.2";
>> +               method = "smc";
>> +       };
>
> Do you have a complete PSCI 0.2 implementation (e.g. are all the
> mandatory functions implemented)?
>
I was using the latest boot-wrapper as the bootloader for test,  I'll
add a compatible string "arm,psci" in v4.
We'll use u-boot on real hardware, the support for PSCI in our u-boot
is in progress.
We're intending to implement psci-0.1 at first, and psci-0.2 for the next step.

> I take it CPUs enter the kernel at EL2?
>
yes, we've just do like this.

> How have you tested this?

I'll test it on the SC9836 FPGA board before next submitting.

Thanks for your patient review.
Chunyan
