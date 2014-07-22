Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbaGVUIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:08:09 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:60970 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbaGVUIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:08:04 -0400
From: Matt Kurz <matt@ninezulu.com>
To: andreas.dilger@intel.com, oleg.drokin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Matt Kurz <matt@ninezulu.com>
Subject: [PATCH] staging: lustre: Fix sparse warnings
Date: Wed, 23 Jul 2014 06:10:33 +1000
Message-Id: <1406059833-17161-1-git-send-email-matt@ninezulu.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declare several functions and variables as static in order
to address the following sparse warnings

drivers/staging/lustre/lnet/lnet/acceptor.c:49:3: warning: symbol 'lnet_acceptor_state' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/acceptor.c:79:1: warning: symbol 'lnet_acceptor_get_tunables' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/acceptor.c:211:1: warning: symbol 'lnet_accept' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/acceptor.c:333:1: warning: symbol 'lnet_acceptor' was not declared. Should it be static?

Tested by compilation only.

Signed-off-by: Matt Kurz <matt@ninezulu.com>
---
 drivers/staging/lustre/lnet/lnet/acceptor.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/acceptor.c b/drivers/staging/lustre/lnet/lnet/acceptor.c
index 001c4b7..5dfb887 100644
--- a/drivers/staging/lustre/lnet/lnet/acceptor.c
+++ b/drivers/staging/lustre/lnet/lnet/acceptor.c
@@ -42,7 +42,7 @@ static int   accept_port    = 988;
 static int   accept_backlog = 127;
 static int   accept_timeout = 5;
 
-struct {
+static struct {
 	int			pta_shutdown;
 	struct socket		*pta_sock;
 	struct completion	pta_signal;
@@ -75,7 +75,7 @@ MODULE_PARM_DESC(accept_timeout, "Acceptor's timeout (seconds)");
 
 static char *accept_type;
 
-int
+static int
 lnet_acceptor_get_tunables(void)
 {
 	/* Userland acceptor uses 'accept_type' instead of 'accept', due to
@@ -207,7 +207,7 @@ EXPORT_SYMBOL(lnet_connect);
 
 /* Below is the code common for both kernel and MT user-space */
 
-int
+static int
 lnet_accept(struct socket *sock, __u32 magic)
 {
 	lnet_acceptor_connreq_t cr;
@@ -329,7 +329,7 @@ lnet_accept(struct socket *sock, __u32 magic)
 	return rc;
 }
 
-int
+static int
 lnet_acceptor(void *arg)
 {
 	struct socket *newsock;
-- 
2.0.2

