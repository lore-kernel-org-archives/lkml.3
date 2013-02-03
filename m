Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3BCL2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 06:28:54 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38165 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070Ab3BCL2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 06:28:53 -0500
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: fix missing dependencies for NETFILTER_XT_MATCH_CONNLABEL
Date: Sun,  3 Feb 2013 12:24:07 +0100
Message-Id: <1359890647-25846-1-git-send-email-fw@strlen.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <510DC976.7000008@infradead.org>
References: <510DC976.7000008@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was possible to set
NF_CONNTRACK=n
NF_CONNTRACK_LABELS=y

via NETFILTER_XT_MATCH_CONNLABEL=y:

warning: (NETFILTER_XT_MATCH_CONNLABEL) selects NF_CONNTRACK_LABELS which has
unmet direct dependencies (NET && INET && NETFILTER && NF_CONNTRACK)

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index eb2c8eb..d4dd702 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -860,6 +860,7 @@ config NETFILTER_XT_MATCH_CONNBYTES
 config NETFILTER_XT_MATCH_CONNLABEL
 	tristate '"connlabel" match support'
 	select NF_CONNTRACK_LABELS
+	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	---help---
 	  This match allows you to test and assign userspace-defined labels names
-- 
1.7.8.6

