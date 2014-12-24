Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaLXPFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 10:05:06 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62448 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaLXPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 10:05:04 -0500
Message-ID: <549AD616.7070709@gmail.com>
Date: Wed, 24 Dec 2014 23:04:54 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu
CC: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH next] net: netfilter: nfnetlink_cthelper: Remove 'const' and
 '&' to avoid warnings
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The related code can be simplified, and also can avoid related warnings
(with allmodconfig under parisc):

    CC [M]  net/netfilter/nfnetlink_cthelper.o
  net/netfilter/nfnetlink_cthelper.c: In function ‘nfnl_cthelper_from_nlattr’:
  net/netfilter/nfnetlink_cthelper.c:97:9: warning: passing argument 1 o ‘memcpy’ discards ‘const’ qualifier from pointer target type [-Wdiscarded-array-qualifiers]
    memcpy(&help->data, nla_data(attr), help->helper->data_len);
           ^
  In file included from include/linux/string.h:17:0,
                   from include/uapi/linux/uuid.h:25,
                   from include/linux/uuid.h:23,
                   from include/linux/mod_devicetable.h:12,
                   from ./arch/parisc/include/asm/hardware.h:4,
                   from ./arch/parisc/include/asm/processor.h:15,
                   from ./arch/parisc/include/asm/spinlock.h:6,
                   from ./arch/parisc/include/asm/atomic.h:21,
                   from include/linux/atomic.h:4,
                   from ./arch/parisc/include/asm/bitops.h:12,
                   from include/linux/bitops.h:36,
                   from include/linux/kernel.h:10,
                   from include/linux/list.h:8,
                   from include/linux/module.h:9,
                   from net/netfilter/nfnetlink_cthelper.c:11:
  ./arch/parisc/include/asm/string.h:8:8: note: expected ‘void *’ but argument is of type ‘const char (*)[]’
   void * memcpy(void * dest,const void *src,size_t count);
          ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 net/netfilter/nfnetlink_cthelper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 9e287cb..a5599fc 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -86,7 +86,7 @@ nfnl_cthelper_parse_tuple(struct nf_conntrack_tuple *tuple,
 static int
 nfnl_cthelper_from_nlattr(struct nlattr *attr, struct nf_conn *ct)
 {
-	const struct nf_conn_help *help = nfct_help(ct);
+	struct nf_conn_help *help = nfct_help(ct);
 
 	if (attr == NULL)
 		return -EINVAL;
@@ -94,7 +94,7 @@ nfnl_cthelper_from_nlattr(struct nlattr *attr, struct nf_conn *ct)
 	if (help->helper->data_len == 0)
 		return -EINVAL;
 
-	memcpy(&help->data, nla_data(attr), help->helper->data_len);
+	memcpy(help->data, nla_data(attr), help->helper->data_len);
 	return 0;
 }
 
-- 
1.7.9.5
