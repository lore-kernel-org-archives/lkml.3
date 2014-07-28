Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaG1LS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:18:26 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43172 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaG1LSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:18:21 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega ix4-300d NAS
From: Benoit Masson <benoitm@perenite.com>
In-Reply-To: <6028388.mjACYPxFta@wuerfel>
Date: Mon, 28 Jul 2014 13:17:56 +0200
Cc: Andrew Lunn <andrew@lunn.ch>, Benoit Masson <yahoo@perenite.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jason@lakedaemon.net, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <78E68BC6-1D2C-4B75-93BA-5414A358B90D@perenite.com>
References: <1406418436-61452-1-git-send-email-yahoo@perenite.com> <5442226.1WCY4fjGCy@wuerfel> <78788908-DDB5-46F8-83C1-FAE312D7BFB2@perenite.com> <6028388.mjACYPxFta@wuerfel>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 28 juil. 2014 à 13:02, Arnd Bergmann <arnd@arndb.de> a écrit :

> On Monday 28 July 2014 12:50:47 Benoit Masson wrote:
>>> 
>>> It should still list both "marvell,mv78230-i2c" and "marvell,mv64xxx-i2c",
>>> as the generic name may not be enough to describe the register layout
>>> correctly.
>> 
>> I tend to disagree since the dts include the armada-xp.dtsi, which already declare
>> 
>> "i2c0: i2c@11000 {
>>                                compatible = "marvell,mv78230-i2c", "marvell,mv64xxx-i2c";
>>                                reg = <0x11000 0x100>;
>>                        };
>> "
>> 
>> I tested the dts on the device and it does inherits the i2c declaration, did I miss something here ?
>> 
> 
> Inheriting from armada-xp.dtsi is fine, but if you manually set
> "marvell,mv64xxx-i2c", that will override the old setting
> and drop the "marvell,mv78230-i2c" part, which is bad because
> it may break things later if it turns out that the mv78230
> variant is not completely compatible with the old
> mv64xxx variant.

Ok then does this mean I can simply remove the "compatible" line to only inherits from armada-xp-dtsi ?

"i2c@11000 {
                                clock-frequency = <400000>;
                                status = "okay";
"

Would this be enough ?

Benoit
> 
> 	Arnd

