Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab3JCPK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:10:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55032 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3JCPK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:10:27 -0400
X-AuditID: cbfee68e-b7f756d000004512-31-524d88e12a4c
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH] sgi-xp: fix wrong usage of dev_set_name()
Date: Fri, 04 Oct 2013 00:10:20 +0900
Message-id: <1380813020-12246-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWyRsSkSPdhh2+QwfQluhZz1q9hs+if1sFq
	cXnXHDaLBXtKHFg8Tsz4zeLRt2UVo8fd6y+ZPD5vkgtgieKySUnNySxLLdK3S+DK2HdlA2PB
	eraKPe9XMzUwrmDtYuTkkBAwkVh0+xgjhC0mceHeerYuRi4OIYGljBIvHv5ghCn6u+kfmC0k
	sIhR4s8LL4iiNiaJTVsmgk1iE9CVeHLgMjOILSLgIXH/6GE2EJtZwFNi7uQuIJuDQ1jASmJd
	uwuIySKgKnHonS1IBS9Q9Y1t31hBwhICChJzJtmATJcQuM8m8aljC9h0FgEBiW+TD7FA1MhK
	bDrADHGZpMTBFTdYJjAKLmBkWMUomlqQXFCclF5kpFecmFtcmpeul5yfu4kRGIan/z3r28F4
	84D1IcZkoHETmaVEk/OBYZxXEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpR
	fFFpTmrxIUYmDk6pBsblRsy1MSnxNSLihrsqPPuC9i/M2/dij1Zw0mfLE9rm8jxTbWrzfD+Z
	XY5m25i5yea3+u2PxTOTH5xT8EwxetquLrTwx/aH61p3TzRWuqf4YobU8UOnI2UWbEo/zCxR
	Nut1/sTaj8/v7XoW9/GLgIbiiWeFxxas7tk9v7KzILR2Mdcaq7+PP6kpsRRnJBpqMRcVJwIA
	5euRoFkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jAd2HHb5BBvd+qVnMWb+GzaJ/Wger
	xeVdc9gsFuwpcWDxODHjN4tH35ZVjB53r79k8vi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCGMWPflQ2MBevZKva8X83UwLiCtYuRk0NCwETi76Z/jBC2mMSFe+vZ
	QGwhgUWMEn9eeHUxcgHZbUwSm7ZMBGtgE9CVeHLgMjOILSLgIXH/6GGwBmYBT4m5k7uAbA4O
	YQEriXXtLiAmi4CqxKF3tiAVvEDVN7Z9YwUJSwgoSMyZZDOBkXsBI8MqRtHUguSC4qT0XCO9
	4sTc4tK8dL3k/NxNjOAgfya9g3FVg8UhRgEORiUe3g3FvkFCrIllxZW5hxglOJiVRHjZqoBC
	vCmJlVWpRfnxRaU5qcWHGJOBdk9klhJNzgdGYF5JvKGxiZmRpZG5oYWRsTlpwkrivAdbrQOF
	BNITS1KzU1MLUotgtjBxcEo1MHJVSfKcnzO3ILyk63d6qPy2Or/POrIr33A5q+hU+vLHMN7+
	0+p3Q1ch6f3ETuMvUud4f6j+npp1XDmQ2y7/xMl9smH7fn2+pyQdZSlrVMsQ/XiC1DvW058j
	d/xfE5Mm8CuS01Yz81zmgxynFnfPbbKvdsxRjrt18IL1aoeLDx5Vyxq/ZkyrVmIpzkg01GIu
	Kk4EAEkCWl+2AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second parameter of dev_set_name() is format string. In order to
avoid any potential accidents such as segmentation fault, basic format
parameter "%s" should be used in this case.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 drivers/misc/sgi-xp/xpc_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index 82dc574..ed668ec 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -1233,8 +1233,8 @@ xpc_init(void)
 	int ret;
 	struct task_struct *kthread;
 
-	dev_set_name(xpc_part, "part");
-	dev_set_name(xpc_chan, "chan");
+	dev_set_name(xpc_part, "%s", "part");
+	dev_set_name(xpc_chan, "%s", "chan");
 
 	if (is_shub()) {
 		/*
-- 
1.7.9.5

