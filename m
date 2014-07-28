Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaG1LEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:04:12 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:57124 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaG1LEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:04:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benoit Masson <benoitm@perenite.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Benoit Masson <yahoo@perenite.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jason@lakedaemon.net, gregory.clement@free-electrons.com,
        sebastian.hesselbarth@googlemail.com
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega ix4-300d NAS
Date: Mon, 28 Jul 2014 13:02:47 +0200
Message-ID: <6028388.mjACYPxFta@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <78788908-DDB5-46F8-83C1-FAE312D7BFB2@perenite.com>
References: <1406418436-61452-1-git-send-email-yahoo@perenite.com> <5442226.1WCY4fjGCy@wuerfel> <78788908-DDB5-46F8-83C1-FAE312D7BFB2@perenite.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0pc2h09DAQXUc1+ZcIcvzcCGmBb6XABa00OpjamrLS3
 nqNN3upDkuHg4wylKzApJBadtMFimGyCeSs9DNhdJG4WJFIZrc
 TIRjKayPgvs7syJxvD5dI6PLjgR9GIvfn27x528h9De87F9jfX
 vBxlXLQwo8/DL4KZXkFHibE8QkT33sp1B88/XYs4dXBpvrnIo4
 oShnFHlTyzr8FilTYHLnf6iugHgAq/NMzzOd3IPKUSErm8C1b/
 MX+jWbxO/oX7CIuN0DriTxk8g+c3/3mvRhEtEr1ZsJoTmkMJHM
 pRfoBt/6aSsjv1u2H/z/AsTNfUEJu9BCUIUV63XWRVOVRj/qdS
 K8ryYlFMDS1naNzir8GI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2014 12:50:47 Benoit Masson wrote:
> > 
> > It should still list both "marvell,mv78230-i2c" and "marvell,mv64xxx-i2c",
> > as the generic name may not be enough to describe the register layout
> > correctly.
> 
> I tend to disagree since the dts include the armada-xp.dtsi, which already declare
> 
> "i2c0: i2c@11000 {
>                                 compatible = "marvell,mv78230-i2c", "marvell,mv64xxx-i2c";
>                                 reg = <0x11000 0x100>;
>                         };
> "
> 
> I tested the dts on the device and it does inherits the i2c declaration, did I miss something here ?
> 

Inheriting from armada-xp.dtsi is fine, but if you manually set
"marvell,mv64xxx-i2c", that will override the old setting
and drop the "marvell,mv78230-i2c" part, which is bad because
it may break things later if it turns out that the mv78230
variant is not completely compatible with the old
mv64xxx variant.

	Arnd
