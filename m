Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759771Ab3IHDu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:50:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56065 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770Ab3IHDTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Cong Wang" <xiyou.wangcong@gmail.com>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.582363644@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [096/121] [PARISC] include <linux/prefetch.h> in drivers/parisc/iommu-helpers.h
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 650275dbfb2f4c12bc91420ad5a99f955eabec98 upstream.

drivers/parisc/iommu-helpers.h:62: error: implicit declaration of function 'prefetchw'
make[3]: *** [drivers/parisc/sba_iommu.o] Error 1

drivers/parisc/iommu-helpers.h needs to #include <linux/prefetch.h>
where prefetchw is declared.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/parisc/iommu-helpers.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/parisc/iommu-helpers.h b/drivers/parisc/iommu-helpers.h
index a9c46cc..8c33491 100644
--- a/drivers/parisc/iommu-helpers.h
+++ b/drivers/parisc/iommu-helpers.h
@@ -1,3 +1,5 @@
+#include <linux/prefetch.h>
+
 /**
  * iommu_fill_pdir - Insert coalesced scatter/gather chunks into the I/O Pdir.
  * @ioc: The I/O Controller.

