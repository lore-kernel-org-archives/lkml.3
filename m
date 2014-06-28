Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaF1SLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:11:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbaF1RwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.15 064/139] media: exynos4-is: Free FIMC-IS CPU memory only when allocated
Date: Sat, 28 Jun 2014 10:47:05 -0700
Message-Id: <20140628174608.352464993@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit 404a90abc60f60df2757cb272660e003d326881f upstream.

Ensure dma_free_coherent() is not called with incorrect arguments
and only when the memory was actually allocated. This will prevent
possible crashes on error paths of the top level media device driver,
when fimc-is device gets unregistered and its driver detached.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/exynos4-is/fimc-is.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -367,6 +367,9 @@ static void fimc_is_free_cpu_memory(stru
 {
 	struct device *dev = &is->pdev->dev;
 
+	if (is->memory.vaddr == NULL)
+		return;
+
 	dma_free_coherent(dev, is->memory.size, is->memory.vaddr,
 			  is->memory.paddr);
 }


