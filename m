Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab3CSJgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:36:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab3CSJgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:36:17 -0400
Date: Tue, 19 Mar 2013 10:36:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH][RESEND] [IA64] tiocx: check retval from bus_register()
Message-ID: <alpine.LNX.2.00.1303191035010.9529@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly check return value from bus_register() and propagate it out of 
tiocx_init() in case of failure.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/ia64/sn/kernel/tiocx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/sn/kernel/tiocx.c b/arch/ia64/sn/kernel/tiocx.c
index 14c1711..e35f648 100644
--- a/arch/ia64/sn/kernel/tiocx.c
+++ b/arch/ia64/sn/kernel/tiocx.c
@@ -490,11 +490,14 @@ static int __init tiocx_init(void)
 {
 	cnodeid_t cnodeid;
 	int found_tiocx_device = 0;
+	int err;
 
 	if (!ia64_platform_is("sn2"))
 		return 0;
 
-	bus_register(&tiocx_bus_type);
+	err = bus_register(&tiocx_bus_type);
+	if (err)
+		return err;
 
 	for (cnodeid = 0; cnodeid < num_cnodes; cnodeid++) {
 		nasid_t nasid;

-- 
Jiri Kosina
SUSE Labs
