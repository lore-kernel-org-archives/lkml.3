Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaBUIa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:30:57 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:55353 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaBUIa4 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 21 Feb 2014 03:30:56 -0500
X-Greylist: delayed 1230 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Feb 2014 03:30:56 EST
Date: Fri, 21 Feb 2014 16:13:30 +0800
From: Xudong Zhang <xdzhang@suse.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, felixmelon@gmail.com
Subject: [PATCH] There should have a warn/log when out-of-tree module is
 loaded
Message-ID: <20140221081330.GA11757@dell-zxd.apac.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can not get any hint when I found that my kernel is tainted (out of
tree module is loaded). And I checked all loaded and loadable modules
but it showed that all of them are intree modules.
I think we need a warn when out of tree module is loaded.

Signed-off-by: Xudong Zhang <xdzhang@suse.com>
---
 kernel/module.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index efa1e60..f80739f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2681,8 +2681,11 @@ static int check_modinfo(struct module *mod, struct load_info *info, int flags)
 		return -ENOEXEC;
 	}
 
-	if (!get_modinfo(info, "intree"))
+	if (!get_modinfo(info, "intree")) {
 		add_taint_module(mod, TAINT_OOT_MODULE, LOCKDEP_STILL_OK);
+		pr_warn("%s: out-of-tree module is loaded, kernel tainted.\n",
+				mod->name);
+	}
 
 	if (get_modinfo(info, "staging")) {
 		add_taint_module(mod, TAINT_CRAP, LOCKDEP_STILL_OK);
-- 
1.8.4.5

