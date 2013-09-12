Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab3ILSOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:14:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab3ILR7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 26/46] sfc: Fix lookup of default RX MAC filters when steered using ethtool
Date: Thu, 12 Sep 2013 10:58:37 -0700
Message-Id: <20130912175723.855881875@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit f3851b0acc5a75bd33c6d344a2e4f920e1622ff0 ]

commit 385904f819e3 ('sfc: Don't use
efx_filter_{build,hash,increment}() for default MAC filters') used the
wrong name to find the index of default RX MAC filters at insertion/
update time.  This could result in memory corruption and would in any
case silently fail to update the filter.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/filter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/sfc/filter.c
+++ b/drivers/net/ethernet/sfc/filter.c
@@ -675,7 +675,7 @@ s32 efx_filter_insert_filter(struct efx_
 		BUILD_BUG_ON(EFX_FILTER_INDEX_UC_DEF != 0);
 		BUILD_BUG_ON(EFX_FILTER_INDEX_MC_DEF !=
 			     EFX_FILTER_MC_DEF - EFX_FILTER_UC_DEF);
-		rep_index = spec->type - EFX_FILTER_INDEX_UC_DEF;
+		rep_index = spec->type - EFX_FILTER_UC_DEF;
 		ins_index = rep_index;
 
 		spin_lock_bh(&state->lock);


