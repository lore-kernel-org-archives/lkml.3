Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbaJYBdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 21:33:53 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52852 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbaJYBdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 21:33:36 -0400
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] staging: lustre: Use __init and __exit markers for lifecycle functions
Date: Sat, 25 Oct 2014 03:30:38 +0200
Message-Id: <1414200638-20682-3-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414200638-20682-1-git-send-email-marius.gorski@gmail.com>
References: <1414200638-20682-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply __init marker to module's init function and __exit to module's
exit function as they both have no other usage.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/module.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/module.c b/drivers/staging/lustre/lnet/lnet/module.c
index dc09b43..3c23677 100644
--- a/drivers/staging/lustre/lnet/lnet/module.c
+++ b/drivers/staging/lustre/lnet/lnet/module.c
@@ -110,7 +110,7 @@ lnet_ioctl(unsigned int cmd, struct libcfs_ioctl_data *data)
 
 DECLARE_IOCTL_HANDLER(lnet_ioctl_handler, lnet_ioctl);
 
-static int
+static int __init
 init_lnet(void)
 {
 	int		  rc;
@@ -135,7 +135,7 @@ init_lnet(void)
 	return 0;
 }
 
-static void
+static void __exit
 fini_lnet(void)
 {
 	int rc;
-- 
2.1.2

