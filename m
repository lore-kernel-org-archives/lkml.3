Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbaGWW5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:57:09 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:43974 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaGWW5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:57:06 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega ix4-300d NAS
From: Benoit Masson <benoitm@perenite.com>
In-Reply-To: <20140723224236.GC28485@lunn.ch>
Date: Thu, 24 Jul 2014 00:56:56 +0200
Cc: Benoit Masson <yahoo@perenite.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jason@lakedaemon.net, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <94F87063-D717-435B-B7C5-EDAC9B26742C@perenite.com>
References: <1406154923-13612-1-git-send-email-yahoo@perenite.com> <1406154923-13612-2-git-send-email-yahoo@perenite.com> <20140723224236.GC28485@lunn.ch>
To: Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No worries, sorry it makes more email for you guys, I've added the colors for power and revert order hdd:blue instead of blue:hdd for the hdd led.

For the marvell,mv78230-a0-i2c unfortunately i've spend 3 hours trying to understand this but it only works with this on the ix4-300d :(. There was multiple patch around this and maybe one broke the auto-detect part of this, I've tried compiling with some 3.10 or lower kernel but no luck here I still have to put this a0 option.

Benoit
Le 24 juil. 2014 à 00:42, Andrew Lunn <andrew@lunn.ch> a écrit :

>> +			i2c@11000 {
>> +				compatible = "marvell,mv78230-a0-i2c",
>> +					"marvell,mv64xxx-i2c";
> 
> Ah sorry, i missed this first time. Do you really need
> "marvell,mv78230-a0-i2c"?
> 
> Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt says:
> 
>                     - "marvell,mv78230-a0-i2c"
>                       * Note: Only use "marvell,mv78230-a0-i2c" for a
>                         very rare, initial version of the SoC which
>                         had broken offload support.  Linux
>                         auto-detects this and sets it appropriately.
> 
> So i don't think you should have this hear.
> 
> Gregory, please could you comment.
> 
>> +		power-led {
>> +			label = "ix4-300d:power";
> 
> It is normal to include the colour, and you did for all the other
> LEDs.
> 
> 	Andrew

