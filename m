Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbbAYLLZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 06:11:25 -0500
Received: from www.osadl.org ([62.245.132.105]:39830 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbbAYLLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 06:11:21 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH 1/3] hyperv: netvsc.c: fixup-of-wait_for_completion_timeout-return-type
Date: Sun, 25 Jan 2015 12:03:28 +0100
Message-Id: <1422183808-7655-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

The return type of wait_for_completion_timeout is unsigned long not
int. This patch fixes up the declarations only.

Patch was compile tested only for x86_64_defconfig + CONFIG_X86_VSMP=y
CONFIG_HYPERV=m, CONFIG_HYPERV_NET=m

Patch is against 3.19.0-rc5 -next-20150123

 drivers/net/hyperv/netvsc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 9f49c01..d2af032 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -217,7 +217,7 @@ static int netvsc_destroy_buf(struct netvsc_device *net_device)
 static int netvsc_init_buf(struct hv_device *device)
 {
 	int ret = 0;
-	int t;
+	unsigned long t;
 	struct netvsc_device *net_device;
 	struct nvsp_message *init_packet;
 	struct net_device *ndev;
@@ -409,7 +409,8 @@ static int negotiate_nvsp_ver(struct hv_device *device,
 			      struct nvsp_message *init_packet,
 			      u32 nvsp_ver)
 {
-	int ret, t;
+	int ret;
+	unsigned long t;
 
 	memset(init_packet, 0, sizeof(struct nvsp_message));
 	init_packet->hdr.msg_type = NVSP_MSG_TYPE_INIT;
-- 
1.7.10.4

