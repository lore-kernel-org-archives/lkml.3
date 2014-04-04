Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaDDWdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:33:14 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49276 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaDDWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:32:26 -0400
From: Silvio Fricke <silvio.fricke@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Silvio Fricke <silvio.fricke@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [WIP] [PATCH v2 3/3] staging: vt6655: removed incorrect casting in iwctl.c
Date: Sat,  5 Apr 2014 00:32:10 +0200
Message-Id: <947ca1005488d25ea2995ba950e4c2541c34b5f1.1396627781.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1396627781.git.silvio.fricke@gmail.com>
References: <cover.1396627781.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1396627781.git.silvio.fricke@gmail.com>
References: <20140403094350.GH6991@mwanda> <cover.1396627781.git.silvio.fricke@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following type of sparse warning:

drivers/staging/vt6655/iwctl.c:1846:35: warning: cast from restricted gfp_t

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
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

