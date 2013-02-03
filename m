Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab3BCO6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:58:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34580 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960Ab3BCO6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:13 -0500
Message-Id: <20130203144653.839189623@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 111/128] x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit e43b3cec711a61edf047adf6204d542f3a659ef8 upstream.

early_pci_allowed() and read_pci_config_16() are only available if
CONFIG_PCI is defined.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/setup.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 18182d1..00f6c14 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -612,6 +612,7 @@ static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
 
 static bool __init snb_gfx_workaround_needed(void)
 {
+#ifdef CONFIG_PCI
 	int i;
 	u16 vendor, devid;
 	static const __initconst u16 snb_ids[] = {
@@ -636,6 +637,7 @@ static bool __init snb_gfx_workaround_needed(void)
 	for (i = 0; i < ARRAY_SIZE(snb_ids); i++)
 		if (devid == snb_ids[i])
 			return true;
+#endif
 
 	return false;
 }


