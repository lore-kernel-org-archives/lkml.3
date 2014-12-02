Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaLBJ1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:27:19 -0500
Received: from hofr.at ([212.69.189.236]:53661 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbaLBJ1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:27:18 -0500
Date: Tue, 2 Dec 2014 10:18:36 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] additional external module symbol dependecy handling
	options
Message-ID: <20141202091836.GG13909@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


additional external module symbol dependecy handling options

The use of KBUILD_EXTRA_SYMBOLS is clarified by an example and
the additional option of using  KBUILD_EXTMOD is added as
equivalent alternative.

This patch is against linux 3.18.0-rc6

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 Documentation/kbuild/modules.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/kbuild/modules.txt b/Documentation/kbuild/modules.txt
index 3fb39e0..450af1f 100644
--- a/Documentation/kbuild/modules.txt
+++ b/Documentation/kbuild/modules.txt
@@ -517,6 +517,18 @@ build.
 		These files will be loaded by modpost during the
 		initialization of its symbol tables.
 
+		Example:
+			$ make KBUILD_EXTRA_SYMBOLS=/PATH/TO/bar/Module.symvers \
+			  -C $KDIR M=$PWD modules
+
+	Use "make" variable KBUILD_EXTMOD
+		Alternatively to passing the Module.symvers files explicitly
+		one can also pass the directory containing the external module
+		that will satisfy the dependecies with KBUILD_EXTMOD and
+		Kbuild will pick up the Module.symvers found there.
+
+		Example:
+			$ make -C $KDIR M=$PWD KBUILD_EXTMOD=/PATH/TO/bar/ modules
 
 === 7. Tips & Tricks
 
-- 
1.7.10.4

