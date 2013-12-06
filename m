Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162311Ab3LFNPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:15:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44684 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161322Ab3LFNF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: benh@kernel.crashing.org, ben@decadent.org.uk,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 236/272] powerpc/vio: use strcpy in modalias_show
Date: Fri,  6 Dec 2013 12:58:45 +0000
Message-Id: <1386334761-25517-237-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prarit Bhargava <prarit@redhat.com>

commit 411cabf79e684171669ad29a0628c400b4431e95 upstream.

Commit e82b89a6f19bae73fb064d1b3dd91fcefbb478f4 used strcat instead of
strcpy which can result in an overflow of newlines on the buffer.

Signed-off-by: Prarit Bhargava
Cc: benh@kernel.crashing.org
Cc: ben@decadent.org.uk
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/vio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 2d845d8..56d2e72 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -1530,12 +1530,12 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 
 	dn = dev->of_node;
 	if (!dn) {
-		strcat(buf, "\n");
+		strcpy(buf, "\n");
 		return strlen(buf);
 	}
 	cp = of_get_property(dn, "compatible", NULL);
 	if (!cp) {
-		strcat(buf, "\n");
+		strcpy(buf, "\n");
 		return strlen(buf);
 	}
 
-- 
1.8.3.2

