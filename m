Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaLVSgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:36:43 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:3485 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754513AbaLVSgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:36:41 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwPALBjmFRXQ5YW/2dsb2JhbABbgwaBKrQDBQEBAQEBAQUBd5coBAKBHBcBAQEBAX2EaSOBGjeIMAHAHZBThgCJDmQdhBMFlwORSyKBRQGCKT0xgQOBQAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] netfilter: remove unnecessary sizeof(char)
Date: Mon, 22 Dec 2014 19:36:15 +0100
Message-Id: <1419273375-24312-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(char) is always 1.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/netfilter/nf_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 43c926c..1191f66 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -426,7 +426,7 @@ static int netfilter_log_sysctl_init(struct net *net)
 				nf_log_sysctl_fnames[i];
 			nf_log_sysctl_table[i].data = NULL;
 			nf_log_sysctl_table[i].maxlen =
-				NFLOGGER_NAME_LEN * sizeof(char);
+				NFLOGGER_NAME_LEN;
 			nf_log_sysctl_table[i].mode = 0644;
 			nf_log_sysctl_table[i].proc_handler =
 				nf_log_proc_dostring;
-- 
1.9.1

