Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaFGLZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 07:25:45 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64153 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaFGLZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 07:25:43 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: wimax: i2400m: control.c:  Cleaning up conjunction always evaluates to false
Date: Sat,  7 Jun 2014 13:26:37 +0200
Message-Id: <1402140397-17404-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logical conjunction always evaluates to false:  minor < 2 && minor > 1
I guess what you wanted is rather: minor > 2 || minor < 1

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wimax/i2400m/control.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wimax/i2400m/control.c b/drivers/net/wimax/i2400m/control.c
index 4a01e5c..4c41790 100644
--- a/drivers/net/wimax/i2400m/control.c
+++ b/drivers/net/wimax/i2400m/control.c
@@ -1061,7 +1061,7 @@ int i2400m_firmware_check(struct i2400m *i2400m)
 		goto error_bad_major;
 	}
 	result = 0;
-	if (minor < I2400M_HDIv_MINOR_2 && minor > I2400M_HDIv_MINOR)
+	if (minor > I2400M_HDIv_MINOR_2 || minor < I2400M_HDIv_MINOR)
 		dev_warn(dev, "untested minor fw version %u.%u.%u\n",
 			 major, minor, branch);
 	/* Yes, we ignore the branch -- we don't have to track it */
-- 
1.7.10.4

