Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab3ILR07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:26:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3ILR0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:26:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        WANG Cong <xiyou.wangcong@gmail.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 14/19] PARISC: include <linux/prefetch.h> in drivers/parisc/iommu-helpers.h
Date: Thu, 12 Sep 2013 10:26:23 -0700
Message-Id: <20130912172525.722049646@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912172524.135620246@linuxfoundation.org>
References: <20130912172524.135620246@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 650275dbfb2f4c12bc91420ad5a99f955eabec98 upstream.

drivers/parisc/iommu-helpers.h:62: error: implicit declaration of function 'prefetchw'
make[3]: *** [drivers/parisc/sba_iommu.o] Error 1

drivers/parisc/iommu-helpers.h needs to #include <linux/prefetch.h>
where prefetchw is declared.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/parisc/iommu-helpers.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/parisc/iommu-helpers.h
+++ b/drivers/parisc/iommu-helpers.h
@@ -1,3 +1,5 @@
+#include <linux/prefetch.h>
+
 /**
  * iommu_fill_pdir - Insert coalesced scatter/gather chunks into the I/O Pdir.
  * @ioc: The I/O Controller.


