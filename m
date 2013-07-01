Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3GAUSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:18:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab3GAUKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tang Yuantian <Yuantian.Tang@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 23/26] of/base: release the node correctly in of_parse_phandle_with_args()
Date: Mon,  1 Jul 2013 13:10:18 -0700
Message-Id: <20130701200732.480333896@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200729.872850414@linuxfoundation.org>
References: <20130701200729.872850414@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tang Yuantian <yuantian.tang@freescale.com>

commit b855f16b05a697ac1863adabe99bfba56e6d3199 upstream.

Call of_node_put() only when the out_args is NULL on success,
or the node's reference count will not be correct because the caller
will call of_node_put() again.

Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
[grant.likely: tightened up the patch]
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/of/base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1166,11 +1166,11 @@ static int __of_parse_phandle_with_args(
 				out_args->args_count = count;
 				for (i = 0; i < count; i++)
 					out_args->args[i] = be32_to_cpup(list++);
+			} else {
+				of_node_put(node);
 			}
 
 			/* Found it! return success */
-			if (node)
-				of_node_put(node);
 			return 0;
 		}
 


