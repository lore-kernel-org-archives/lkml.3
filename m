Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaKZPkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:40:33 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:58448 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbaKZPka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:40:30 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH] of: remove select of non-existant OF_DEVICE config symbol
Date: Wed, 26 Nov 2014 15:40:24 +0000
Message-Id: <1417016424-9647-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OF_OVERLAY option selects OF_DEVICE, but OF_DEVICE was removed in
commit ba166e900b, "of: remove CONFIG_OF_DEVICE". Remove the unnecessary
select.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---

This fixes a bug in my devicetree/next branch which is included in
linux-next. It doesn't apply against mainline. I'll be applying it
directly to my tree.

 drivers/of/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 18b2e2539f84..b5e0c873d4e1 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -88,7 +88,6 @@ config OF_OVERLAY
 	bool
 	depends on OF
 	select OF_DYNAMIC
-	select OF_DEVICE
 	select OF_RESOLVE
 
 endmenu # OF
-- 
1.9.1

