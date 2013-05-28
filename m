Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab3E1Dyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:54:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52497 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758794Ab3E1DyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.492145735@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [57/94] perf: net_dropmonitor: Fix symbol-relative addresses
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 5a1e99dd2028e00998d42029be86835d8ef4a46e upstream.

The comparison between traced and symbol addresses is backwards: if
the traced address doesn't exactly match a symbol (which we don't
expect it to), we'll show the next symbol and the offset to it,
whereas we should show the previous symbol and the offset from it.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 tools/perf/scripts/python/net_dropmonitor.py |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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

