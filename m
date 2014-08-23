Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaHWSh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 14:37:26 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:29333
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950AbaHWShC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 14:37:02 -0400
X-IronPort-AV: E=Sophos;i="5.04,387,1406584800"; 
   d="scan'208";a="76200909"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: joe@perches.com, kernel-janitors@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] wusb: delete double assignment
Date: Sat, 23 Aug 2014 20:33:26 +0200
Message-Id: <1408818808-18850-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive assignments to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series do not depend on each other.

 drivers/usb/wusbcore/crypto.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
index 9a95b2d..50ce80d 100644
--- a/drivers/usb/wusbcore/crypto.c
+++ b/drivers/usb/wusbcore/crypto.c
@@ -222,8 +222,6 @@ static int wusb_ccm_mac(struct crypto_blkcipher *tfm_cbc,
 	WARN_ON(sizeof(ax) != sizeof(struct aes_ccm_block));
 
 	result = -ENOMEM;
-	zero_padding = sizeof(struct aes_ccm_block)
-		- blen % sizeof(struct aes_ccm_block);
 	zero_padding = blen % sizeof(struct aes_ccm_block);
 	if (zero_padding)
 		zero_padding = sizeof(struct aes_ccm_block) - zero_padding;

