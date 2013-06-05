Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab3FEVXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:23:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab3FEVMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:12:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/44] perf: net_dropmonitor: Fix trace parameter order
Date: Wed,  5 Jun 2013 14:12:13 -0700
Message-Id: <20130605211223.447931131@linuxfoundation.org>
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

commit 140c3c6a2bcd2c31e2f7f5a8d59689724776c8e5 upstream.

This works much better if we don't treat protocol numbers as addresses.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/scripts/python/net_dropmonitor.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


