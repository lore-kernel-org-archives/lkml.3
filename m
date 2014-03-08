Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaCHBJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:09:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbaCHBIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:08:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 90/99] iwlwifi: protect SRAM debugfs
Date: Fri,  7 Mar 2014 17:08:26 -0800
Message-Id: <20140308010614.456317088@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Johannes Berg <johannes.berg@intel.com>

commit 4fc79db178f0a0ede479b4713e00df2d106028b3 upstream.

If the device is not started, we can't read its
SRAM and attempting to do so will cause issues.
Protect the debugfs read.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[wujg: Backported to 3.4: adjust context]
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -227,6 +227,9 @@ static ssize_t iwl_dbgfs_sram_read(struc
 	const struct fw_img *img;
 	size_t bufsz;
 
+	if (!iwl_is_ready_rf(priv))
+		return -EAGAIN;
+
 	/* default is to dump the entire data segment */
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
 		priv->dbgfs_sram_offset = 0x800000;


