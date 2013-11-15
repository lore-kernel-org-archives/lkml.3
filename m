Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3KOMbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:31:47 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43721 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab3KOMbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:31:40 -0500
Date: Fri, 15 Nov 2013 20:31:12 +0800
From: ZHAO Gang <gamerh2o@gmail.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: et131x: stop read when hit max delay in
 et131x_phy_mii_read
Message-ID: <943804b6ad98cdabb3a51bf88c3a8f59617627e9.1384518190.git.gamerh2o@gmail.com>
Mail-Followup-To: ZHAO Gang <gamerh2o@gmail.com>,
	Mark Einon <mark.einon@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org
References: <62a00a45d2fc38d1881f153f35ba282e85d78a3e.1384518190.git.gamerh2o@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62a00a45d2fc38d1881f153f35ba282e85d78a3e.1384518190.git.gamerh2o@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stop read and return error when hit max delay time.

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 drivers/staging/et131x/et131x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index cda037a..6254a6b 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1392,6 +1392,7 @@ static int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
 			    mii_indicator);
 
 		status = -EIO;
+		goto out;
 	}
 
 	/* If we hit here we were able to read the register and we need to
@@ -1399,6 +1400,7 @@ static int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
 	 */
 	*value = readl(&mac->mii_mgmt_stat) & ET_MAC_MIIMGMT_STAT_PHYCRTL_MASK;
 
+out:
 	/* Stop the read operation */
 	writel(0, &mac->mii_mgmt_cmd);
 
-- 
1.8.3.1

