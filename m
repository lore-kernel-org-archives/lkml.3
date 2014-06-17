Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbaFQOar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:30:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49468 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaFQOap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:30:45 -0400
Message-ID: <53A0510E.1010909@oracle.com>
Date: Tue, 17 Jun 2014 22:30:38 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/24] drivers/of: return actual error on of_init
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

Return the actual error code if call kset_create_and_add() failed

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 drivers/of/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 8368d96..8f8efa1 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -290,9 +290,9 @@ static int __init of_init(void)
 	/* Create the kset, and register existing nodes */
 	mutex_lock(&of_aliases_mutex);
 	of_kset = kset_create_and_add("devicetree", NULL, firmware_kobj);
-	if (!of_kset) {
+	if (IS_ERR(of_kset)) {
 		mutex_unlock(&of_aliases_mutex);
-		return -ENOMEM;
+		return PTR_ERR(of_kset);
 	}
 	for_each_of_allnodes(np)
 		__of_node_add(np);
-- 
1.8.3.2
