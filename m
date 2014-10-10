Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaJJXUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 19:20:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:39237 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaJJXUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 19:20:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,695,1406617200"; 
   d="scan'208";a="612736205"
From: Andi Kleen <andi@firstfloor.org>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, hpa@zytor.com
Subject: [PATCH] kbuild: Fix cleanpatch to always replace leading space with tab
Date: Fri, 10 Oct 2014 16:20:46 -0700
Message-Id: <1412983246-12118-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

If you have something like

<sp><sp><sp><sp><sp><sp><sp><sp>blabla

in a patch cleanpatch does not replace the spaces with tabs.
That is because it only handles space in front of tab.

But it's more convenient if it also replaces space with tabs,
even if there is no tab at all, as that is what checkpatch
and other pedants expect.

Cc: hpa@zytor.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/cleanpatch | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/cleanpatch b/scripts/cleanpatch
index 9680d03..d14aac9 100755
--- a/scripts/cleanpatch
+++ b/scripts/cleanpatch
@@ -39,6 +39,10 @@ sub clean_space_tabs($)
 	} elsif ($c eq " ") {
 	    $nsp++;
 	} else {
+	    while ($nsp >= 8) {
+	        $lo .= "\t";
+		$nsp -= 8;
+	    }
 	    $lo .= " " x $nsp;
 	    $pos += $nsp;
 	    $nsp = 0;
-- 
1.9.3

