Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaFWBdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:33:14 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39801 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbaFWBdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:33:09 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Li Xi <lixi@ddn.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 17/18] staging/lustre/llite: fix a flag bug of vvp_io_kernel_fault()
Date: Sun, 22 Jun 2014 21:32:21 -0400
Message-Id: <1403487142-4880-18-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Xi <lixi@ddn.com>

After vvp_io_kernel_fault() locked the page, it should set
VM_FAULT_LOCKED.

Signed-off-by: Li Xi <lixi@ddn.com>
Reviewed-on: http://review.whamcloud.com/10740
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Emoly Liu <emoly.liu@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/vvp_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index 04230ed..2539a89 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -624,7 +624,7 @@ static int vvp_io_kernel_fault(struct vvp_fault_io *cfio)
 		       page_private(vmf->page), vmf->virtual_address);
 		if (unlikely(!(cfio->fault.ft_flags & VM_FAULT_LOCKED))) {
 			lock_page(vmf->page);
-			cfio->fault.ft_flags &= VM_FAULT_LOCKED;
+			cfio->fault.ft_flags |= VM_FAULT_LOCKED;
 		}
 
 		cfio->ft_vmpage = vmf->page;
-- 
1.9.0

