Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab3HQAar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:30:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51362 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab3HPWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:35:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 006/133] Tools: hv: KVP: Fix a bug in IPV6 subnet enumeration
Date: Fri, 16 Aug 2013 15:32:28 -0700
Message-Id: <1376692475-28413-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit ed4bb9744b41d39ba35080c2390e201575121dc7 upstream.

Each subnet string needs to be separated with a semicolon. Fix this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 tools/hv/hv_kvp_daemon.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index d25a469..f0e1810 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1012,9 +1012,10 @@ kvp_get_ip_info(int family, char *if_name, int op,
 
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
1.8.1.2

