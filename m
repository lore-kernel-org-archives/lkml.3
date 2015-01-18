Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbbAROJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:09:14 -0500
Received: from srv-hp10.netsons.net ([94.141.22.72]:42625 "EHLO
	srv-hp10.netsons.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751871AbbAROIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:08:12 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luca Ceresoli <luca@lucaceresoli.net>, Peng Tao <bergwolf@gmail.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] staging: lustre: lnet: declare internal symbols as static
Date: Sun, 18 Jan 2015 15:06:52 +0100
Message-Id: <1421590012-7082-7-git-send-email-luca@lucaceresoli.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421590012-7082-1-git-send-email-luca@lucaceresoli.net>
References: <1421590012-7082-1-git-send-email-luca@lucaceresoli.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv-hp10.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: srv-hp10.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warnings like:
  warning: symbol '...' was not declared. Should it be static?

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Peng Tao <bergwolf@gmail.com>
Cc: Jinshan Xiong <jinshan.xiong@intel.com>
Cc: Srikrishan Malik <srikrishanmalik@gmail.com>
Cc: HPDD-discuss@lists.01.org
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/lustre/lnet/lnet/module.c      | 2 +-
 drivers/staging/lustre/lnet/selftest/conctl.c  | 2 +-
 drivers/staging/lustre/lnet/selftest/conrpc.c  | 2 +-
 drivers/staging/lustre/lnet/selftest/console.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/module.c b/drivers/staging/lustre/lnet/lnet/module.c
index 3c23677..72b7fbc 100644
--- a/drivers/staging/lustre/lnet/lnet/module.c
+++ b/drivers/staging/lustre/lnet/lnet/module.c
@@ -108,7 +108,7 @@ lnet_ioctl(unsigned int cmd, struct libcfs_ioctl_data *data)
 	}
 }
 
-DECLARE_IOCTL_HANDLER(lnet_ioctl_handler, lnet_ioctl);
+static DECLARE_IOCTL_HANDLER(lnet_ioctl_handler, lnet_ioctl);
 
 static int __init
 init_lnet(void)
diff --git a/drivers/staging/lustre/lnet/selftest/conctl.c b/drivers/staging/lustre/lnet/selftest/conctl.c
index 5bc6153..fbff84c 100644
--- a/drivers/staging/lustre/lnet/selftest/conctl.c
+++ b/drivers/staging/lustre/lnet/selftest/conctl.c
@@ -721,7 +721,7 @@ lst_stat_query_ioctl(lstio_stat_args_t *args)
 	return rc;
 }
 
-int lst_test_add_ioctl(lstio_test_args_t *args)
+static int lst_test_add_ioctl(lstio_test_args_t *args)
 {
 	char		*batch_name;
 	char		*src_name = NULL;
diff --git a/drivers/staging/lustre/lnet/selftest/conrpc.c b/drivers/staging/lustre/lnet/selftest/conrpc.c
index 9999b0d..77f02b7 100644
--- a/drivers/staging/lustre/lnet/selftest/conrpc.c
+++ b/drivers/staging/lustre/lnet/selftest/conrpc.c
@@ -703,7 +703,7 @@ lstcon_statrpc_prep(lstcon_node_t *nd, unsigned feats, lstcon_rpc_t **crpc)
 	return 0;
 }
 
-lnet_process_id_packed_t *
+static lnet_process_id_packed_t *
 lstcon_next_id(int idx, int nkiov, lnet_kiov_t *kiov)
 {
 	lnet_process_id_packed_t *pid;
diff --git a/drivers/staging/lustre/lnet/selftest/console.c b/drivers/staging/lustre/lnet/selftest/console.c
index 49cb654..3bb47fa 100644
--- a/drivers/staging/lustre/lnet/selftest/console.c
+++ b/drivers/staging/lustre/lnet/selftest/console.c
@@ -1986,7 +1986,7 @@ static void lstcon_init_acceptor_service(void)
 
 extern int lstcon_ioctl_entry(unsigned int cmd, struct libcfs_ioctl_data *data);
 
-DECLARE_IOCTL_HANDLER(lstcon_ioctl_handler, lstcon_ioctl_entry);
+static DECLARE_IOCTL_HANDLER(lstcon_ioctl_handler, lstcon_ioctl_entry);
 
 /* initialize console */
 int
-- 
1.9.1

