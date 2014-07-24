Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbaGXNf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:35:29 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:52494 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756834AbaGXNf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:35:28 -0400
Date: Thu, 24 Jul 2014 15:29:54 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Benoit Masson <benoitm@perenite.com>, Andrew Lunn <andrew@lunn.ch>,
        Benoit Masson <yahoo@perenite.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega
 ix4-300d NAS
Message-ID: <20140724132954.GF28485@lunn.ch>
References: <1406154923-13612-1-git-send-email-yahoo@perenite.com>
 <1406154923-13612-2-git-send-email-yahoo@perenite.com>
 <20140723224236.GC28485@lunn.ch>
 <94F87063-D717-435B-B7C5-EDAC9B26742C@perenite.com>
 <20140723225841.GD28485@lunn.ch>
 <10A7C530-7CD2-4ED0-889A-7FAC1922320F@perenite.com>
 <20140723231535.GK23220@titan.lakedaemon.net>
 <53D0FA2F.6050209@free-electrons.com>
 <20140724124520.GV23220@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724124520.GV23220@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well about the issue, we patch the device tree for the i2c quirk only for
> > the openblock AX3.
> 
> Ahhh, that's right.  I need to slow down and dig a bit more. :(
> 
> > If I remember well it was because the device tree was already written
> > for this board before we found there was an issue with the A0 version
> > of the CPU. 
> 
> No, it's because we didn't think any manufacturers would be silly enough
> to use the a0 in production.  That assumption worked out well. :-P
> 
> > The rule was that for new boards then they have to set the marvell,mv78230-a0-i2c
> > compatible string. I also didn't expect that we found "new" product using the A0 version.
> > 
> > We have 3 options now:
> > 
> > - remove the check on the openblock AX3 board and always try to apply the quirck for A0 version
> > - add a check for this new board in the mvebu_dt_init function
> > - let the compatible string marvell,mv78230-a0-i2c in this dts
> > 
> > I would prefer the option 1 but I fear that Arnd would prefer the 2 other options.
> 
> I like option 1 and 3.  Option 3 is a *correct* description of the
> hardware, and should be done.  Option 1 makes Linux user-friendly for boards
> that are exactly the same, but changed out SoC stepping mid-production.

I would prefer 1 as well. It is the SoC that has the problem, not the
board. So we should not be making the quirk board specific.

       Andrew
