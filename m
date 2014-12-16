Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaLPXls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:41:48 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:53922 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLPXlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:41:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Dec 2014 00:41:33 +0100
From: Stefan Agner <stefan@agner.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] ARM: dts: add support for Vybrid running on
 Cortex-M4
In-Reply-To: <2994970.DCfUQgtmcD@wuerfel>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
 <1417565531-4507-12-git-send-email-stefan@agner.ch>
 <2994970.DCfUQgtmcD@wuerfel>
Message-ID: <6ae4dd827bf4dcc202f60e8505173d0e@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Dec 17 00:40:48 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5490c30012811615911700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-03 12:03, Arnd Bergmann wrote:
> On Wednesday 03 December 2014 01:12:10 Stefan Agner wrote:
>> diff --git a/arch/arm/boot/dts/vf610m4-colibri.dts b/arch/arm/boot/dts/vf610m4-colibri.dts
>> new file mode 100644
>> index 0000000..051ee0f
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/vf610m4-colibri.dts
>> @@ -0,0 +1,52 @@
>> +/*
>> + * Device tree for Colibri VF61 Cortex-M4 support
>> + *
>> + * Copyright 2014 Stefan Agner
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +/dts-v1/;
>> +#include "vf610m4.dtsi"
>> +
>> +/ {
>> +       model = "VF610 Cortex-M4";
>> +       compatible = "fsl,vf610m4";
>> +
>> +       chosen {
>> +               bootargs = "console=ttyLP2,115200 ihash_entries=64 dhash_entries=64 earlyprintk clk_ignore_unused init=/linuxrc rw";
>> +       };
>> +
> 
> Starting with v3.19, you should be able to use the earlycon framework on
> arm32, so it would be better to replace earlyprintk with earlycon here
> and add a stdout-path property in chosen that points to the console
> uart.

I started to implement earlycon support, but something currently fails
when earlycon tries to map the UART registers:
[    0.000000] earlycon_map: Couldn't map 0x40027000

I traced the issue a bit further down and found that get_vm_area_caller
returns NULL (in __arm_ioremap_pfn_caller). This happend on Linus master
as of today (2dbfca5a181973558277b28b1f4c36362291f5e0). Do I miss
something here?

> 
> 64 hash table entries sounds extremely small, doesn't that impact
> performance? If you have 50MB of actual RAM available, I don't think
> you need that.
> 
> 	Arnd

