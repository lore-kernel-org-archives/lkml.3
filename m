Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbaGWPxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:53:19 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64806 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaGWPxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:53:17 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 1/2] Added dts defintion for Lenovo ix4-300d nas
From: Benoit Masson <benoitm@perenite.com>
In-Reply-To: <20140723141443.GC2856@lunn.ch>
Date: Wed, 23 Jul 2014 17:52:57 +0200
Cc: Jason Cooper <jason@lakedaemon.net>, benoitm974 <yahoo@perenite.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <47823826-CDE8-47D2-B1B6-B688118CF985@perenite.com>
References: <1406117232-5962-1-git-send-email-yahoo@perenite.com> <20140723134534.GF23220@titan.lakedaemon.net> <20140723141443.GC2856@lunn.ch>
To: Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew I've taken your comment into account, yet for the PHY init comment, see my answer below.

Le 23 juil. 2014 à 16:14, Andrew Lunn <andrew@lunn.ch> a écrit :
> 
>>> +	/* warning: you need both eth1 & 0 to be initialize for poweroff to shutdown otherwise it reboots */
> 
> What do you mean by initialized? Driver loaded? Interface up? 
Well actually the PHY need to be initialized (at least 1 mII reg written), which from marvel LSP driver always occurs, while it doesn't with mainline PHY driver (drivers/net/phy/marvell.c), so the only simple way I found to have at least one PHY reg on both interface written is to have both eth up at OS config level.

Probably the best option would be to have a reg-init = <reg offset value> on both phy dts definition but the current armada mii doesn't support this dts config...

> 
>> This is a great first version
> 
> I agree with Jason, well done.
> 
Thanks !
>  Andrew

