Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157AbaGXOez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:34:55 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:52532 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758972AbaGXOey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:34:54 -0400
Date: Thu, 24 Jul 2014 16:29:18 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Benoit Masson <benoitm@perenite.com>, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Benoit Masson <yahoo@perenite.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Subject: Re: [PATCH 2/2] ARM: mvebu: Added dts defintion for Lenovo Iomega
 ix4-300d NAS
Message-ID: <20140724142918.GG28485@lunn.ch>
References: <1406154923-13612-2-git-send-email-yahoo@perenite.com>
 <20140723224236.GC28485@lunn.ch>
 <94F87063-D717-435B-B7C5-EDAC9B26742C@perenite.com>
 <20140723225841.GD28485@lunn.ch>
 <10A7C530-7CD2-4ED0-889A-7FAC1922320F@perenite.com>
 <20140723231535.GK23220@titan.lakedaemon.net>
 <53D0FA2F.6050209@free-electrons.com>
 <20140724124520.GV23220@titan.lakedaemon.net>
 <C2E7C8C1-1198-4785-AB9C-C27B5E27A8D4@perenite.com>
 <20140724140757.GW23220@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724140757.GW23220@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only outstanding point (Arnd?), is that I think it's ok to have the
> i2c...a0 compatible string in the dts files, but Andrew seems to think
> otherwise.  Is that still true Andrew?

Hi Jason

I can live with i2c...a0 compatible string, but it has minor problems:

1) The binding Documentation says not to do it. So we are ignoring our
   own documentation.

2) It seems likely that at some point the OEM will swap to B1 revision
   SoCs. The i2c device then does not require this quirk, but we have
   hard coded in the DT file that it is required. B1 revision would
   work, but not optimally.

So i would prefer not to explicitly enable the quirk, but determine at
run time if the quirk is needed for the SoC revision it is running on.

    Andrew

