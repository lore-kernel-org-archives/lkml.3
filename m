Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbaKLBfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:35:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575AbaKLBe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:34:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 3.17 292/319] mm: cma: Dont crash on allocation if CMA area cant be activated
Date: Wed, 12 Nov 2014 10:17:10 +0900
Message-Id: <20141112011041.156811215@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit f022d8cb7ec70fe8edd56383d876001317ee76b1 upstream.

If activation of the CMA area fails its mutex won't be initialized,
leading to an oops at allocation time when trying to lock the mutex. Fix
this by setting the cma area count field to 0 when activation fails,
leading to allocation returning NULL immediately.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/cma.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/cma.c
+++ b/mm/cma.c
@@ -123,6 +123,7 @@ static int __init cma_activate_area(stru
 
 err:
 	kfree(cma->bitmap);
+	cma->count = 0;
 	return -EINVAL;
 }
 


