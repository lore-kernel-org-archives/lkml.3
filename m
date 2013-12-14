Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3LNNVH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:21:07 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40162 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3LNNVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:21:05 -0500
Date: Sat, 14 Dec 2013 18:50:56 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, josh@joshtriplett.org
Subject: [PATCH] drivers: pnp: Mark the function pnp_build_option() as static
 in resource.c
Message-ID: <20131214132056.GA8624@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function pnp_build_option() as static in resource.c
because it is not used outside this file.

Thus, it also eliminates the following warning in resource.c:
drivers/pnp/resource.c:34:20: warning: no previous prototype for ‘pnp_build_option’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/pnp/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index d95e101..bacddd1 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -31,7 +31,7 @@ static int pnp_reserve_mem[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some
  * option registration
  */
 
-struct pnp_option *pnp_build_option(struct pnp_dev *dev, unsigned long type,
+static struct pnp_option *pnp_build_option(struct pnp_dev *dev, unsigned long type,
 				    unsigned int option_flags)
 {
 	struct pnp_option *option;
-- 
1.7.9.5

