Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbaIOWL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:11:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50598 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbaIOWLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:11:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 107/187] tpm: Add missing tpm_do_selftest to ST33 I2C driver
Date: Mon, 15 Sep 2014 15:08:37 -0700
Message-Id: <1410818997-9432-108-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

commit f07a5e9a331045e976a3d317ba43d14859d9407c upstream.

Most device drivers do call 'tpm_do_selftest' which executes a
TPM_ContinueSelfTest. tpm_i2c_stm_st33 is just pointlessly different,
I think it is bug.

These days we have the general assumption that the TPM is usable by
the kernel immediately after the driver is finished, so we can no
longer defer the mandatory self test to userspace.

Reported-by: Richard Marciel <rmaciel@linux.vnet.ibm.com>
Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/char/tpm/tpm_i2c_stm_st33.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index cf68403..b2cb24c 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -750,6 +750,7 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	tpm_get_timeouts(chip);
+	tpm_do_selftest(chip);
 
 	dev_info(chip->dev, "TPM I2C Initialized\n");
 	return 0;
-- 
1.9.1

