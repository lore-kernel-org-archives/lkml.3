Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3HRVLb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 17:11:31 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:60486 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab3HRVL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 17:11:29 -0400
Message-ID: <521154A9.3000505@gmail.com>
Date: Mon, 19 Aug 2013 01:11:37 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 4/5] ARM: mvebu: add Armada 1500 and Sony NSZ-GS7 device
 tree files
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376682098-10580-5-git-send-email-sebastian.hesselbarth@gmail.com> <201308172128.35245.arnd@arndb.de>
In-Reply-To: <201308172128.35245.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2013 09:28 PM, Arnd Bergmann wrote:
> On Friday 16 August 2013, Sebastian Hesselbarth wrote:
>> +               cpu@0 {
>> +                       compatible = "marvell,sheeva-v7";
>> +                       device_type = "cpu";
>> +                       next-level-cache = <&l2>;
>> +                       reg = <0>;
>> +               };
> ...
>> +               l2: l2-cache-controller@1ac0000 {
>> +                       compatible = "marvell,aurora-outer-cache";
>> +                       reg = <0x1ac0000 0x1000>;
>> +                       cache-level = <2>;
>> +               };
>> +
>> +               gic: interrupt-controller@1ad0000 {
>> +                       compatible = "arm,cortex-a9-gic";
>> +                       reg = <0x1ad1000 0x1000
>> +                              0x1ad0100 0x0100>;
>> +                       interrupt-controller;
>> +                       #interrupt-cells = <3>;
>> +               };
>> +
>> +               local-timer@1ad0600 {
>> +                       compatible = "arm,cortex-a9-twd-timer";
>> +                       reg = <0x1ad0600 0x20>;
>> +                       interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_HIGH>;
>> +                       clocks = <&cpu0clk>;
>> +               };
>
> This seems like a strange combination. I would have expected either PJ4+Aurora+apbtimer
> or A9+pl310+localtimer, based on what I found in the chromecast kernel source.
> Do you have more information here about what is used on the two variants?

I have no clue, what combination it really is. Unfortunately,
Marvell didn't release any open datasheets, of course.

I can only look at GPL'd Asus Cube kernel, I used for getting an idea
of what was required for initial support and reg offsets, irqs and
friends. They bring up twd as localtimer. Also, grep'ing the Cube
kernel sources in mach-mv88de3100 gives hits for CONFIG_PJ4 (note the
missing B), l2x0, smp_twd, apb_timer.

No hits for pl310, A9.

Sebastian

