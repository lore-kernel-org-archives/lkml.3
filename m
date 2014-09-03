Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbaICKEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:04:23 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57443 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932358AbaICJ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:08 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 38/56] tpm: Add missing tpm_do_selftest to ST33 I2C driver
Date: Wed,  3 Sep 2014 11:26:57 +0200
Message-Id: <e23f841e5879f8aa6719cf63ea9c4837548893d7.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/tpm/tpm_i2c_stm_st33.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index 156bd3c72770..06af39ca901e 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -750,6 +750,7 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	tpm_get_timeouts(chip);
+	tpm_do_selftest(chip);
 
 	i2c_set_clientdata(client, chip);
 
-- 
2.1.0

