Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbaF1TOo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:14:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaF1Rrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 3.10 06/77] applicom: dereferencing NULL on error path
Date: Sat, 28 Jun 2014 10:45:59 -0700
Message-Id: <20140628174521.995729448@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8bab797c6e5724a43b7666ad70860712365cdb71 upstream.

This is a static checker fix.  The "dev" variable is always NULL after
the while statement so we would be dereferencing a NULL pointer here.

Fixes: 819a3eba4233 ('[PATCH] applicom: fix error handling')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/applicom.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -345,7 +345,6 @@ out:
 			free_irq(apbs[i].irq, &dummy);
 		iounmap(apbs[i].RamIO);
 	}
-	pci_disable_device(dev);
 	return ret;
 }
 


