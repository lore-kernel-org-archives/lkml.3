Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbaBROen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:34:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:5554 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbaBRO3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:29:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="485209715"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 17/20] Kbuild, bloat-o-meter: Ignore .lto_priv postfix
Date: Tue, 18 Feb 2014 15:28:55 +0100
Message-Id: <1392733738-8290-18-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

gcc 4.9 may generate .lto_priv post fixes for LTO functions.
Ignore those for bloat-o-meter comparisons.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/bloat-o-meter | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
index 549d0ab..2becdf6 100755
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -23,6 +23,7 @@ def getsizes(file):
             if name == "linux_banner": continue
             # statics and some other optimizations adds random .NUMBER
             name = re.sub(r'\.[0-9]+', '', name)
+	    name = name.replace(".lto_priv", "")
             sym[name] = sym.get(name, 0) + int(size, 16)
     return sym
 
-- 
1.8.5.2

