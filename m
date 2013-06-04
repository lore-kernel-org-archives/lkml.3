Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab3FDRD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:03:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48638 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782Ab3FDRDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:03:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 40/75] perf: net_dropmonitor: Fix trace parameter order
Date: Tue,  4 Jun 2013 09:55:24 -0700
Message-Id: <1370364959-9475-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 140c3c6a2bcd2c31e2f7f5a8d59689724776c8e5 upstream.

This works much better if we don't treat protocol numbers as addresses.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 tools/perf/scripts/python/net_dropmonitor.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/scripts/python/net_dropmonitor.py b/tools/perf/scripts/python/net_dropmonitor.py
index a4ffc95..adbfbf0 100755
--- a/tools/perf/scripts/python/net_dropmonitor.py
+++ b/tools/perf/scripts/python/net_dropmonitor.py
@@ -64,7 +64,7 @@ def trace_end():
 
 # called from perf, when it finds a correspoinding event
 def skb__kfree_skb(name, context, cpu, sec, nsec, pid, comm,
-			skbaddr, protocol, location):
+		   skbaddr, location, protocol):
 	slocation = str(location)
 	try:
 		drop_log[slocation] = drop_log[slocation] + 1
-- 
1.8.1.2

