Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762920Ab3DCR4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762738Ab3DCR4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:56:36 -0400
Date: Thu, 04 Apr 2013 02:56:34 +0900 (JST)
Message-Id: <20130404.025634.2151704690533287593.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pnp: extend char array field in pnp_fixup structure
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The length of id field of pnp_fixup structure is 7:

     struct pnp_fixup {
	    char id[7];
	    void (*quirk_function) (struct pnp_dev * dev);	/* fixup function */
     }

In other hand the field is initialized with a constant cstring
consisting of 7 characters in pnp_fixups defined in drivers/pnp/quirks.c:

    static struct pnp_fixup pnp_fixups[] = {
	    /* Soundblaster awe io port quirk */
	    {"CTL0021", quirk_awe32_resources},
	    {"CTL0022", quirk_awe32_resources},

The constant cstring is too large to store; no space for nul char.

If the id field is just used as byte array, there is no problem.
However, it is used as c string in pnp_fixup_device function:

		pnp_dbg(&dev->dev, "%s: calling %pF\n", f->id,
			f->quirk_function);

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 include/linux/pnp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 195aafc..d734ee2 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -295,7 +295,7 @@ static inline void pnp_set_drvdata(struct pnp_dev *pdev, void *data)
 }
 
 struct pnp_fixup {
-	char id[7];
+	char id[8];
 	void (*quirk_function) (struct pnp_dev * dev);	/* fixup function */
 };
 
-- 
1.7.11.7

