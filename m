Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaEVRlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:41:11 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:23355 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbaEVRlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:41:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQLAD82flNbsFZY/2dsb2JhbABZgwerCgoFAYM6lwGBDRd0gmYcIxiBAiQTiEUB1wOFVYh5hEcBA48/ijEBixeID4M6Ow
Date: Thu, 22 May 2014 19:41:07 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 1/1] lib/nlattr.c: move EXPORT_SYMBOL after functions
Message-Id: <20140522194107.1d0e8ed0f81f0be48fc8063a@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some checkpatch warnings:
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

Cc: Pablo Neira <pablo@netfilter.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/nlattr.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index fc67547..0c57787 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -136,6 +136,7 @@ int nla_validate(const struct nlattr *head, int len, int maxtype,
 errout:
 	return err;
 }
+EXPORT_SYMBOL(nla_validate);
 
 /**
  * nla_policy_len - Determin the max. length of a policy
@@ -162,6 +163,7 @@ nla_policy_len(const struct nla_policy *p, int n)
 
 	return len;
 }
+EXPORT_SYMBOL(nla_policy_len);
 
 /**
  * nla_parse - Parse a stream of attributes into a tb buffer
@@ -208,6 +210,7 @@ int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 errout:
 	return err;
 }
+EXPORT_SYMBOL(nla_parse);
 
 /**
  * nla_find - Find a specific attribute in a stream of attributes
@@ -228,6 +231,7 @@ struct nlattr *nla_find(const struct nlattr *head, int len, int attrtype)
 
 	return NULL;
 }
+EXPORT_SYMBOL(nla_find);
 
 /**
  * nla_strlcpy - Copy string attribute payload into a sized buffer
@@ -258,6 +262,7 @@ size_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize)
 
 	return srclen;
 }
+EXPORT_SYMBOL(nla_strlcpy);
 
 /**
  * nla_memcpy - Copy a netlink attribute into another memory area
@@ -278,6 +283,7 @@ int nla_memcpy(void *dest, const struct nlattr *src, int count)
 
 	return minlen;
 }
+EXPORT_SYMBOL(nla_memcpy);
 
 /**
  * nla_memcmp - Compare an attribute with sized memory area
@@ -295,6 +301,7 @@ int nla_memcmp(const struct nlattr *nla, const void *data,
 
 	return d;
 }
+EXPORT_SYMBOL(nla_memcmp);
 
 /**
  * nla_strcmp - Compare a string attribute against a string
@@ -317,6 +324,7 @@ int nla_strcmp(const struct nlattr *nla, const char *str)
 
 	return d;
 }
+EXPORT_SYMBOL(nla_strcmp);
 
 #ifdef CONFIG_NET
 /**
@@ -502,12 +510,3 @@ int nla_append(struct sk_buff *skb, int attrlen, const void *data)
 }
 EXPORT_SYMBOL(nla_append);
 #endif
-
-EXPORT_SYMBOL(nla_validate);
-EXPORT_SYMBOL(nla_policy_len);
-EXPORT_SYMBOL(nla_parse);
-EXPORT_SYMBOL(nla_find);
-EXPORT_SYMBOL(nla_strlcpy);
-EXPORT_SYMBOL(nla_memcpy);
-EXPORT_SYMBOL(nla_memcmp);
-EXPORT_SYMBOL(nla_strcmp);
-- 
1.8.4.5

