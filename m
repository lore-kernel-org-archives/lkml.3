Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935324Ab3E2WZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:25:22 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35708 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935271Ab3E2WZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:25:06 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clement Chauplannaz <chauplac@gmail.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 1/3] scripts/config: fix assignment of parameters for short version of --*-after options
Date: Thu, 30 May 2013 00:24:53 +0200
Message-Id: <57a9c7609d7418ce75324df38f66cd7d937a77cb.1369866004.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1369866004.git.yann.morin.1998@free.fr>
References: <cover.1369866004.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1369866004.git.yann.morin.1998@free.fr>
References: <cover.1369866004.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clement Chauplannaz <chauplac@gmail.com>

When --*-after options are used, two parameters are parsed from the
command-line before the adequate function is called:
  - the `before' option, after which the new option will be inserted,
  - the name of the option to enable/disable/modularise.

With the short version of --*-after options (namely -E, -D, -M), the
parsing step is not performed which leads to processing unset variables.

Add options -E, -D, -M to the test that triggers assignment of parameters
for --*-after options.

Signed-off-by: Clement Chauplannaz <chauplac@gmail.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Yann E. MORIN <yann.morin.1998@free.fr>
---
 scripts/config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/config b/scripts/config
index bb4d3de..a65ecbb 100755
--- a/scripts/config
+++ b/scripts/config
@@ -105,7 +105,7 @@ while [ "$1" != "" ] ; do
 		;;
 	--refresh)
 		;;
-	--*-after)
+	--*-after|-E|-D|-M)
 		checkarg "$1"
 		A=$ARG
 		checkarg "$2"
-- 
1.8.1.2

