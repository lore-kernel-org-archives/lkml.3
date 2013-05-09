Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab3EIW5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:57:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657Ab3EIWcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 21/73] netfilter: ipset: "Directory not empty" error message
Date: Thu,  9 May 2013 15:31:44 -0700
Message-Id: <20130509222800.275985767@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

commit dd82088dab3646ed28e4aa43d1a5b5d5ffc2afba upstream.

When an entry flagged with "nomatch" was tested by ipset, it
returned the error message "Kernel error received:
Directory not empty" instead of "<element> is NOT in set <setname>"
(reported by John Brendler).

The internal error code was not properly transformed before returning
to userspace, fixed.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipset/ip_set_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1470,7 +1470,8 @@ ip_set_utest(struct sock *ctnl, struct s
 	if (ret == -EAGAIN)
 		ret = 1;
 
-	return ret < 0 ? ret : ret > 0 ? 0 : -IPSET_ERR_EXIST;
+	return (ret < 0 && ret != -ENOTEMPTY) ? ret :
+		ret > 0 ? 0 : -IPSET_ERR_EXIST;
 }
 
 /* Get headed data of a set */


