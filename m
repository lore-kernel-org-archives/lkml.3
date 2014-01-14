Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaANAt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:49:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbaANA2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 14/77] net: drop_monitor: fix the value of maxattr
Date: Mon, 13 Jan 2014 16:27:35 -0800
Message-Id: <20140114002752.907177638@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

[ Upstream commit d323e92cc3f4edd943610557c9ea1bb4bb5056e8 ]

maxattr in genl_family should be used to save the max attribute
type, but not the max command type. Drop monitor doesn't support
any attributes, so we should leave it as zero.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/drop_monitor.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -64,7 +64,6 @@ static struct genl_family net_drop_monit
 	.hdrsize        = 0,
 	.name           = "NET_DM",
 	.version        = 2,
-	.maxattr        = NET_DM_CMD_MAX,
 };
 
 static DEFINE_PER_CPU(struct per_cpu_dm_data, dm_cpu_data);


