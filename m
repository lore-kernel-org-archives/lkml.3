Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3LNNop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:44:45 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39035 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3LNNoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:44:44 -0500
Date: Sat, 14 Dec 2013 19:14:36 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <djbw@fb.com>, Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Rashika Kheria <rashika.kheria@gmail.com>, josh@joshtriplett.org
Subject: [PATCH] drivers: dca: Mark the function dca_common_get_tag() as
 static in dca-core.c
Message-ID: <20131214134436.GA13211@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function dca_common_get_tag() as static in
dca-core.c because it is not used outside this file.

Thus, it also eliminates the following warning in dca-core.c:
drivers/dca/dca-core.c:273:4: warning: no previous prototype for ‘dca_common_get_tag’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/dca/dca-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index 819dfda..9096e59 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -270,7 +270,7 @@ EXPORT_SYMBOL_GPL(dca_remove_requester);
  * @dev - the device that wants dca service
  * @cpu - the cpuid as returned by get_cpu()
  */
-u8 dca_common_get_tag(struct device *dev, int cpu)
+static u8 dca_common_get_tag(struct device *dev, int cpu)
 {
 	struct dca_provider *dca;
 	u8 tag;
-- 
1.7.9.5

