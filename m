Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaL3Tma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 14:42:30 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58194 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaL3Tm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 14:42:29 -0500
Date: Mon, 29 Dec 2014 03:10:32 -0800
From: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: linux-prim.c: fix sparse warnings about
 static declaration
Message-ID: <20141229111032.GA18686@fedora.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following sparse warnings:

drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c:198:1: warning: symbol 'libcfs_arch_init' was not declared. Should it be static?
drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c:204:1: warning: symbol 'libcfs_arch_cleanup' was not declared. Should it be static?

Signed-off-by: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
---
 drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
index 19f405e..4fee73f 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
@@ -194,14 +194,12 @@ cfs_clear_sigpending(void)
 	spin_unlock_irqrestore(&current->sighand->siglock, flags);
 }
 
-int
-libcfs_arch_init(void)
+static int libcfs_arch_init(void)
 {
 	return 0;
 }
 
-void
-libcfs_arch_cleanup(void)
+static void libcfs_arch_cleanup(void)
 {
 	return;
 }
-- 
1.9.3

