Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab3JNThB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:37:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37989 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3JNTg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:36:59 -0400
Message-ID: <525C47C0.2000907@infradead.org>
Date: Mon, 14 Oct 2013 12:36:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: Mark Brown <broonie@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: [PATCH -next] netdev: inet_timewait_sock.h missing semi-colon when
 KMEMCHECK is enabled
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
In-Reply-To: <1381762088-18880-1-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix (a few hundred) build errors due to missing semi-colon when
KMEMCHECK is enabled:

  include/net/inet_timewait_sock.h:139:2: error: expected ',', ';' or '}' before 'int'
  include/net/inet_timewait_sock.h:148:28: error: 'const struct inet_timewait_sock' has no member named 'tw_death_node'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 include/net/inet_timewait_sock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next-2013-1014.orig/include/net/inet_timewait_sock.h
+++ next-2013-1014/include/net/inet_timewait_sock.h
@@ -135,7 +135,7 @@ struct inet_timewait_sock {
 				tw_transparent  : 1,
 				tw_pad		: 6,	/* 6 bits hole */
 				tw_tos		: 8,
-				tw_pad2		: 16 /* 16 bits hole */
+				tw_pad2		: 16;	/* 16 bits hole */
 	kmemcheck_bitfield_end(flags);
 	u32			tw_ttd;
 	struct inet_bind_bucket	*tw_tb;
