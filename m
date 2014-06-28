Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbaF1TTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:19:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbaF1Rr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jorge Daniel Sequeira Matias <jdsm@tecnico.ulisboa.pt>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.4 31/43] [PATCH] target: Explicitly clear ramdisk_mcp backend pages
Date: Sat, 28 Jun 2014 10:46:22 -0700
Message-Id: <20140628174451.217186940@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
References: <20140628174449.788784511@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


[Note that a different patch to address the same issue went in during
v3.15-rc1 (commit 4442dc8a), but includes a bunch of other changes that
don't strictly apply to fixing the bug]

This patch changes rd_allocate_sgl_table() to explicitly clear
ramdisk_mcp backend memory pages by passing __GFP_ZERO into
alloc_pages().

This addresses a potential security issue where reading from a
ramdisk_mcp could return sensitive information, and follows what
>= v3.15 does to explicitly clear ramdisk_mcp memory at backend
device initialization time.

Reported-by: Jorge Daniel Sequeira Matias <jdsm@tecnico.ulisboa.pt>
Cc: Jorge Daniel Sequeira Matias <jdsm@tecnico.ulisboa.pt>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_rd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -177,7 +177,7 @@ static int rd_build_device_space(struct
 						- 1;
 
 		for (j = 0; j < sg_per_table; j++) {
-			pg = alloc_pages(GFP_KERNEL, 0);
+			pg = alloc_pages(GFP_KERNEL | __GFP_ZERO, 0);
 			if (!pg) {
 				pr_err("Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");


