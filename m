Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbaJ2Jdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:33:33 -0400
Received: from bes.se.axis.com ([195.60.68.10]:33562 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbaJ2Jd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:33:28 -0400
Date: Wed, 29 Oct 2014 10:33:20 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jesper Nilsson <jespern@axis.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: CRISv32: ETRAX_SPI_MMC_BOARD
Message-ID: <20141029093320.GQ30087@axis.com>
References: <1414570854.28499.34.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414570854.28499.34.camel@x220>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 09:20:54AM +0100, Paul Bolle wrote:
> Jesper,

Hi Paul!

> Your commit be64c1ce6e79 ("CRISv32: Drop obsolete file for SPI driver")
> landed in today's linux-next (ie, next-20141029). It removes the last
> user of the Kconfig symbol ETRAX_SPI_MMC_BOARD. Setting that symbol is
> now pointless.
> 
> Is the trivial patch to remove the entry for ETRAX_SPI_MMC_BOARD (and
> one select statement for it) queued somewhere? If not, should I submit
> it?

It was not, but it is now:

CRISv32: Remove last remnants of ETRAX_SPI_MMC_BOARD

There are no users of this symbol left.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/drivers/Kconfig |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index 6880f94..7068c4b 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -361,13 +361,6 @@ config ETRAX_SPI_MMC
 	default MMC
 	select SPI
 	select MMC_SPI
-	select ETRAX_SPI_MMC_BOARD
-
-# For the parts that can't be a module (due to restrictions in
-# framework elsewhere).
-config ETRAX_SPI_MMC_BOARD
-       boolean
-       default n
 
 # While the board info is MMC_SPI only, the drivers are written to be
 # independent of MMC_SPI, so we'll keep SPI non-dependent on the
-- 
1.7.10.4


I'll try to think about unreferenced kconfigs in the future,
my suspicion is that all those SPI and MMC related configs are
also unused, just circular references keeping them unnoticed.

Thanks for the heads up.

> Paul Bolle

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
