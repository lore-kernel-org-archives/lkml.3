Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaG1KvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:51:01 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43379 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaG1Ku7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:50:59 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega ix4-300d NAS
From: Benoit Masson <benoitm@perenite.com>
In-Reply-To: <5442226.1WCY4fjGCy@wuerfel>
Date: Mon, 28 Jul 2014 12:50:47 +0200
Cc: Andrew Lunn <andrew@lunn.ch>, Benoit Masson <yahoo@perenite.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jason@lakedaemon.net, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <78788908-DDB5-46F8-83C1-FAE312D7BFB2@perenite.com>
References: <1406418436-61452-1-git-send-email-yahoo@perenite.com> <20140727015244.GA31974@lunn.ch> <5442226.1WCY4fjGCy@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 28 juil. 2014 à 10:49, Arnd Bergmann <arnd@arndb.de> a écrit :

> On Sunday 27 July 2014 03:52:44 Andrew Lunn wrote:
>> Hi Benoit

Hi Arnd,

>> 
>>> +                     i2c@11000 {
>>> +                             compatible = "marvell,mv78230-a0-i2c",
>>> +                                     "marvell,mv64xxx-i2c";
>> 
>> The point of my patches is that you don't need the
>> "marvell,mv78230-a0-i2c". It will work out at runtime if the SoC is A0
>> stepping and automatically enable the workaround. Please test with
>> only "marvell,mv64xxx-i2c";
>> 
> 
> It should still list both "marvell,mv78230-i2c" and "marvell,mv64xxx-i2c",
> as the generic name may not be enough to describe the register layout
> correctly.

I tend to disagree since the dts include the armada-xp.dtsi, which already declare

"i2c0: i2c@11000 {
				compatible = "marvell,mv78230-i2c", "marvell,mv64xxx-i2c";
				reg = <0x11000 0x100>;
			};
"

I tested the dts on the device and it does inherits the i2c declaration, did I miss something here ?

Benoit

> 	Arnd

