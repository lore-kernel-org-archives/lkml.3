Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966479Ab3HIKP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:15:56 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:13644 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965802Ab3HIKPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:15:55 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Aug 2013 06:15:55 EDT
Message-ID: <5204BFCB.6020800@nsn.com>
Date: Fri, 09 Aug 2013 12:09:15 +0200
From: Ionut Nicu <ioan.nicu.ext@nsn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] regmap: fix regcache_reg_present() for empty cache
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 976
X-purgate-ID: 151667::1376042957-0000471E-8267B587/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the initial case when no reg_defaults values are
provided and no register value was added to the cache
yet, the cache_present bitmap is NULL. If this function
is invoked for any register it should return false
(i.e. the register is not cached) instead of true.

Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
---
 drivers/base/regmap/internal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 29c8316..5308e3e 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -223,7 +223,7 @@ int regcache_set_reg_present(struct regmap *map, unsigned int reg);
 static inline bool regcache_reg_present(struct regmap *map, unsigned int reg)
 {
 	if (!map->cache_present)
-		return true;
+		return false;
 	if (reg > map->cache_present_nbits)
 		return false;
 	return map->cache_present[BIT_WORD(reg)] & BIT_MASK(reg);
-- 
1.7.1

