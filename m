Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab3BSRpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:45:47 -0500
Received: from mout.gmx.net ([212.227.17.21]:49225 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933141Ab3BSRpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:45:44 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/C6VxVqIbCtQU+qEgOnYYQEcrehcfF66veKBhJFg
	PXwFBIh2suVCbU
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sage Ahn <syahn@gctsemi.com>,
        Macpaul Lin <macpaul.from.taiwan@gmail.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Devendra Naga <devendra.aaru@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 1/3] staging/gdm72xx: Include corresponding header file (fix sparse warning)
Date: Tue, 19 Feb 2013 18:50:18 +0100
Message-Id: <1361296220-10020-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdio_boot.c and netlink_k.c both have a corresponding header file with
their function prototypes but fail to include them, which leads to the
following sparse warnings:
sdio_boot.c:135:5: warning: symbol 'sdio_boot' was not declared. Should it be static?
netlink_k.c:89:13: warning: symbol 'netlink_init' was not declared. Should it be static?
netlink_k.c:109:6: warning: symbol 'netlink_exit' was not declared. Should it be static?
netlink_k.c:114:5: warning: symbol 'netlink_send' was not declared. Should it be static?

-> Add the include files and silence the warning

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/gdm72xx/netlink_k.c |    1 +
 drivers/staging/gdm72xx/sdio_boot.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
index 52c25ba..8a92605 100644
--- a/drivers/staging/gdm72xx/netlink_k.c
+++ b/drivers/staging/gdm72xx/netlink_k.c
@@ -18,6 +18,7 @@
 #include <linux/netlink.h>
 #include <asm/byteorder.h>
 #include <net/sock.h>
+#include "netlink_k.h"
 
 #if !defined(NLMSG_HDRLEN)
 #define NLMSG_HDRLEN	 ((int) NLMSG_ALIGN(sizeof(struct nlmsghdr)))
diff --git a/drivers/staging/gdm72xx/sdio_boot.c b/drivers/staging/gdm72xx/sdio_boot.c
index 93046dd..4302fcb 100644
--- a/drivers/staging/gdm72xx/sdio_boot.c
+++ b/drivers/staging/gdm72xx/sdio_boot.c
@@ -27,6 +27,7 @@
 #include <linux/firmware.h>
 
 #include "gdm_sdio.h"
+#include "sdio_boot.h"
 
 #define TYPE_A_HEADER_SIZE	4
 #define TYPE_A_LOOKAHEAD_SIZE   16
-- 
1.7.8.6

