Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaJOPfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:35:16 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36368 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaJOPfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:35:14 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 0/8] Armada XP pinctrl consolidation and ix4-300d fixes
From: Benoit Masson <benoitm@perenite.com>
In-Reply-To: <20141015144123.GA18413@lunn.ch>
Date: Wed, 15 Oct 2014 17:35:13 +0200
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <B4E62BBB-856D-48E9-B694-C6149DB0E864@perenite.com>
References: <1411157684-6991-1-git-send-email-sebastian.hesselbarth@gmail.com> <-7443282711873112734@unknownmsgid> <20141003141102.GJ3895@titan.lakedaemon.net> <542EBB93.108@gmail.com> <A9781A2E-F3CA-4E8A-833C-D167B456D9F7@perenite.com> <542EC3A3.1060605@gmail.com> <1ACB5318-863E-40D8-8B27-41F1C0D0A4B8@perenite.com> <5432BFB1.2060300@gmail.com> <CE7A9795-C2AF-451A-8018-3A0B8788BF60@perenite.com> <1CDF8F6B-42FF-4D6A-B52F-6DB270F2673C@perenite.com> <20141015144123.GA18413@lunn.ch>
To: Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 15 oct. 2014 à 16:41, Andrew Lunn <andrew@lunn.ch> a écrit :

>>> All the 3 branch works WHEN APPLYING A0 patch (below), with both my custom kernel config and the arch/arm/configs/mvebu_v7_defconfig
>> Just one thing though, one of my cron behavior change with 3.17, when I use the cmd  "/sbin/hwclock --adjust -f /dev/rtc1" I get this new error I never had before:
>> "hwclock: select() to /dev/rtc1 to wait for clock tick timed out: Success"
>> 
>> where rtc1 if the i2c rtc connected to the i2C bus, can this be related to the i2c patch that would slow down i2c operation or somthing ? 
> 
> Hi Benoit
> 
> It won't fix your problem, but if the built in RTC is not usable, it
> would be good to disable it in the .dts file. The i2c RTC will then
> become RTC0.
> 
> 
> The actual "error" message is odd:
> "hwclock: select() to /dev/rtc1 to wait for clock tick timed out: Success"
> 
Yes this is the wired thing is that everything works, even getting the date via "cat /sys/class/i2c-adapter/i2c-0/0-0051/rtc/rtc1/time" is ok
reading the rtc driver code it seems this message is shown when multiple resources try to access shared rtc... but why now and not before ?

So I was wondering if the i2c_quirk() applied by the batch has any effect with this ?

Anyhow I'll handle the message for now and see if there are performance impact on this...

Benoit

> Success means it actually worked, not an error. Does the RTC contain
> the correct time afterwards?
> 
>    Andrew

