Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaJCWO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:14:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757985AbaJCWOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexey Perevalov <a.perevalov@samsung.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.14 225/238] netfilter: x_tables: allow to use default cgroup match
Date: Fri,  3 Oct 2014 14:32:20 -0700
Message-Id: <20141003212920.860525239@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit caa8ad94edf686d02b555c65a6162c0d1b434958 upstream.

There's actually no good reason why we cannot use cgroup id 0,
so lets just remove this artificial barrier.

Reported-by: Alexey Perevalov <a.perevalov@samsung.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Tested-by: Alexey Perevalov <a.perevalov@samsung.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -31,7 +31,7 @@ static int cgroup_mt_check(const struct
 	if (info->invert & ~1)
 		return -EINVAL;
 
-	return info->id ? 0 : -EINVAL;
+	return 0;
 }
 
 static bool


