Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbbAOWKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:10:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50410 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbbAOWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Whitcroft <apw@canonical.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 01/19] [3.13-stable only] ipv6: fix swapped ipv4/ipv6 mtu_reduced callbacks
Date: Thu, 15 Jan 2015 14:09:37 -0800
Message-Id: <1421359795-11155-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421359795-11155-1-git-send-email-kamal@canonical.com>
References: <1421359795-11155-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Whitcroft <apw@canonical.com>

Fixes up 4fab907195 ("tcp: fix tcp_release_cb() to dispatch via address
family for mtu_reduced()") backport which has swapped ipv4/ipv6 callbacks
for native IPv6 and mapped IPv4 sockets.

BugLink: http://bugs.launchpad.net/bugs/1404558
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Fixes: e86507f2371b667b74e731e366fff55844e79463
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/tcp_ipv6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d83045c..d540da2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1640,7 +1640,7 @@ static const struct inet_connection_sock_af_ops ipv6_specific = {
 	.compat_setsockopt = compat_ipv6_setsockopt,
 	.compat_getsockopt = compat_ipv6_getsockopt,
 #endif
-	.mtu_reduced	   = tcp_v4_mtu_reduced,
+	.mtu_reduced	   = tcp_v6_mtu_reduced,
 };
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -1672,7 +1672,7 @@ static const struct inet_connection_sock_af_ops ipv6_mapped = {
 	.compat_setsockopt = compat_ipv6_setsockopt,
 	.compat_getsockopt = compat_ipv6_getsockopt,
 #endif
-	.mtu_reduced	   = tcp_v6_mtu_reduced,
+	.mtu_reduced	   = tcp_v4_mtu_reduced,
 };
 
 #ifdef CONFIG_TCP_MD5SIG
-- 
1.9.1

