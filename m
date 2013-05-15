Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab3EOBBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 21:01:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758653Ab3EOBBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 21:01:51 -0400
From: Asias He <asias@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        target-devel@vger.kernel.org, Asias He <asias@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vhost-scsi: Depend on NET for memcpy_fromiovec
Date: Wed, 15 May 2013 08:59:43 +0800
Message-Id: <1368579583-13097-1-git-send-email-asias@redhat.com>
In-Reply-To: <20130515095558.918f2b29ba318a477eb5dde2@canb.auug.org.au>
References: <20130515095558.918f2b29ba318a477eb5dde2@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi.c includes vhost.c which uses memcpy_fromiovec.

This patch fixes this build failure.

   From Randy Dunlap:
   '''
   on x86_64:

   ERROR: "memcpy_fromiovec" [drivers/vhost/vhost_scsi.ko] undefined!

   It needs to depend on NET since net/core/ provides that function.
   '''

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Asias He <asias@redhat.com>
---
 drivers/vhost/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 8b9226d..0403323 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -12,7 +12,7 @@ config VHOST_NET
 
 config VHOST_SCSI
 	tristate "VHOST_SCSI TCM fabric driver"
-	depends on TARGET_CORE && EVENTFD && m
+	depends on NET && TARGET_CORE && EVENTFD && m
 	select VHOST_RING
 	default n
 	---help---
-- 
1.8.1.4

