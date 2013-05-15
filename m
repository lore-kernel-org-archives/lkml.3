Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab3EOQJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:09:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758996Ab3EOQJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:09:32 -0400
Date: Wed, 15 May 2013 12:06:26 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mmarek@suse.cz
Subject: [PATCH] package: Makefile: unbreak binrpm-pkg target
Message-ID: <20130515120626.70a160aa@redhat.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6501320311664e11ad5489fedb17ea1f817c2617 dropped the rpm spec as a
prerequisite for the binrpm-pkg target but forgot to update $< usage,
which causes the rule to break.

This commit fixes that by replacing $< with the spec name.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
---
 scripts/package/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 84a4060..a4f31c9 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -63,7 +63,7 @@ binrpm-pkg: FORCE
 	mv -f $(objtree)/.tmp_version $(objtree)/.version
 
 	$(RPM) $(RPMOPTS) --define "_builddir $(objtree)" --target \
-		$(UTS_MACHINE) -bb $<
+		$(UTS_MACHINE) -bb $(objtree)/binkernel.spec
 	rm binkernel.spec
 
 # Deb target
-- 
1.8.1.4

