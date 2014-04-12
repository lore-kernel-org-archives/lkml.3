Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaDLAbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 20:31:37 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:54868 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaDLAaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 20:30:39 -0400
From: Silvio Fricke <silvio.fricke@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Silvio Fricke <silvio.fricke@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH v3 3/3] staging: vt6655: removed incorrect casting in iwctl.c
Date: Sat, 12 Apr 2014 02:30:26 +0200
Message-Id: <fbcf3bde3730a6982e66980bb1f84a3d84444817.1397260702.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <cover.1397260702.git.silvio.fricke@gmail.com>
References: <cover.1397260702.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1397260702.git.silvio.fricke@gmail.com>
References: <20140410201606.GA12335@kroah.com> <cover.1397260702.git.silvio.fricke@gmail.com>
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
1.9.2

