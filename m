Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaJCWGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:06:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbaJCWGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:06:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 125/238] regmap: Dont attempt block writes when syncing cache on single_rw devices
Date: Fri,  3 Oct 2014 14:30:40 -0700
Message-Id: <20141003212917.677897379@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 5c1ebe7f73f9166893c3459915db8a09d6d1d715 upstream.

If the device can't support block writes then don't attempt to use raw
syncing which will automatically generate block writes for adjacent
registers, use the existing _single() block syncing implementation.

Reported-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -701,7 +701,7 @@ int regcache_sync_block(struct regmap *m
 			unsigned int block_base, unsigned int start,
 			unsigned int end)
 {
-	if (regmap_can_raw_write(map))
+	if (regmap_can_raw_write(map) && !map->use_single_rw)
 		return regcache_sync_block_raw(map, block, cache_present,
 					       block_base, start, end);
 	else


