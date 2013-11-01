Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3KAWQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:16:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab3KAWI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 3.11 53/66] i2c: ismt: initialize DMA buffer
Date: Fri,  1 Nov 2013 15:07:29 -0700
Message-Id: <20131101220649.394427047@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Ralston <james.d.ralston@intel.com>

commit bf4169100c909667ede6af67668b3ecce6928343 upstream.

This patch adds code to initialize the DMA buffer to compensate for
possible hardware data corruption.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
[wsa: changed to use 'sizeof']
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-ismt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -393,6 +393,9 @@ static int ismt_access(struct i2c_adapte
 
 	desc = &priv->hw[priv->head];
 
+	/* Initialize the DMA buffer */
+	memset(priv->dma_buffer, 0, sizeof(priv->dma_buffer));
+
 	/* Initialize the descriptor */
 	memset(desc, 0, sizeof(struct ismt_desc));
 	desc->tgtaddr_rw = ISMT_DESC_ADDR_RW(addr, read_write);


