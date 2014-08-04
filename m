Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaHDRM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:12:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56490 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.631598640@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 80/94] applicom: dereferencing NULL on error path
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8bab797c6e5724a43b7666ad70860712365cdb71 upstream.

This is a static checker fix.  The "dev" variable is always NULL after
the while statement so we would be dereferencing a NULL pointer here.

Fixes: 819a3eba4233 ('[PATCH] applicom: fix error handling')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/applicom.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 974321a..1479030 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -345,7 +345,6 @@ out:
 			free_irq(apbs[i].irq, &dummy);
 		iounmap(apbs[i].RamIO);
 	}
-	pci_disable_device(dev);
 	return ret;
 }
 

