Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbaJCVxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:53:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758AbaJCVx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fan Du <fan.du@intel.com>, Neil Horman <nhorman@tuxdriver.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.14 038/238] i2c: ismt: use correct length when copy buffer
Date: Fri,  3 Oct 2014 14:29:13 -0700
Message-Id: <20141003212914.882109795@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Du <fan.du@intel.com>

commit 979bbf7b7ae75cfc06e09d09eda38009a3bdc4a4 upstream.

In block write mode, when encapsulating dma_buffer, first element is
'command', the rest is data buffer, so only copy actual data buffer
starting from block[1] with the size indicating by block[0].

Signed-off-by: Fan Du <fan.du@intel.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-ismt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -497,7 +497,7 @@ static int ismt_access(struct i2c_adapte
 			desc->wr_len_cmd = dma_size;
 			desc->control |= ISMT_DESC_BLK;
 			priv->dma_buffer[0] = command;
-			memcpy(&priv->dma_buffer[1], &data->block[1], dma_size);
+			memcpy(&priv->dma_buffer[1], &data->block[1], dma_size - 1);
 		} else {
 			/* Block Read */
 			dev_dbg(dev, "I2C_SMBUS_BLOCK_DATA:  READ\n");
@@ -525,7 +525,7 @@ static int ismt_access(struct i2c_adapte
 			desc->wr_len_cmd = dma_size;
 			desc->control |= ISMT_DESC_I2C;
 			priv->dma_buffer[0] = command;
-			memcpy(&priv->dma_buffer[1], &data->block[1], dma_size);
+			memcpy(&priv->dma_buffer[1], &data->block[1], dma_size - 1);
 		} else {
 			/* i2c Block Read */
 			dev_dbg(dev, "I2C_SMBUS_I2C_BLOCK_DATA:  READ\n");


