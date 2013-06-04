Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab3FDRFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:05:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48583 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557Ab3FDRDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:03:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 41/75] perf: net_dropmonitor: Fix symbol-relative addresses
Date: Tue,  4 Jun 2013 09:55:25 -0700
Message-Id: <1370364959-9475-42-git-send-email-kamal@canonical.com>
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

commit 5a1e99dd2028e00998d42029be86835d8ef4a46e upstream.

The comparison between traced and symbol addresses is backwards: if
the traced address doesn't exactly match a symbol (which we don't
expect it to), we'll show the next symbol and the offset to it,
whereas we should show the previous symbol and the offset from it.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 tools/perf/scripts/python/net_dropmonitor.py | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/scripts/python/net_dropmonitor.py b/tools/perf/scripts/python/net_dropmonitor.py
index adbfbf0..4c11605 100755
--- a/tools/perf/scripts/python/net_dropmonitor.py
+++ b/tools/perf/scripts/python/net_dropmonitor.py
@@ -40,9 +40,9 @@ def get_kallsyms_table():
 
 def get_sym(sloc):
 	loc = int(sloc)
-	for i in kallsyms:
-		if (i['loc'] >= loc):
-			return (i['name'], i['loc']-loc)
+	for i in kallsyms[::-1]:
+		if loc >= i['loc']:
+			return (i['name'], loc - i['loc'])
 	return (None, 0)
 
 def print_drop_table():
-- 
1.8.1.2

