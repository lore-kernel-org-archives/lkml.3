Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3K1Jyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:54:46 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38085 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab3K1Jyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:54:43 -0500
Message-ID: <1385632196.5838.4.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCH 3/3] ARM: tegra: set SM2 voltage correct
From: Lucas Stach <l.stach@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Stefan Agner <stefan@agner.ch>, thierry.reding@gmail.com,
        sameo@linux.intel.com, dev@lynxeye.de, mark.rutland@arm.com,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 28 Nov 2013 10:49:56 +0100
In-Reply-To: <5296281C.1060403@wwwdotorg.org>
References: <cover.1385508112.git.stefan@agner.ch>
	 <c9ceead9e3df77b5a33ad654db23c241cd624096.1385508112.git.stefan@agner.ch>
	 <5296281C.1060403@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 27.11.2013, 10:13 -0700 schrieb Stephen Warren:
> On 11/26/2013 04:45 PM, Stefan Agner wrote:
> > Set the requested SM2 voltage to the correct value of 1.8V. The value
> > before used to work on TPS658623 since the driver applied a wrong
> > voltage table too. However, the TPS658643 used on newer devices uses
> > yet another voltage table and those broke that compatibility. The
> > regulator driver now has the correct voltage table for both regulator
> > versions and those the correct voltage can be used in this device
> > tree.
> 
> One thing you haven't called out explicitly here is that this series is
> an incompatible change to the DT, since the old buggy driver used to
> allow old buggy DT content to accidentally work.
> 
The current (wrong and potentially dangerous) DT content only worked on
the engineering sample models. So this change definitely does improve
the situation, even with the risk of breaking a small fraction of
working boards.

> I'm not too familiar with who's using mainline on the Colibri boards.
> Hopefully everyone doing that is using in-kernel DTs, so this
> incompatible change won't be any issue for anyone.
> 
I know of some parties using mainline, but I think everyone so far is
able to use DTs bundled with the kernel.

Regards,
Lucas
-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

