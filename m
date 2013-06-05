Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab3FEVNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:13:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558Ab3FEVNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:13:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 16/44] perf: net_dropmonitor: Fix symbol-relative addresses
Date: Wed,  5 Jun 2013 14:12:14 -0700
Message-Id: <20130605211223.540219682@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605211221.858177087@linuxfoundation.org>
References: <20130605211221.858177087@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 5a1e99dd2028e00998d42029be86835d8ef4a46e upstream.

The comparison between traced and symbol addresses is backwards: if
the traced address doesn't exactly match a symbol (which we don't
expect it to), we'll show the next symbol and the offset to it,
whereas we should show the previous symbol and the offset from it.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


