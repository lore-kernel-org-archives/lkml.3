Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaLOO6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:58:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38555 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaLOO2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 074/168] ARM: mvebu: add missing of_node_put() call in coherency.c
Date: Mon, 15 Dec 2014 14:25:28 +0000
Message-Id: <1418653622-21105-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 2eb04ae010a8fb165ba7aa56e9aa8e7980887dee upstream.

There is a missing of_node_put() to decrement the device_node
reference counter after a of_find_matching_node() in coherency_init().

Fixes: 501f928e0097 ("ARM: mvebu: add a coherency_available() call")
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Link: https://lkml.kernel.org/r/1414423955-5933-4-git-send-email-thomas.petazzoni@free-electrons.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-mvebu/coherency.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-mvebu/coherency.c
index 2bdc3233abe2..044b51185fcc 100644
--- a/arch/arm/mach-mvebu/coherency.c
+++ b/arch/arm/mach-mvebu/coherency.c
@@ -400,6 +400,8 @@ int __init coherency_init(void)
 		 type == COHERENCY_FABRIC_TYPE_ARMADA_380)
 		armada_375_380_coherency_init(np);
 
+	of_node_put(np);
+
 	return 0;
 }
 
-- 
2.1.3

