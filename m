Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab3BEWMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:12:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48240 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3BEWMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:12:40 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 79/93] x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI
Date: Tue,  5 Feb 2013 20:07:08 -0200
Message-Id: <1360102042-10732-80-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit e43b3cec711a61edf047adf6204d542f3a659ef8 upstream.

early_pci_allowed() and read_pci_config_16() are only available if
CONFIG_PCI is defined.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/kernel/setup.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 8ac6c8a..1cb892f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -615,6 +615,7 @@ static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
 
 static bool __init snb_gfx_workaround_needed(void)
 {
+#ifdef CONFIG_PCI
 	int i;
 	u16 vendor, devid;
 	static const __initconst u16 snb_ids[] = {
@@ -639,6 +640,7 @@ static bool __init snb_gfx_workaround_needed(void)
 	for (i = 0; i < ARRAY_SIZE(snb_ids); i++)
 		if (devid == snb_ids[i])
 			return true;
+#endif
 
 	return false;
 }
-- 
1.7.9.5

