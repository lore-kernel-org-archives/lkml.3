Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbaBDVCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:02:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187AbaBDVCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 036/104] mwifiex: fix wrong 11ac bits setting in fw_cap_info
Date: Tue,  4 Feb 2014 13:01:39 -0800
Message-Id: <20140204210223.755311719@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 1e202242ee1432d68a8bea4919b2ae0ef19d9e06 upstream.

bit 14 is actually reserved and bit 12 & 13 should be used for
11ac capability in fw_cap_info.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/fw.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -228,7 +228,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 /* HW_SPEC fw_cap_info */
 
-#define ISSUPP_11ACENABLED(fw_cap_info) (fw_cap_info & (BIT(13)|BIT(14)))
+#define ISSUPP_11ACENABLED(fw_cap_info) (fw_cap_info & (BIT(12)|BIT(13)))
 
 #define GET_VHTCAP_CHWDSET(vht_cap_info)    ((vht_cap_info >> 2) & 0x3)
 #define GET_VHTNSSMCS(mcs_mapset, nss) ((mcs_mapset >> (2 * (nss - 1))) & 0x3)


