Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaGZT3g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:29:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbaGZTXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.15 098/109] RDMA/cxgb4: Initialize the device status page
Date: Sat, 26 Jul 2014 12:03:00 -0700
Message-Id: <20140726190226.798899696@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Wise <swise@opengridcomputing.com>

commit 6b54d54dea82ae214e4a45a503c4ef755a8ecee8 upstream.

The status page is mapped to user processes and allows sharing the
device state between the kernel and user processes.  This state isn't
getting initialized and thus intermittently causes problems.  Namely,
the user process can mistakenly think the user doorbell writes are
disabled which causes SQ work requests to never get fetched by HW.

Fixes: 05eb23893c2c ("cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixes").
Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/cxgb4/device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -654,6 +654,7 @@ static int c4iw_rdev_open(struct c4iw_rd
 		pr_err(MOD "error allocating status page\n");
 		goto err4;
 	}
+	rdev->status_page->db_off = 0;
 	return 0;
 err4:
 	c4iw_rqtpool_destroy(rdev);


