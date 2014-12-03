Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaLCU1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:27:36 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42595 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaLCU1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:27:34 -0500
From: Jamie Lawler <jamie.lawler@gmail.com>
To: andreas.noever@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] thunderbolt: Add missing blank lines after declarations
Date: Wed,  3 Dec 2014 20:27:14 +0000
Message-Id: <1417638434-23238-1-git-send-email-jamie.lawler@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I've attached a patch that fixes the lack of blank lines after 9 declarations
within drivers/thunderbolt/ctl.c. ctl.c now passes checkpatch.pl

Regards,
Jamie Lawler

Signed-off-by: Jamie Lawler <jamie.lawler@gmail.com>

---
 drivers/thunderbolt/ctl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/thunderbolt/ctl.c b/drivers/thunderbolt/ctl.c
index 799634b..247c89c 100644
--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -202,6 +202,7 @@ static struct tb_cfg_result decode_error(struct ctl_pkg *response)
 {
 	struct cfg_error_pkg *pkg = response->buffer;
 	struct tb_cfg_result res = { 0 };
+
 	res.response_route = get_route(pkg->header);
 	res.response_port = 0;
 	res.err = check_header(response, sizeof(*pkg), TB_CFG_PKG_ERROR,
@@ -276,6 +277,7 @@ static void tb_cfg_print_error(struct tb_ctl *ctl,
 static void cpu_to_be32_array(__be32 *dst, u32 *src, size_t len)
 {
 	int i;
+
 	for (i = 0; i < len; i++)
 		dst[i] = cpu_to_be32(src[i]);
 }
@@ -283,6 +285,7 @@ static void cpu_to_be32_array(__be32 *dst, u32 *src, size_t len)
 static void be32_to_cpu_array(u32 *dst, __be32 *src, size_t len)
 {
 	int i;
+
 	for (i = 0; i < len; i++)
 		dst[i] = be32_to_cpu(src[i]);
 }
@@ -304,6 +307,7 @@ static void tb_ctl_pkg_free(struct ctl_pkg *pkg)
 static struct ctl_pkg *tb_ctl_pkg_alloc(struct tb_ctl *ctl)
 {
 	struct ctl_pkg *pkg = kzalloc(sizeof(*pkg), GFP_KERNEL);
+
 	if (!pkg)
 		return NULL;
 	pkg->ctl = ctl;
@@ -323,6 +327,7 @@ static void tb_ctl_tx_callback(struct tb_ring *ring, struct ring_frame *frame,
 			       bool canceled)
 {
 	struct ctl_pkg *pkg = container_of(frame, typeof(*pkg), frame);
+
 	tb_ctl_pkg_free(pkg);
 }
 
@@ -338,6 +343,7 @@ static int tb_ctl_tx(struct tb_ctl *ctl, void *data, size_t len,
 {
 	int res;
 	struct ctl_pkg *pkg;
+
 	if (len % 4 != 0) { /* required for le->be conversion */
 		tb_ctl_WARN(ctl, "TX: invalid size: %zu\n", len);
 		return -EINVAL;
@@ -475,6 +481,7 @@ struct tb_ctl *tb_ctl_alloc(struct tb_nhi *nhi, hotplug_cb cb, void *cb_data)
 {
 	int i;
 	struct tb_ctl *ctl = kzalloc(sizeof(*ctl), GFP_KERNEL);
+
 	if (!ctl)
 		return NULL;
 	ctl->nhi = nhi;
@@ -520,6 +527,7 @@ err:
 void tb_ctl_free(struct tb_ctl *ctl)
 {
 	int i;
+
 	if (ctl->rx)
 		ring_free(ctl->rx);
 	if (ctl->tx)
@@ -541,6 +549,7 @@ void tb_ctl_free(struct tb_ctl *ctl)
 void tb_ctl_start(struct tb_ctl *ctl)
 {
 	int i;
+
 	tb_ctl_info(ctl, "control channel starting...\n");
 	ring_start(ctl->tx); /* is used to ack hotplug packets, start first */
 	ring_start(ctl->rx);
-- 
2.1.0

