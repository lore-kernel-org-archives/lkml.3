Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab3GaOSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:18:53 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:37229 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756614Ab3GaOSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:18:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/IstYDPrZZp76gdO3cS/h6Z7bJWZWR3Qo=
Date: Wed, 31 Jul 2013 10:18:41 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [ARM ATTEND] arch/arm SoC organization
Message-ID: <20130731141841.GP5882@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

I'd like to take the opportunity to discuss the layout/config of the arm
SoCs.  By the time the KS rolls around, we should have at least two or more
use-cases to present and discuss (mvebu, bcm).

Between devicetree and multiplatform the concept of board-specific code
is really disappearing in arm-land.  eg mach-kirkwood/ is almost fully
converted, within the next window or two, we'll be moving all of the DT
capable boards from kirkwood, orion5x, and dove over to mvebu.
mach-mvebu will then hold 5 different SoCs (it already has Armada 370
and Armada XP).

mach-bcm is in a similar situation (multi-SoC).  I'm sure there are
others (nvidia, ti, etc).

So, I'd like to propose we discuss some lessons learned and maybe arrive
at some best practices.  eg, should we just go with mach-$COMPANY/?  How
best to handle config symbols for efficient building?  Deprecation path
for legacy (unconverted) boards?

Also, to head off the demons, I am *not* proposing reorganizing
everything.  Merely to find some consensus and good ideas so that as
things merge together, we are mostly on the same page.

I'm sure we all have different ideas and I think it'd be good to hear
what everyone else is thinking.

thx,

Jason.
