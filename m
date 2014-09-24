Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaIXQKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:10:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51829 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751209AbaIXQKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:10:17 -0400
Date: Wed, 24 Sep 2014 18:10:09 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, u.kleine-koenig@pengutronix.de,
        gerg@uclinux.org, Olof Johansson <olof@lixom.net>,
        ARM Maintainers <arm@kernel.org>, linux-kernel@vger.kernel.org,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [RFC PATCH] ARM: at91: remove no-MMU at91x40 support
Message-ID: <20140924161009.GK3026@piout.net>
References: <1411568281-3924-1-git-send-email-nicolas.ferre@atmel.com>
 <3700375.DRR5iB2NGi@wuerfel>
 <5422DD2F.4090308@atmel.com>
 <3874734.x93Q9kHIES@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3874734.x93Q9kHIES@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/2014 at 17:09:14 +0200, Arnd Bergmann wrote :
> On Wednesday 24 September 2014 17:03:11 Nicolas Ferre wrote:
> > > I think these can be simplified further: AT91_SAM9G45_RESET and
> > > AT91_SAM9_ALT_RESET can just go away and the files put into
> > > obj-y.
> > 
> > Yes, I had the same idea before realizing that these two directives will
> > move away in a patch already sent for 3.18. So, as this material is
> > probably 3.19-ish, I kept them as they are and keep in mind to remove
> > them when I merge them with 3.18-rc1...
> 
> Ok.
> 
> > > OLD_CLK_AT91 is the same as AT91_USE_OLD_CLK, so you could
> > > just use that instead. I suspect the 'USE_OF' dependency for
> > > COMMON_CLK_AT91 can also go away, since all platforms are
> > > either board file based and select AT91_USE_OLD_CLK, or they
> > > are DT based and don't.
> > 
> > Here also, I didn't want to touch more because we need to remove the
> > arch/arm/mach-at91/Kconfig.non_dt file very soon (3.19) and I don't want
> > to change this file (or all the SoC files) before the chunks related to
> > these directives simply go away.
> > 
> > Tell me if it makes sense.
> 
> Yes, I agree your approach is better then.
> 

Yeah and what you proposed would actually break the possibility to
compile a kernel that can both boot DT and non DT platforms. My guess is
that this is why we have both OLD_CLK_AT91 and AT91_USE_OLD_CLK.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
