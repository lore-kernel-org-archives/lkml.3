Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab3CLFlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:41:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64968 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab3CLFlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:41:22 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856540"
Message-ID: <513EBFA3.4070303@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 13:39:47 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-sctp@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/18] net: sctp: remove cast for kmalloc/kzalloc return value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:40:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:40:08,
	Serialize complete at 2013/03/12 13:40:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kmalloc/kzalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-sctp@vger.kernel.org
---
 include/net/sctp/sctp.h |    2 +-
 net/sctp/protocol.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index df85a0c..cd89510 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -576,7 +576,7 @@ for (pos = chunk->subh.fwdtsn_hdr->skip;\
 #define WORD_ROUND(s) (((s)+3)&~3)
 
 /* Make a new instance of type.  */
-#define t_new(type, flags)	(type *)kzalloc(sizeof(type), flags)
+#define t_new(type, flags)	kzalloc(sizeof(type), flags)
 
 /* Compare two timevals.  */
 #define tv_lt(s, t) \
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 1c2e46c..eaee00c 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1403,7 +1403,7 @@ SCTP_STATIC __init int sctp_init(void)
 
 	/* Allocate and initialize the endpoint hash table.  */
 	sctp_ep_hashsize = 64;
-	sctp_ep_hashtable = (struct sctp_hashbucket *)
+	sctp_ep_hashtable =
 		kmalloc(64 * sizeof(struct sctp_hashbucket), GFP_KERNEL);
 	if (!sctp_ep_hashtable) {
 		pr_err("Failed endpoint_hash alloc\n");
-- 
1.7.1

