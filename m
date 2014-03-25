Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbaCYUbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:31:04 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59113 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaCYUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:30:51 -0400
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
From: silvio@port1024.net
To: linux-kernel@vger.kernel.org
Cc: silvio@port1024.net, Silvio F <silvio.fricke@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 3/3] staging: vt6655: removed incorrect casting in iwctl.c
Date: Tue, 25 Mar 2014 21:30:20 +0100
Message-Id: <00f500f35670ed052c39ff7fa1b73e15923f442b.1395778852.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <cover.1395778852.git.silvio.fricke@gmail.com>
References: <cover.1395778852.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1395778852.git.silvio.fricke@gmail.com>
References: <1395362529-17182-1-git-send-email-cse.cem@gmail.com> <cover.1395778852.git.silvio.fricke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Silvio F <silvio.fricke@gmail.com>

This patch fixes the following type of sparse warning:

drivers/staging/vt6655/iwctl.c:1846:35: warning: cast from restricted gfp_t

Signed-off-by: Silvio F <silvio.fricke@gmail.com>
---
 drivers/staging/vt6655/iwctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index ac3fc16..5e25535 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -1843,7 +1843,7 @@ int iwctl_siwencodeext(struct net_device *dev,
 	PRINT_K("SIOCSIWENCODEEXT...... \n");
 
 	blen = sizeof(*param);
-	buf = kmalloc((int)blen, (int)GFP_KERNEL);
+	buf = kmalloc((int)blen, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
 	memset(buf, 0, blen);
-- 
1.9.0

