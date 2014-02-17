Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaBQJTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:19:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43446 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaBQJS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:18:59 -0500
Date: Mon, 17 Feb 2014 10:18:40 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Alexander Shiyan <shc_work@mail.ru>, Russell King <linux@arm.linux.org.uk>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: imx: remove MACH_MXLADS
Message-ID: <20140217091840.GO17250@pengutronix.de>
References: <1392573811.28866.22.camel@x220>
 <1392578464.996901773@f49.i.mail.ru>
 <1392582900.28866.85.camel@x220>
 <1392612187.657010375@f87.i.mail.ru>
 <1392627768.10966.23.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392627768.10966.23.camel@x220>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:06:19 up 176 days, 18:37, 54 users,  load average: 0.16, 0.11,
 0.09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 10:02:48AM +0100, Paul Bolle wrote:
> On Mon, 2014-02-17 at 08:43 +0400, Alexander Shiyan wrote:
> > It seems that even in the current state, Kconfig for i.MX contains an error.
> > As a start, we should rename ARCH_MX1ADS to MACH_MX1ADS first.

No. Have a look at arch/arm/tools/mach-types:

mxlads                  MACH_MXLADS             MXLADS	1851
mx1ads                  ARCH_MX1ADS             MX1ADS  160

And what gen-mach-types makes from it:

#ifdef CONFIG_MACH_MXLADS
# ifdef machine_arch_type
#  undef machine_arch_type
#  define machine_arch_type     __machine_arch_type
# else
#  define machine_arch_type     MACH_TYPE_MXLADS
# endif
# define machine_is_mxlads()    (machine_arch_type == MACH_TYPE_MXLADS)
#else
# define machine_is_mxlads()    (0)
#endif

#ifdef CONFIG_ARCH_MX1ADS
# ifdef machine_arch_type
#  undef machine_arch_type
#  define machine_arch_type     __machine_arch_type
# else
#  define machine_arch_type     MACH_TYPE_MX1ADS
# endif
# define machine_is_mx1ads()    (machine_arch_type == MACH_TYPE_MX1ADS)
#else
# define machine_is_mx1ads()    (0)
#endif

So machine_is_mx1ads() can only ever evaluate to true when
CONFIG_ARCH_MX1ADS is set and machine_is_mxlads() can only evaluate to true
when CONFIG_MACH_MXLADS is set.

Whether to use ARCH or MACH simply depends on what Russell has in the
machine registry database for a given board.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
