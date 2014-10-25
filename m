Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaJYBdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 21:33:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35093 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbaJYBdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 21:33:33 -0400
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] staging: lustre: Reduce function visibility
Date: Sat, 25 Oct 2014 03:30:37 +0200
Message-Id: <1414200638-20682-2-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414200638-20682-1-git-send-email-marius.gorski@gmail.com>
References: <1414200638-20682-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:
drivers/staging/lustre/lnet/lnet/module.c:47:1: warning: symbol
  'lnet_configure' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/module.c:67:1: warning: symbol
  'lnet_unconfigure' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/module.c:87:1: warning: symbol
  'lnet_ioctl' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/module.c:114:1: warning: symbol
  'init_lnet' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/module.c:139:1: warning: symbol
  'fini_lnet' was not declared. Should it be static?

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/module.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/module.c b/drivers/staging/lustre/lnet/lnet/module.c
index e84d59d..dc09b43 100644
--- a/drivers/staging/lustre/lnet/lnet/module.c
+++ b/drivers/staging/lustre/lnet/lnet/module.c
@@ -43,7 +43,7 @@ MODULE_PARM_DESC(config_on_load, "configure network at module load");
 
 static struct mutex lnet_config_mutex;
 
-int
+static int
 lnet_configure(void *arg)
 {
 	/* 'arg' only there so I can be passed to cfs_create_thread() */
@@ -63,7 +63,7 @@ lnet_configure(void *arg)
 	return rc;
 }
 
-int
+static int
 lnet_unconfigure(void)
 {
 	int   refcount;
@@ -83,7 +83,7 @@ lnet_unconfigure(void)
 	return (refcount == 0) ? 0 : -EBUSY;
 }
 
-int
+static int
 lnet_ioctl(unsigned int cmd, struct libcfs_ioctl_data *data)
 {
 	int   rc;
@@ -110,7 +110,7 @@ lnet_ioctl(unsigned int cmd, struct libcfs_ioctl_data *data)
 
 DECLARE_IOCTL_HANDLER(lnet_ioctl_handler, lnet_ioctl);
 
-int
+static int
 init_lnet(void)
 {
 	int		  rc;
@@ -135,7 +135,7 @@ init_lnet(void)
 	return 0;
 }
 
-void
+static void
 fini_lnet(void)
 {
 	int rc;
-- 
2.1.2

