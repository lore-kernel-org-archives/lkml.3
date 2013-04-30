Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159Ab3D3HLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:11:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57257 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab3D3HL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:11:27 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 4/4] OF: modify function stubs to match proper function declarations.
Date: Tue, 30 Apr 2013 09:11:23 +0200
Message-Id: <1367305883-2997-5-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
References: <1367305883-2997-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:hjiqhOo1zdVNSjgc7aET4anfgjI971g8P1VmhwyiS2g
 etSYjXhe/ptU7LXGAmg883mZXw27DGyIpATbpQFa2KwRwTUskR
 WEHMnvTv98UALQJ9PZTTcHzz2Te9AmvRMkVm3Xi4X54iFdYl94
 esUfmmMfFhC+Qm/FTt3RaDXQjZMJ9Na60b11LaM5VUMQMAKzzB
 HiUQq+Wb5q7zSnB6ldBlHcpzBv9yz1f5ATNnBG6cd7qu3T6rbE
 am/+Pk2eb9O21chMFNIRHWz7P9FwhHy/EZ57Onq6hSzs7WntHl
 hrMrmvht8Rc45CnD7PTxdvH/yf36LcW52O1vy6I9kpZC+9HOEk
 nA/V71xWuvCLuQo67EU/dPeJZkmXF6IMfRNcUONoZEy88OndZ9
 tuXORPDT5AnPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_parse_phandle_with_args() and of_count_phandle_with_args() functions
are declared with their first parameter as const. However, their
respective stubs, used when CONFIG_OF isn't defined, don't have the "const"
modifier. This patch adds it to fix the mismatch.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 include/linux/of.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 30ae71f..d9dbf73 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -466,7 +466,7 @@ static inline struct device_node *of_parse_phandle(const struct device_node *np,
 	return NULL;
 }
 
-static inline int of_parse_phandle_with_args(struct device_node *np,
+static inline int of_parse_phandle_with_args(const struct device_node *np,
 					     const char *list_name,
 					     const char *cells_name,
 					     int index,
@@ -485,7 +485,7 @@ static inline int of_parse_phandle_with_child_args(const struct device_node *np,
 	return -ENOSYS;
 }
 
-static inline int of_count_phandle_with_args(struct device_node *np,
+static inline int of_count_phandle_with_args(const struct device_node *np,
 					     const char *list_name,
 					     const char *cells_name)
 {
-- 
1.7.2.5

