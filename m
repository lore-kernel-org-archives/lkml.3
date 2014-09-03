Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177AbaICWYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:24:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933899AbaICWSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Marciel <rmaciel@linux.vnet.ibm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 3.16 048/125] tpm: Add missing tpm_do_selftest to ST33 I2C driver
Date: Wed,  3 Sep 2014 15:06:45 -0700
Message-Id: <20140903220625.089892150@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_i2c_stm_st33.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -714,6 +714,7 @@ tpm_st33_i2c_probe(struct i2c_client *cl
 	}
 
 	tpm_get_timeouts(chip);
+	tpm_do_selftest(chip);
 
 	dev_info(chip->dev, "TPM I2C Initialized\n");
 	return 0;


