Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbbAYIy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 03:54:29 -0500
Received: from www.osadl.org ([62.245.132.105]:39076 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbbAYIy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 03:54:27 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] hyperv: fixup of wait_for_completion_timeout return type
Date: Sun, 25 Jan 2015 09:46:33 +0100
Message-Id: <1422175593-1890-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return type of wait_for_completion_timeout is unsigned long not int, this
patch just fixes up the declarations.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

The return type of wait_for_completion_timeout is unsigned long not
int. This patch fixes up the declarations only.

Patch was compile tested only for x86_64_defconfig + CONFIG_X86_VSMP=y
CONFIG_HYPERV=m, CONFIG_HYPERV_NET=m

Patch is against 3.19.0-rc5 -next-20150123

 drivers/net/hyperv/rndis_filter.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index ec0c40a..7bd8387 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -470,7 +470,7 @@ static int rndis_filter_query_device(struct rndis_device *dev, u32 oid,
 	struct rndis_query_request *query;
 	struct rndis_query_complete *query_complete;
 	int ret = 0;
-	int t;
+	unsigned long t;
 
 	if (!result)
 		return -EINVAL;
@@ -560,7 +560,8 @@ int rndis_filter_set_device_mac(struct hv_device *hdev, char *mac)
 	char macstr[2*ETH_ALEN+1];
 	u32 extlen = sizeof(struct rndis_config_parameter_info) +
 		2*NWADR_STRLEN + 4*ETH_ALEN;
-	int ret, t;
+	int ret;
+	unsigned long t;
 
 	request = get_rndis_request(rdev, RNDIS_MSG_SET,
 		RNDIS_MESSAGE_SIZE(struct rndis_set_request) + extlen);
@@ -634,7 +635,8 @@ int rndis_filter_set_offload_params(struct hv_device *hdev,
 	struct ndis_offload_params *offload_params;
 	struct rndis_set_complete *set_complete;
 	u32 extlen = sizeof(struct ndis_offload_params);
-	int ret, t;
+	int ret;
+	unsigned long t;
 	u32 vsp_version = nvdev->nvsp_version;
 
 	if (vsp_version <= NVSP_PROTOCOL_VERSION_4) {
@@ -708,7 +710,8 @@ int rndis_filter_set_rss_param(struct rndis_device *rdev, int num_queue)
 	struct ndis_recv_scale_param *rssp;
 	u32 *itab;
 	u8 *keyp;
-	int i, t, ret;
+	int i, ret;
+	unsigned long t;
 
 	request = get_rndis_request(
 			rdev, RNDIS_MSG_SET,
@@ -792,7 +795,8 @@ int rndis_filter_set_packet_filter(struct rndis_device *dev, u32 new_filter)
 	struct rndis_set_request *set;
 	struct rndis_set_complete *set_complete;
 	u32 status;
-	int ret, t;
+	int ret;
+	unsigned long t;
 	struct net_device *ndev;
 
 	ndev = dev->net_dev->ndev;
@@ -848,7 +852,8 @@ static int rndis_filter_init_device(struct rndis_device *dev)
 	struct rndis_initialize_request *init;
 	struct rndis_initialize_complete *init_complete;
 	u32 status;
-	int ret, t;
+	int ret;
+	unsigned long t;
 
 	request = get_rndis_request(dev, RNDIS_MSG_INIT,
 			RNDIS_MESSAGE_SIZE(struct rndis_initialize_request));
@@ -998,7 +1003,7 @@ int rndis_filter_device_add(struct hv_device *dev,
 	struct netvsc_device_info *device_info = additional_info;
 	struct ndis_offload_params offloads;
 	struct nvsp_message *init_packet;
-	int t;
+	unsigned long t;
 	struct ndis_recv_scale_cap rsscap;
 	u32 rsscap_size = sizeof(struct ndis_recv_scale_cap);
 	u32 mtu, size;
-- 
1.7.10.4

