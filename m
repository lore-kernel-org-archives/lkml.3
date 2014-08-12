Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaHLCSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:18:47 -0400
Received: from linuxhacker.ru ([217.76.32.60]:34493 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbaHLCSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:18:46 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH] staging/lustre/lnet: Fix potential uninitialized variable warning
Date: Mon, 11 Aug 2014 22:18:29 -0400
Message-Id: <1407809909-1776-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg reports that with one of the patches in his queue
there's now an unused variable warning in lnet_parse_ip2nets
for ipaddrs variable.
Apparently the warning is a false positive as in all cases where
lnet_ipaddr_enumerate can return without setting ipaddrs to something
a negative return value is returned that is then checked
before we actually use ipaddrs.

Assign ipaddrs to NULL to quiet this.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 drivers/staging/lustre/lnet/lnet/config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/lnet/config.c b/drivers/staging/lustre/lnet/lnet/config.c
index 7c8b947..d77aa31 100644
--- a/drivers/staging/lustre/lnet/lnet/config.c
+++ b/drivers/staging/lustre/lnet/lnet/config.c
@@ -1187,7 +1187,7 @@ lnet_ipaddr_enumerate(__u32 **ipaddrsp)
 int
 lnet_parse_ip2nets(char **networksp, char *ip2nets)
 {
-	__u32     *ipaddrs;
+	__u32     *ipaddrs = NULL;
 	int	nip = lnet_ipaddr_enumerate(&ipaddrs);
 	int	rc;
 
-- 
1.9.0

