Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbaGXO4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:56:41 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49085 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbaGXO4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:56:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18mmT9iFqenp75f2JsXkb1fyhuZapCPvAI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 9B7E15B5105
Date: Thu, 24 Jul 2014 10:56:21 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Benoit Masson <benoitm@perenite.com>, Arnd Bergmann <arnd@arndb.de>,
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
Message-ID: <20140724145621.GX23220@titan.lakedaemon.net>
References: <20140723224236.GC28485@lunn.ch>
 <94F87063-D717-435B-B7C5-EDAC9B26742C@perenite.com>
 <20140723225841.GD28485@lunn.ch>
 <10A7C530-7CD2-4ED0-889A-7FAC1922320F@perenite.com>
 <20140723231535.GK23220@titan.lakedaemon.net>
 <53D0FA2F.6050209@free-electrons.com>
 <20140724124520.GV23220@titan.lakedaemon.net>
 <C2E7C8C1-1198-4785-AB9C-C27B5E27A8D4@perenite.com>
 <20140724140757.GW23220@titan.lakedaemon.net>
 <20140724142918.GG28485@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724142918.GG28485@lunn.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 04:29:18PM +0200, Andrew Lunn wrote:
> > The only outstanding point (Arnd?), is that I think it's ok to have the
> > i2c...a0 compatible string in the dts files, but Andrew seems to think
> > otherwise.  Is that still true Andrew?
> 
> Hi Jason
> 
> I can live with i2c...a0 compatible string, but it has minor problems:
> 
> 1) The binding Documentation says not to do it. So we are ignoring our
>    own documentation.

This can be updated.

> 2) It seems likely that at some point the OEM will swap to B1 revision
>    SoCs. The i2c device then does not require this quirk, but we have
>    hard coded in the DT file that it is required. B1 revision would
>    work, but not optimally.

The quirk can go both ways.  eg, we can detect that we *aren't* on an A0
and need to remove the compatible string.

> So i would prefer not to explicitly enable the quirk, but determine at
> run time if the quirk is needed for the SoC revision it is running on.

I agree, but that is Linux-centric.  We need to handle it coherently in
the binding docs for *BSD, bootloaders, etc.

I suggest we update the binding to allow using the compatible string,
and advise that to avoid end-user frustration, implementations should
detect the SoC revision at runtime and either add or remove the
compatible string.

thx,

Jason.
