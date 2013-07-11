Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3GKS0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 14:26:06 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:45956
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab3GKS0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:26:05 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, thozza@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Stable <stable@vger.kernel.org>
Subject: [PATCH 1/1] Tools: hv: KVP: Fix a bug in IPV6 subnet enumeration
Date: Thu, 11 Jul 2013 12:03:31 -0700
Message-Id: <1373569411-22138-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each subnet string needs to be separated with a semicolon. Fix this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: Stable <stable@vger.kernel.org>
---
 tools/hv/hv_kvp_daemon.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index ca9fa4d..07819bf 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1026,9 +1026,10 @@ kvp_get_ip_info(int family, char *if_name, int op,
 
 				if (sn_offset == 0)
 					strcpy(sn_str, cidr_mask);
-				else
+				else {
+					strcat((char *)ip_buffer->sub_net, ";");
 					strcat(sn_str, cidr_mask);
-				strcat((char *)ip_buffer->sub_net, ";");
+				}
 				sn_offset += strlen(sn_str) + 1;
 			}
 
-- 
1.7.4.1

