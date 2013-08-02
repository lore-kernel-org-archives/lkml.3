Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3HBKos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:44:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37345 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030277Ab3HBKKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:10:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [ 55/99] Tools: hv: KVP: Fix a bug in IPV6 subnet enumeration
Date: Fri,  2 Aug 2013 18:08:08 +0800
Message-Id: <20130802100233.690404959@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit ed4bb9744b41d39ba35080c2390e201575121dc7 upstream.

Each subnet string needs to be separated with a semicolon. Fix this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/hv/hv_kvp_daemon.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1016,9 +1016,10 @@ kvp_get_ip_info(int family, char *if_nam
 
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
 


