Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3CZUx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 16:53:27 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:33284 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3CZUx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 16:53:26 -0400
Date: Tue, 26 Mar 2013 22:53:19 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Message-ID: <20130326205319.GK14155@blackmetal.musicnaut.iki.fi>
References: <201302170046.26569@pali>
 <201303242345.00176@pali>
 <20130324230435.GE18316@opensource.wolfsonmicro.com>
 <201303261602.40219@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303261602.40219@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 26, 2013 at 04:02:39PM +0100, Pali Rohár wrote:
> CCing Aaro and Tony. Look at this thread on: 
> https://lkml.org/lkml/2013/2/16/152
> 
> What do you think how to fix this problem? I do not know about any 
> HW regulator for n900 accelerometer and possible solutions could 
> be revert that commit or adding fake regulator to board code...

I think the following should work:

...

From: Aaro Koskinen <aaro.koskinen@iki.fi>
Date: Tue, 26 Mar 2013 21:34:22 +0200
Subject: [PATCH] OMAP: RX-51: add missing regulator supply definitions for lis3lv02d

Add missing regulator definitions for lis3lv02d accelerometer. Fixes
the following probe issue:

[   57.737518] lis3lv02d_i2c 3-001d: Failed to get supply 'Vdd': -517
[   57.747100] i2c 3-001d: Driver lis3lv02d_i2c requests probe deferral

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 3a077df..1a88467 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -547,12 +547,16 @@ static struct regulator_consumer_supply rx51_vio_supplies[] = {
 	REGULATOR_SUPPLY("DVDD", "2-0019"),
 	/* Si4713 IO supply */
 	REGULATOR_SUPPLY("vio", "2-0063"),
+	/* lis3lv02d */
+	REGULATOR_SUPPLY("Vdd_IO", "3-001d"),
 };
 
 static struct regulator_consumer_supply rx51_vaux1_consumers[] = {
 	REGULATOR_SUPPLY("vdds_sdi", "omapdss"),
 	/* Si4713 supply */
 	REGULATOR_SUPPLY("vdd", "2-0063"),
+	/* lis3lv02d */
+	REGULATOR_SUPPLY("Vdd", "3-001d"),
 };
 
 static struct regulator_init_data rx51_vaux1 = {
-- 
1.7.10.4

A.
