Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab3IHDT6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56088 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320Ab3IHDSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.929768188@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [089/121] Revert "PM / Domains: Fix handling of wakeup devices
 during system resume"
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit 5c6156fac087f551cbd57499f4bed2fc614d70cd, which
was commit cc85b20780562d404e18a47b9b55b4a5102ae53e upstream.

It broke ARM && PM configurations by adding a call to
genpd_dev_active_wakeup() which was only added in Linux 3.3.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -751,8 +751,7 @@
 	if (IS_ERR(genpd))
 		return -EINVAL;
 
-	if (genpd->suspend_power_off
-	    || (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev)))
+	if (genpd->suspend_power_off)
 		return 0;
 
 	/*

