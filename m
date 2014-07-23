Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbaGWX0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:26:32 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:37680 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800AbaGWX0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:26:30 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 1/2] Added dts defintion for Lenovo ix4-300d nas
From: Benoit Masson <benoitm@perenite.com>
In-Reply-To: <20140723222640.GA28485@lunn.ch>
Date: Thu, 24 Jul 2014 01:26:19 +0200
Cc: Jason Cooper <jason@lakedaemon.net>, benoitm974 <yahoo@perenite.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <46D20C06-D7F3-4833-A93C-0A393A7C558E@perenite.com>
References: <1406117232-5962-1-git-send-email-yahoo@perenite.com> <20140723134534.GF23220@titan.lakedaemon.net> <20140723141443.GC2856@lunn.ch> <47823826-CDE8-47D2-B1B6-B688118CF985@perenite.com> <20140723164958.GH2856@lunn.ch> <9AE6F1AD-9296-47E9-91E2-9E34AA48EBB4@perenite.com> <20140723222640.GA28485@lunn.ch>
To: Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well I'm glad you spend time on this. So I'll explain more in detail where I am on this one.

I have the vendor 3.0.29 kernel patched with LSP drivers from Marvell (which includes the PHY & Net drivers).

With this version (called LSPkernel now on) pulling MPP24 GPIO output up shutdown the power of the device.

At first I though it could be watchdog or wol related so I deep dive into both drivers and start uncommenting register write by register write, in the end the LSPKernel start rebooting instead of poweroff when no phy register were written at all... which is when I start thinking about that its was maybe not really which reg were written but that both phy were to be writtent to at least on reg for the MPP24 to poweroff the device and that worked out.

So as soon as both phy get "m88e1318_config_aneg" fucntion called from "drivers/net/phy/marvell.c" it works fine.

Also maybe you can help me there although the marvell.c has m88e1318_get_wol & m88e1318_set_wol setup as part of the MARVELL_PHY_ID_88E1318S calling "ethtool -s eth0 wol g" from debian return a non-supported error .. any though ?

Benoit
Le 24 juil. 2014 à 00:26, Andrew Lunn <andrew@lunn.ch> a écrit :

>> Both phy are :
>> marvell,88e1318
> 
> I don't have the datasheet for this specific phy model, but i do have
> the datasheet for another similar phy.
> 
>> example of a minimal reg write that lead MPP24 to shutdown instead
>> of rebooting on original BSP driver
> 
>> XXXXX BasicInit
> 
> I'm assuming regOffs is decimal, and data is hex?
> 
>> phyAdr 0: regOffs: 16 data: 3
> 
> Copper Specific control register. 3 means Polarity Reversal Disable &
> Jabber function disable.
> 
>> phyAdr 0: regOffs: 10 data: 830
> 
> Reg 10 is the 1000BASE-T Status register, which is read only!
> 
> So this is not making much sense. Are we missing some changes to the
> page register? Register 16 of page 3 is the LED control register.
> 
>     Andrew
> 

