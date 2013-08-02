Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab3HBId4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:33:56 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23393 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017Ab3HBIdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:33:53 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18u2VnZ/RiNJ/0UPAXexxf7
Date: Fri, 2 Aug 2013 01:33:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] arch/arm SoC organization
Message-ID: <20130802083346.GC7656@atomide.com>
References: <20130731141841.GP5882@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731141841.GP5882@titan.lakedaemon.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Cooper <jason@lakedaemon.net> [130731 07:25]:
> All,
> 
> I'd like to take the opportunity to discuss the layout/config of the arm
> SoCs.  By the time the KS rolls around, we should have at least two or more
> use-cases to present and discuss (mvebu, bcm).
> 
> Between devicetree and multiplatform the concept of board-specific code
> is really disappearing in arm-land.  eg mach-kirkwood/ is almost fully
> converted, within the next window or two, we'll be moving all of the DT
> capable boards from kirkwood, orion5x, and dove over to mvebu.
> mach-mvebu will then hold 5 different SoCs (it already has Armada 370
> and Armada XP).
> 
> mach-bcm is in a similar situation (multi-SoC).  I'm sure there are
> others (nvidia, ti, etc).

Well we've pretty much always kept the omaps we can build together in
the same directory, otherwise we would be up to an insane number of
mach-omap related directories by now.. I think getting rid of the
mach- and plat- directories and making everything into drivers is
the next phase after device tree conversion is done.

> So, I'd like to propose we discuss some lessons learned and maybe arrive
> at some best practices.  eg, should we just go with mach-$COMPANY/?  How
> best to handle config symbols for efficient building?  Deprecation path
> for legacy (unconverted) boards?

A lot of that problem goes away by initializing everything as late
as possible, and making things to live under drivers. Of course it
may make sense to combine things meanwhile, but renaming things causes
quite a bit of churn.
 
> Also, to head off the demons, I am *not* proposing reorganizing
> everything.  Merely to find some consensus and good ideas so that as
> things merge together, we are mostly on the same page.
> 
> I'm sure we all have different ideas and I think it'd be good to hear
> what everyone else is thinking.

Yes sharing experiences on this stuff would be good de-briefing and
could help others :)

Regards,

Tony
