Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbbAQBls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 20:41:48 -0500
Received: from mail-bn1on0138.outbound.protection.outlook.com ([157.56.110.138]:4086
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751931AbbAQBlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 20:41:45 -0500
X-Greylist: delayed 2195 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 20:41:45 EST
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>, <bhamciu1@freescale.com>,
        <R89243@freescale.com>, <Geoff.Thorpe@freescale.com>,
        <bhupesh.sharma@freescale.com>, <nir.erez@freescale.com>,
        <richard.schmitt@freescale.com>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [RFC PATCH 1/1] drivers/bus: fsl-mc object allocator driver
Date: Fri, 16 Jan 2015 19:38:02 -0600
Message-ID: <1421458682-13773-2-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1421458682-13773-1-git-send-email-German.Rivera@freescale.com>
References: <1421458682-13773-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(45074003)(199003)(62966003)(76176999)(19580395003)(19580405001)(87936001)(6806004)(106466001)(69596002)(50466002)(81156004)(50226001)(50986999)(64706001)(77156002)(105606002)(48376002)(47776003)(85426001)(86362001)(575784001)(36756003)(46102003)(92566002)(229853001)(97736003)(2950100001)(2201001)(77096005)(68736005)(104016003)(2004002)(217873001)(579004)(559001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB454;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR03MB454;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR03MB454;
X-Forefront-PRVS: 04599F3534
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB454;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2015 01:41:40.2650
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB454
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fsl-mc object allocator driver manages "allocatable" fsl-mc
objects such as DPBPs, DPMCPs and DPCONs. It provides services to
other fsl-mc drivers to allocate/deallocate these types of objects.

Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
---
 drivers/bus/fsl-mc/Makefile       |   6 +-
 drivers/bus/fsl-mc/dpbp.c         | 358 ++++++++++++++++++++++++
 drivers/bus/fsl-mc/dpmcp-cmd.h    | 137 +++++++++
 drivers/bus/fsl-mc/dpmcp.c        | 309 +++++++++++++++++++++
 drivers/bus/fsl-mc/dpmcp.h        | 309 +++++++++++++++++++++
 drivers/bus/fsl-mc/dprc-driver.c  | 212 +++++++++++++-
 drivers/bus/fsl-mc/mc-allocator.c | 568 ++++++++++++++++++++++++++++++++++++++
 drivers/bus/fsl-mc/mc-bus.c       |  56 +++-
 drivers/bus/fsl-mc/mc-sys.c       |   2 +
 include/linux/fsl/dpbp-cmd.h      |  60 ++++
 include/linux/fsl/dpbp.h          | 346 +++++++++++++++++++++++
 include/linux/fsl/dpcon-cmd.h     |  62 +++++
 include/linux/fsl/mc-private.h    |  41 +++
 include/linux/fsl/mc-sys.h        |   6 +
 include/linux/fsl/mc.h            |  63 +++++
 15 files changed, 2518 insertions(+), 17 deletions(-)
 create mode 100644 drivers/bus/fsl-mc/dpbp.c
 create mode 100644 drivers/bus/fsl-mc/dpmcp-cmd.h
 create mode 100644 drivers/bus/fsl-mc/dpmcp.c
 create mode 100644 drivers/bus/fsl-mc/dpmcp.h
 create mode 100644 drivers/bus/fsl-mc/mc-allocator.c
 create mode 100644 include/linux/fsl/dpbp-cmd.h
 create mode 100644 include/linux/fsl/dpbp.h
 create mode 100644 include/linux/fsl/dpcon-cmd.h

diff --git a/drivers/bus/fsl-mc/Makefile b/drivers/bus/fsl-mc/Makefile
index 424e58e..3079045 100644
--- a/drivers/bus/fsl-mc/Makefile
+++ b/drivers/bus/fsl-mc/Makefile
@@ -5,7 +5,8 @@
 #
 # This file is released under the GPLv2
 #
-obj-$(CONFIG_FSL_MC_BUS) += mc-bus-driver.o
+obj-$(CONFIG_FSL_MC_BUS) += mc-bus-driver.o \
+			    mc-allocator-driver.o

 mc-bus-driver-objs := mc-bus.o \
 		      mc-sys.o \
@@ -13,3 +14,6 @@ mc-bus-driver-objs := mc-bus.o \
 		      dpmng.o \
 		      dprc-driver.o

+mc-allocator-driver-objs := mc-allocator.o \
+			    dpbp.o \
+			    dpcon.o
diff --git a/drivers/bus/fsl-mc/dpbp.c b/drivers/bus/fsl-mc/dpbp.c
new file mode 100644
index 0000000..cc63915
--- /dev/null
+++ b/drivers/bus/fsl-mc/dpbp.c
@@ -0,0 +1,358 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+*
+* Redistribution and use in source and binary forms, with or without
+* modification, are permitted provided that the following conditions are met:
+* * Redistributions of source code must retain the above copyright
+* notice, this list of conditions and the following disclaimer.
+* * Redistributions in binary form must reproduce the above copyright
+* notice, this list of conditions and the following disclaimer in the
+* documentation and/or other materials provided with the distribution.
+* * Neither the name of the above-listed copyright holders nor the
+* names of any contributors may be used to endorse or promote products
+* derived from this software without specific prior written permission.
+*
+*
+* ALTERNATIVELY, this software may be distributed under the terms of the
+* GNU General Public License ("GPL") as published by the Free Software
+* Foundation, either version 2 of that License or (at your option) any
+* later version.
+*
+* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+* POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/fsl/mc-sys.h>
+#include <linux/fsl/mc-cmd.h>
+#include <linux/fsl/dpbp.h>
+#include <linux/fsl/dpbp-cmd.h>
+
+int dpbp_open(struct fsl_mc_io *mc_io, int dpbp_id, uint16_t *token)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_OPEN,
+					  MC_CMD_PRI_LOW, 0);
+	cmd.params[0] |= mc_enc(0, 32, dpbp_id);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*token = MC_CMD_HDR_READ_AUTHID(cmd.header);
+
+	return err;
+}
+EXPORT_SYMBOL(dpbp_open);
+
+int dpbp_close(struct fsl_mc_io *mc_io, uint16_t token)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_CLOSE, MC_CMD_PRI_HIGH,
+					  token);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+EXPORT_SYMBOL(dpbp_close);
+
+int dpbp_create(struct fsl_mc_io *mc_io,
+		const struct dpbp_cfg *cfg,
+		uint16_t *token)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	(void)(cfg); /* unused */
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_CREATE,
+					  MC_CMD_PRI_LOW, 0);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*token = MC_CMD_HDR_READ_AUTHID(cmd.header);
+
+	return 0;
+}
+
+int dpbp_destroy(struct fsl_mc_io *mc_io, uint16_t token)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_DESTROY,
+					  MC_CMD_PRI_LOW, token);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpbp_enable(struct fsl_mc_io *mc_io, uint16_t token)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_ENABLE, MC_CMD_PRI_LOW,
+					  token);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+EXPORT_SYMBOL(dpbp_enable);
+
+int dpbp_disable(struct fsl_mc_io *mc_io, uint16_t token)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_DISABLE,
+					  MC_CMD_PRI_LOW, token);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+EXPORT_SYMBOL(dpbp_disable);
+
+int dpbp_is_enabled(struct fsl_mc_io *mc_io, uint16_t token, int *en)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_IS_ENABLED, MC_CMD_PRI_LOW,
+					  token);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*en = (int)mc_dec(cmd.params[0], 0, 1);
+
+	return 0;
+}
+
+int dpbp_reset(struct fsl_mc_io *mc_io, uint16_t token)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_RESET,
+					  MC_CMD_PRI_LOW, token);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpbp_set_irq(struct fsl_mc_io *mc_io,
+		 uint16_t token,
+		 uint8_t irq_index,
+		 uint64_t irq_paddr,
+		 uint32_t irq_val,
+		 int user_irq_id)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_SET_IRQ,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(0, 8, irq_index);
+	cmd.params[0] |= mc_enc(32, 32, irq_val);
+	cmd.params[1] |= mc_enc(0, 64, irq_paddr);
+	cmd.params[2] |= mc_enc(0, 32, user_irq_id);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpbp_get_irq(struct fsl_mc_io *mc_io,
+		 uint16_t token,
+		 uint8_t irq_index,
+		 int *type,
+		 uint64_t *irq_paddr,
+		 uint32_t *irq_val,
+		 int *user_irq_id)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_GET_IRQ,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*irq_val = (uint32_t)mc_dec(cmd.params[0], 0, 32);
+	*irq_paddr = (uint64_t)mc_dec(cmd.params[1], 0, 64);
+	*user_irq_id = (int)mc_dec(cmd.params[2], 0, 32);
+	*type = (int)mc_dec(cmd.params[2], 32, 32);
+	return 0;
+}
+
+int dpbp_set_irq_enable(struct fsl_mc_io *mc_io,
+			uint16_t token,
+			uint8_t irq_index,
+			uint8_t en)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_SET_IRQ_ENABLE,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(0, 8, en);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpbp_get_irq_enable(struct fsl_mc_io *mc_io,
+			uint16_t token,
+			uint8_t irq_index,
+			uint8_t *en)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_GET_IRQ_ENABLE,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*en = (uint8_t)mc_dec(cmd.params[0], 0, 8);
+	return 0;
+}
+
+int dpbp_set_irq_mask(struct fsl_mc_io *mc_io,
+		      uint16_t token,
+		      uint8_t irq_index,
+		      uint32_t mask)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_SET_IRQ_MASK,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(0, 32, mask);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpbp_get_irq_mask(struct fsl_mc_io *mc_io,
+		      uint16_t token,
+		      uint8_t irq_index,
+		      uint32_t *mask)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_GET_IRQ_MASK,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*mask = (uint32_t)mc_dec(cmd.params[0], 0, 32);
+	return 0;
+}
+
+int dpbp_get_irq_status(struct fsl_mc_io *mc_io,
+			uint16_t token,
+			uint8_t irq_index,
+			uint32_t *status)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_GET_IRQ_STATUS,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*status = (uint32_t)mc_dec(cmd.params[0], 0, 32);
+	return 0;
+}
+
+int dpbp_clear_irq_status(struct fsl_mc_io *mc_io,
+			  uint16_t token,
+			  uint8_t irq_index,
+			  uint32_t status)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_CLEAR_IRQ_STATUS,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(0, 32, status);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpbp_get_attributes(struct fsl_mc_io *mc_io,
+			uint16_t token,
+			struct dpbp_attr *attr)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPBP_CMDID_GET_ATTR,
+					  MC_CMD_PRI_LOW, token);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	attr->bpid = (uint16_t)mc_dec(cmd.params[0], 16, 16);
+	attr->id = (int)mc_dec(cmd.params[0], 32, 32);
+	attr->version.major = (uint16_t)mc_dec(cmd.params[1], 0, 16);
+	attr->version.minor = (uint16_t)mc_dec(cmd.params[1], 16, 16);
+	return 0;
+}
+EXPORT_SYMBOL(dpbp_get_attributes);
diff --git a/drivers/bus/fsl-mc/dpmcp-cmd.h b/drivers/bus/fsl-mc/dpmcp-cmd.h
new file mode 100644
index 0000000..8e17c63
--- /dev/null
+++ b/drivers/bus/fsl-mc/dpmcp-cmd.h
@@ -0,0 +1,137 @@
+/* Copyright 2013-2015 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ * * Redistributions of source code must retain the above copyright
+ * notice, this list of conditions and the following disclaimer.
+ * * Redistributions in binary form must reproduce the above copyright
+ * notice, this list of conditions and the following disclaimer in the
+ * documentation and/or other materials provided with the distribution.
+ * * Neither the name of the above-listed copyright holders nor the
+ * names of any contributors may be used to endorse or promote products
+ * derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+#ifndef _FSL_DPMCP_CMD_H
+#define _FSL_DPMCP_CMD_H
+
+/* DPMCP Version */
+#define DPMCP_VER_MAJOR				1
+#define DPMCP_VER_MINOR				0
+
+/* Command IDs */
+#define DPMCP_CMDID_CLOSE				0x800
+#define DPMCP_CMDID_OPEN				0x80b
+#define DPMCP_CMDID_CREATE				0x90b
+#define DPMCP_CMDID_DESTROY				0x900
+
+#define DPMCP_CMDID_GET_ATTR				0x004
+#define DPMCP_CMDID_RESET				0x005
+
+#define DPMCP_CMDID_SET_IRQ				0x010
+#define DPMCP_CMDID_GET_IRQ				0x011
+#define DPMCP_CMDID_SET_IRQ_ENABLE			0x012
+#define DPMCP_CMDID_GET_IRQ_ENABLE			0x013
+#define DPMCP_CMDID_SET_IRQ_MASK			0x014
+#define DPMCP_CMDID_GET_IRQ_MASK			0x015
+#define DPMCP_CMDID_GET_IRQ_STATUS			0x016
+#define DPMCP_CMDID_CLEAR_IRQ_STATUS			0x017
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_CMD_CREATE(cmd, cfg) \
+	MC_CMD_OP(cmd, 0, 0,  32, int,      cfg->portal_id)
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_CMD_SET_IRQ(cmd, irq_index, irq_addr, irq_val, user_irq_id) \
+do { \
+	MC_CMD_OP(cmd, 0, 0,  8,  uint8_t,  irq_index);\
+	MC_CMD_OP(cmd, 0, 32, 32, uint32_t, irq_val);\
+	MC_CMD_OP(cmd, 1, 0,  64, uint64_t, irq_addr); \
+	MC_CMD_OP(cmd, 2, 0,  32, int,	    user_irq_id); \
+} while (0)
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_CMD_GET_IRQ(cmd, irq_index) \
+	MC_CMD_OP(cmd, 0, 32, 8,  uint8_t,  irq_index)
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_RSP_GET_IRQ(cmd, type, irq_addr, irq_val, user_irq_id) \
+do { \
+	MC_RSP_OP(cmd, 0, 0,  32, uint32_t, irq_val); \
+	MC_RSP_OP(cmd, 1, 0,  64, uint64_t, irq_addr); \
+	MC_RSP_OP(cmd, 2, 0,  32, int,	    user_irq_id); \
+	MC_RSP_OP(cmd, 2, 32, 32, int,	    type); \
+} while (0)
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_CMD_SET_IRQ_ENABLE(cmd, irq_index, en) \
+do { \
+	MC_CMD_OP(cmd, 0, 0,  8,  uint8_t,  en); \
+	MC_CMD_OP(cmd, 0, 32, 8,  uint8_t,  irq_index);\
+} while (0)
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_CMD_GET_IRQ_ENABLE(cmd, irq_index) \
+	MC_CMD_OP(cmd, 0, 32, 8,  uint8_t,  irq_index)
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_RSP_GET_IRQ_ENABLE(cmd, en) \
+	MC_RSP_OP(cmd, 0, 0,  8,  uint8_t,  en)
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_CMD_SET_IRQ_MASK(cmd, irq_index, mask) \
+do { \
+	MC_CMD_OP(cmd, 0, 0,  32, uint32_t, mask);\
+	MC_CMD_OP(cmd, 0, 32, 8,  uint8_t,  irq_index);\
+} while (0)
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_CMD_GET_IRQ_MASK(cmd, irq_index) \
+	MC_CMD_OP(cmd, 0, 32, 8,  uint8_t,  irq_index)
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_RSP_GET_IRQ_MASK(cmd, mask) \
+	MC_RSP_OP(cmd, 0, 0,  32, uint32_t, mask)
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_CMD_GET_IRQ_STATUS(cmd, irq_index) \
+	MC_CMD_OP(cmd, 0, 32, 8,  uint8_t,  irq_index)
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_RSP_GET_IRQ_STATUS(cmd, status) \
+	MC_RSP_OP(cmd, 0, 0,  32, uint32_t, status)
+
+/*                cmd, param, offset, width, type, arg_name */
+#define DPMCP_CMD_CLEAR_IRQ_STATUS(cmd, irq_index, status) \
+do { \
+	MC_CMD_OP(cmd, 0, 0,  32, uint32_t, status); \
+	MC_CMD_OP(cmd, 0, 32, 8,  uint8_t,  irq_index);\
+} while (0)
+
+/*                cmd, param, offset, width, type,	arg_name */
+#define DPMCP_RSP_GET_ATTRIBUTES(cmd, attr) \
+do { \
+	MC_RSP_OP(cmd, 0, 0,  32, int,      attr->portal_id);\
+	MC_RSP_OP(cmd, 0, 32, 32, int,	    attr->id);\
+	MC_RSP_OP(cmd, 1, 0,  16, uint16_t, attr->version.major);\
+	MC_RSP_OP(cmd, 1, 16, 16, uint16_t, attr->version.minor);\
+} while (0)
+
+#endif /* _FSL_DPMCP_CMD_H */
diff --git a/drivers/bus/fsl-mc/dpmcp.c b/drivers/bus/fsl-mc/dpmcp.c
new file mode 100644
index 0000000..ecea9cf
--- /dev/null
+++ b/drivers/bus/fsl-mc/dpmcp.c
@@ -0,0 +1,309 @@
+/* Copyright 2013-2015 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ * * Redistributions of source code must retain the above copyright
+ * notice, this list of conditions and the following disclaimer.
+ * * Redistributions in binary form must reproduce the above copyright
+ * notice, this list of conditions and the following disclaimer in the
+ * documentation and/or other materials provided with the distribution.
+ * * Neither the name of the above-listed copyright holders nor the
+ * names of any contributors may be used to endorse or promote products
+ * derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+#include <linux/fsl/mc-sys.h>
+#include <linux/fsl/mc-cmd.h>
+#include "dpmcp.h"
+#include "dpmcp-cmd.h"
+
+int dpmcp_open(struct fsl_mc_io *mc_io, int dpmcp_id, uint16_t *token)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_OPEN,
+					  MC_CMD_PRI_LOW, 0);
+	cmd.params[0] |= mc_enc(0, 32, dpmcp_id);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*token = MC_CMD_HDR_READ_TOKEN(cmd.header);
+
+	return err;
+}
+
+int dpmcp_close(struct fsl_mc_io *mc_io, uint16_t token)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_CLOSE, MC_CMD_PRI_HIGH,
+					  token);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpmcp_create(struct fsl_mc_io *mc_io,
+		 const struct dpmcp_cfg *cfg,
+		uint16_t *token)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_CREATE,
+					  MC_CMD_PRI_LOW, 0);
+	cmd.params[0] |= mc_enc(0, 32, cfg->portal_id);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*token = MC_CMD_HDR_READ_TOKEN(cmd.header);
+
+	return 0;
+}
+
+int dpmcp_destroy(struct fsl_mc_io *mc_io, uint16_t token)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_DESTROY,
+					  MC_CMD_PRI_LOW, token);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpmcp_reset(struct fsl_mc_io *mc_io, uint16_t token)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_RESET,
+					  MC_CMD_PRI_LOW, token);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpmcp_set_irq(struct fsl_mc_io *mc_io,
+		  uint16_t token,
+		 uint8_t irq_index,
+		 uint64_t irq_addr,
+		 uint32_t irq_val,
+		 int user_irq_id)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_SET_IRQ,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(0, 8, irq_index);
+	cmd.params[0] |= mc_enc(32, 32, irq_val);
+	cmd.params[1] |= mc_enc(0, 64, irq_addr);
+	cmd.params[2] |= mc_enc(0, 32, user_irq_id);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpmcp_get_irq(struct fsl_mc_io *mc_io,
+		  uint16_t token,
+		 uint8_t irq_index,
+		 int *type,
+		 uint64_t *irq_addr,
+		 uint32_t *irq_val,
+		 int *user_irq_id)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_GET_IRQ,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*irq_val = (uint32_t)mc_dec(cmd.params[0], 0, 32);
+	*irq_addr = (uint64_t)mc_dec(cmd.params[1], 0, 64);
+	*user_irq_id = (int)mc_dec(cmd.params[2], 0, 32);
+	*type = (int)mc_dec(cmd.params[2], 32, 32);
+	return 0;
+}
+
+int dpmcp_set_irq_enable(struct fsl_mc_io *mc_io,
+			 uint16_t token,
+			uint8_t irq_index,
+			uint8_t en)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_SET_IRQ_ENABLE,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(0, 8, en);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpmcp_get_irq_enable(struct fsl_mc_io *mc_io,
+			 uint16_t token,
+			uint8_t irq_index,
+			uint8_t *en)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_GET_IRQ_ENABLE,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*en = (uint8_t)mc_dec(cmd.params[0], 0, 8);
+	return 0;
+}
+
+int dpmcp_set_irq_mask(struct fsl_mc_io *mc_io,
+		       uint16_t token,
+		      uint8_t irq_index,
+		      uint32_t mask)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_SET_IRQ_MASK,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(0, 32, mask);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpmcp_get_irq_mask(struct fsl_mc_io *mc_io,
+		       uint16_t token,
+		      uint8_t irq_index,
+		      uint32_t *mask)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_GET_IRQ_MASK,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*mask = (uint32_t)mc_dec(cmd.params[0], 0, 32);
+	return 0;
+}
+
+int dpmcp_get_irq_status(struct fsl_mc_io *mc_io,
+			 uint16_t token,
+			uint8_t irq_index,
+			uint32_t *status)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_GET_IRQ_STATUS,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	*status = (uint32_t)mc_dec(cmd.params[0], 0, 32);
+	return 0;
+}
+
+int dpmcp_clear_irq_status(struct fsl_mc_io *mc_io,
+			   uint16_t token,
+			  uint8_t irq_index,
+			  uint32_t status)
+{
+	struct mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_CLEAR_IRQ_STATUS,
+					  MC_CMD_PRI_LOW, token);
+	cmd.params[0] |= mc_enc(0, 32, status);
+	cmd.params[0] |= mc_enc(32, 8, irq_index);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpmcp_get_attributes(struct fsl_mc_io *mc_io,
+			 uint16_t token,
+			struct dpmcp_attr *attr)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPMCP_CMDID_GET_ATTR,
+					  MC_CMD_PRI_LOW, token);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	attr->portal_id = (int)mc_dec(cmd.params[0], 0, 32);
+	attr->id = (int)mc_dec(cmd.params[0], 32, 32);
+	attr->version.major = (uint16_t)mc_dec(cmd.params[1], 0, 16);
+	attr->version.minor = (uint16_t)mc_dec(cmd.params[1], 16, 16);
+	return 0;
+}
diff --git a/drivers/bus/fsl-mc/dpmcp.h b/drivers/bus/fsl-mc/dpmcp.h
new file mode 100644
index 0000000..5308508
--- /dev/null
+++ b/drivers/bus/fsl-mc/dpmcp.h
@@ -0,0 +1,309 @@
+/* Copyright 2013-2015 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ * * Redistributions of source code must retain the above copyright
+ * notice, this list of conditions and the following disclaimer.
+ * * Redistributions in binary form must reproduce the above copyright
+ * notice, this list of conditions and the following disclaimer in the
+ * documentation and/or other materials provided with the distribution.
+ * * Neither the name of the above-listed copyright holders nor the
+ * names of any contributors may be used to endorse or promote products
+ * derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+#ifndef __FSL_DPMCP_H
+#define __FSL_DPMCP_H
+
+/* Data Path Management Command Portal API
+ * Contains initialization APIs and runtime control APIs for DPMCP
+ */
+
+struct fsl_mc_io;
+
+/**
+ * dpmcp_open() - Open a control session for the specified object.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @dpmcp_id:	DPMCP unique ID
+ * @token:	Returned token; use in subsequent API calls
+ *
+ * This function can be used to open a control session for an
+ * already created object; an object may have been declared in
+ * the DPL or by calling the dpmcp_create function.
+ * This function returns a unique authentication token,
+ * associated with the specific object ID and the specific MC
+ * portal; this token must be used in all subsequent commands for
+ * this specific object
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_open(struct fsl_mc_io *mc_io, int dpmcp_id, uint16_t *token);
+
+/**
+ * dpmcp_close() - Close the control session of the object
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @token:	Token of DPMCP object
+ *
+ * After this function is called, no further operations are
+ * allowed on the object without opening a new control session.
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_close(struct fsl_mc_io *mc_io, uint16_t token);
+
+/**
+ * struct dpmcp_cfg() - Structure representing DPMCP configuration
+ * @portal_id:	Portal ID
+ */
+struct dpmcp_cfg {
+	int portal_id;
+};
+
+/**
+ * dpmcp_create() - Create the DPMCP object.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cfg:	Configuration structure
+ * @token:	Returned token; use in subsequent API calls
+ *
+ * Create the DPMCP object, allocate required resources and
+ * perform required initialization.
+ *
+ * The object can be created either by declaring it in the
+ * DPL file, or by calling this function.
+ * This function returns a unique authentication token,
+ * associated with the specific object ID and the specific MC
+ * portal; this token must be used in all subsequent calls to
+ * this specific object. For objects that are created using the
+ * DPL file, call dpmcp_open function to get an authentication
+ * token first.
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_create(struct fsl_mc_io	*mc_io,
+		 const struct dpmcp_cfg	*cfg,
+		uint16_t		*token);
+
+/**
+ * dpmcp_destroy() - Destroy the DPMCP object and release all its resources.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @token:	Token of DPMCP object
+ *
+ * Return:	'0' on Success; error code otherwise.
+ */
+int dpmcp_destroy(struct fsl_mc_io *mc_io, uint16_t token);
+
+/**
+ * dpmcp_reset() - Reset the DPMCP, returns the object to initial state.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @token:	Token of DPMCP object
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_reset(struct fsl_mc_io *mc_io, uint16_t token);
+
+/* IRQ */
+/*!
+ * @name dpmcp IRQ Index and Events
+ */
+#define DPMCP_IRQ_INDEX                             0
+/*!< Irq index */
+#define DPMCP_IRQ_EVENT_CMD_DONE                    0x00000001
+/*!< irq event - Indicates that the link state changed */
+/* @} */
+
+/**
+ * dpmcp_set_irq() - Set IRQ information for the DPMCP to trigger an interrupt.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @token:	Token of DPMCP object
+ * @irq_index:	Identifies the interrupt index to configure
+ * @irq_addr:	Address that must be written to
+ *				signal a message-based interrupt
+ * @irq_val:	Value to write into irq_addr address
+ * @user_irq_id: A user defined number associated with this IRQ
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_set_irq(struct fsl_mc_io	*mc_io,
+		  uint16_t		token,
+		 uint8_t		irq_index,
+		 uint64_t		irq_addr,
+		 uint32_t		irq_val,
+		 int			user_irq_id);
+
+/**
+ * dpmcp_get_irq() - Get IRQ information from the DPMCP.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @token:	Token of DPMCP object
+ * @irq_index:	The interrupt index to configure
+ * @type:	Interrupt type: 0 represents message interrupt
+ *				type (both irq_addr and irq_val are valid)
+ * @irq_addr:	Returned address that must be written to
+ *				signal the message-based interrupt
+ * @irq_val:	Value to write into irq_addr address
+ * @user_irq_id: A user defined number associated with this IRQ
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_get_irq(struct fsl_mc_io	*mc_io,
+		  uint16_t		token,
+		 uint8_t		irq_index,
+		 int			*type,
+		 uint64_t		*irq_addr,
+		 uint32_t		*irq_val,
+		 int			*user_irq_id);
+
+/**
+ * dpmcp_set_irq_enable() - Set overall interrupt state.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @token:	Token of DPMCP object
+ * @irq_index:	The interrupt index to configure
+ * @en:	Interrupt state - enable = 1, disable = 0
+ *
+ * Allows GPP software to control when interrupts are generated.
+ * Each interrupt can have up to 32 causes.  The enable/disable control's the
+ * overall interrupt state. if the interrupt is disabled no causes will cause
+ * an interrupt.
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_set_irq_enable(struct fsl_mc_io	*mc_io,
+			 uint16_t		token,
+			uint8_t			irq_index,
+			uint8_t			en);
+
+/**
+ * dpmcp_get_irq_enable() - Get overall interrupt state
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @token:	Token of DPMCP object
+ * @irq_index:	The interrupt index to configure
+ * @en:		Returned interrupt state - enable = 1, disable = 0
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_get_irq_enable(struct fsl_mc_io	*mc_io,
+			 uint16_t		token,
+			uint8_t			irq_index,
+			uint8_t			*en);
+
+/**
+ * dpmcp_set_irq_mask() - Set interrupt mask.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @token:	Token of DPMCP object
+ * @irq_index:	The interrupt index to configure
+ * @mask:	Event mask to trigger interrupt;
+ *			each bit:
+ *				0 = ignore event
+ *				1 = consider event for asserting IRQ
+ *
+ * Every interrupt can have up to 32 causes and the interrupt model supports
+ * masking/unmasking each cause independently
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_set_irq_mask(struct fsl_mc_io	*mc_io,
+		       uint16_t		token,
+		      uint8_t		irq_index,
+		      uint32_t		mask);
+
+/**
+ * dpmcp_get_irq_mask() - Get interrupt mask.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @token:	Token of DPMCP object
+ * @irq_index:	The interrupt index to configure
+ * @mask:	Returned event mask to trigger interrupt
+ *
+ * Every interrupt can have up to 32 causes and the interrupt model supports
+ * masking/unmasking each cause independently
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_get_irq_mask(struct fsl_mc_io	*mc_io,
+		       uint16_t		token,
+		      uint8_t		irq_index,
+		      uint32_t		*mask);
+
+/**
+ * dpmcp_get_irq_status() - Get the current status of any pending interrupts.
+ *
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @token:	Token of DPMCP object
+ * @irq_index:	The interrupt index to configure
+ * @status:	Returned interrupts status - one bit per cause:
+ *			0 = no interrupt pending
+ *			1 = interrupt pending
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_get_irq_status(struct fsl_mc_io	*mc_io,
+			 uint16_t		token,
+			uint8_t			irq_index,
+			uint32_t		*status);
+
+/**
+ * dpmcp_clear_irq_status() - Clear a pending interrupt's status
+ *
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @token:	Token of DPMCP object
+ * @irq_index:	The interrupt index to configure
+ * @status:	Bits to clear (W1C) - one bit per cause:
+ *					0 = don't change
+ *					1 = clear status bit
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_clear_irq_status(struct fsl_mc_io	*mc_io,
+			   uint16_t		token,
+			  uint8_t		irq_index,
+			  uint32_t		status);
+
+/**
+ * struct dpmcp_attr - Structure representing DPMCP attributes
+ * @id:		DPMCP object ID
+ * @portal_id:	Portal ID
+ * @version:	DPMCP version
+ */
+struct dpmcp_attr {
+	int id;
+	int portal_id;
+	/**
+	 * struct version - Structure representing DPMCP version
+	 * @major:	DPMCP major version
+	 * @minor:	DPMCP minor version
+	 */
+	struct {
+		uint16_t major;
+		uint16_t minor;
+	} version;
+};
+
+/**
+ * dpmcp_get_attributes - Retrieve DPMCP attributes.
+ *
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @token:	Token of DPMCP object
+ * @attr:	Returned object's attributes
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpmcp_get_attributes(struct fsl_mc_io	*mc_io,
+			 uint16_t		token,
+			struct dpmcp_attr	*attr);
+
+#endif /* __FSL_DPMCP_H */
diff --git a/drivers/bus/fsl-mc/dprc-driver.c b/drivers/bus/fsl-mc/dprc-driver.c
index 5d07e30..caec8c1 100644
--- a/drivers/bus/fsl-mc/dprc-driver.c
+++ b/drivers/bus/fsl-mc/dprc-driver.c
@@ -176,7 +176,8 @@ static void dprc_add_new_devices(struct fsl_mc_device *mc_bus_dev,

 			error = fsl_create_mc_io(&mc_bus_dev->dev,
 						 region_desc.base_paddr,
-						 region_desc.size, 0, &mc_io);
+						 region_desc.size,
+						 NULL, 0, &mc_io);
 			if (error < 0)
 				continue;
 		}
@@ -192,6 +193,181 @@ static void dprc_add_new_devices(struct fsl_mc_device *mc_bus_dev,
 	}
 }

+static void dprc_init_all_resource_pools(struct fsl_mc_device *mc_bus_dev)
+{
+	int pool_type;
+	struct fsl_mc_bus *mc_bus = to_fsl_mc_bus(mc_bus_dev);
+
+	for (pool_type = 0; pool_type < FSL_MC_NUM_POOL_TYPES; pool_type++) {
+		struct fsl_mc_resource_pool *res_pool =
+		    &mc_bus->resource_pools[pool_type];
+
+		res_pool->type = pool_type;
+		res_pool->max_count = 0;
+		res_pool->free_count = 0;
+		res_pool->mc_bus = mc_bus;
+		INIT_LIST_HEAD(&res_pool->free_list);
+		mutex_init(&res_pool->mutex);
+	}
+}
+
+/**
+ * dprc_scan_resources - Scan a physical DPRC for resources of the given
+ * type
+ *
+ * @mc_bus_dev: pointer to the fsl-mc device that represents the DPRC
+ * @pool_type: MC bus resource pool type
+ * @mc_res_type: MC resource type
+ *
+ * Populates the DPRC device's pool of MC resources of the given
+ * type, with the resources discovered in the physical DPRC.
+ */
+static int dprc_scan_resources(struct fsl_mc_device *mc_bus_dev,
+			       enum fsl_mc_pool_type pool_type,
+			       char *mc_res_type)
+{
+	int error = -EINVAL;
+	struct dprc_res_ids_range_desc range_desc;
+	struct fsl_mc_resource *resource;
+	struct fsl_mc_resource *next;
+	int res_count;
+	int free_count = 0;
+	struct fsl_mc_bus *mc_bus = to_fsl_mc_bus(mc_bus_dev);
+	struct fsl_mc_resource_pool *res_pool =
+			&mc_bus->resource_pools[pool_type];
+
+	if (WARN_ON(res_pool->max_count != 0))
+		goto error;
+
+	error = dprc_get_res_count(mc_bus_dev->mc_io, mc_bus_dev->mc_handle,
+				   mc_res_type, &res_count);
+	if (error < 0) {
+		dev_err(&mc_bus_dev->dev, "dprc_get_res_count() failed: %d\n",
+			error);
+		goto error;
+	}
+
+	if (WARN_ON(res_count < 0)) {
+		error = -EINVAL;
+		goto error;
+	}
+
+	if (res_count == 0)
+		goto out;
+
+	res_pool->max_count = res_count;
+	memset(&range_desc, 0, sizeof(struct dprc_res_ids_range_desc));
+	do {
+		int id;
+
+		error = dprc_get_res_ids(mc_bus_dev->mc_io,
+					 mc_bus_dev->mc_handle,
+					 mc_res_type, &range_desc);
+		if (error < 0) {
+			dev_err(&mc_bus_dev->dev,
+				"dprc_get_res_ids() failed: %d\n", error);
+			goto error;
+		}
+
+		for (id = range_desc.base_id; id <= range_desc.last_id; id++) {
+			resource = devm_kzalloc(&mc_bus_dev->dev,
+						sizeof(*resource),
+						GFP_KERNEL);
+			if (!resource) {
+				error = -ENOMEM;
+				goto error;
+			}
+
+			resource->type = res_pool->type;
+			resource->id = id;
+			resource->data = NULL;
+			resource->parent_pool = res_pool;
+			INIT_LIST_HEAD(&resource->node);
+			list_add_tail(&resource->node, &res_pool->free_list);
+			free_count++;
+		}
+	} while (free_count < res_pool->max_count &&
+		 range_desc.iter_status != DPRC_ITER_STATUS_LAST);
+
+	res_pool->free_count = free_count;
+out:
+	return 0;
+error:
+
+	if (free_count != 0) {
+		list_for_each_entry_safe(resource, next, &res_pool->free_list,
+					 node) {
+			devm_kfree(&mc_bus_dev->dev, resource);
+			free_count--;
+		}
+
+		WARN_ON(free_count != 0);
+	}
+
+	return error;
+}
+
+static void dprc_cleanup_resource_pool(struct fsl_mc_device *mc_bus_dev,
+				       enum fsl_mc_pool_type pool_type)
+{
+	struct fsl_mc_resource *resource;
+	struct fsl_mc_resource *next;
+	struct fsl_mc_bus *mc_bus = to_fsl_mc_bus(mc_bus_dev);
+	struct fsl_mc_resource_pool *res_pool =
+					&mc_bus->resource_pools[pool_type];
+	int free_count = 0;
+
+	WARN_ON(res_pool->type != pool_type);
+	WARN_ON(res_pool->free_count != res_pool->max_count);
+
+	list_for_each_entry_safe(resource, next, &res_pool->free_list, node) {
+		free_count++;
+		WARN_ON(resource->type != res_pool->type);
+		WARN_ON(resource->parent_pool != res_pool);
+		devm_kfree(&mc_bus_dev->dev, resource);
+	}
+
+	WARN_ON(free_count != res_pool->free_count);
+}
+
+static void dprc_cleanup_all_resource_pools(struct fsl_mc_device *mc_bus_dev)
+{
+	int pool_type;
+
+	for (pool_type = 0; pool_type < FSL_MC_NUM_POOL_TYPES; pool_type++)
+		dprc_cleanup_resource_pool(mc_bus_dev, pool_type);
+}
+
+static void reorder_obj_desc_array(struct dprc_obj_desc *obj_desc_array,
+				   int num_devs)
+{
+	struct dprc_obj_desc tmp;
+	struct dprc_obj_desc *top_cursor = &obj_desc_array[0];
+	struct dprc_obj_desc *bottom_cursor = &obj_desc_array[num_devs - 1];
+
+	/*
+	 * Reorder entries in obj_desc_array so that all allocatable devices
+	 * are placed before all non-allocatable devices:
+	 *
+	 * Loop Invariant: everything before top_cursor is allocatable and
+	 * everything after bottom_cursor is non-allocatable.
+	 */
+	while (top_cursor < bottom_cursor) {
+		if (FSL_MC_IS_ALLOCATABLE(top_cursor->type)) {
+			top_cursor++;
+		} else {
+			if (FSL_MC_IS_ALLOCATABLE(bottom_cursor->type)) {
+				tmp = *bottom_cursor;
+				*bottom_cursor = *top_cursor;
+				*top_cursor = tmp;
+				top_cursor++;
+			}
+
+			bottom_cursor--;
+		}
+	}
+}
+
 /**
  * dprc_scan_objects - Discover objects in a DPRC
  *
@@ -200,6 +376,14 @@ static void dprc_add_new_devices(struct fsl_mc_device *mc_bus_dev,
  * Detects objects added and removed from a DPRC and synchronizes the
  * state of the Linux bus driver, MC by adding and removing
  * devices accordingly.
+ * Two types of devices can be found in a DPRC: allocatable (e.g., DP_DEV_DPBP)
+ * and non-allocatable (e.g., DP_DEV_DPRC, DP_DEV_DPNI).
+ * All allocatable devices needed to be probed before all non-allocatable
+ * devices, to ensure that device drivers for non-allocatable
+ * devices can allocate any type of allocatable devices.
+ * That is, we need to ensure that the corresponding resource pools are
+ * populated before they can get allocation requests from probe callbacks
+ * of the device drivers for the non-allocatable devices.
  */
 int dprc_scan_objects(struct fsl_mc_device *mc_bus_dev)
 {
@@ -262,6 +446,8 @@ int dprc_scan_objects(struct fsl_mc_device *mc_bus_dev)
 				"%d out of %d devices could not be retrieved\n",
 				dprc_get_obj_failures, num_child_objects);
 		}
+
+		reorder_obj_desc_array(child_obj_desc_array, num_child_objects);
 	}

 	dprc_remove_devices(mc_bus_dev, child_obj_desc_array,
@@ -288,7 +474,28 @@ EXPORT_SYMBOL_GPL(dprc_scan_objects);
  */
 int dprc_scan_container(struct fsl_mc_device *mc_bus_dev)
 {
-	return dprc_scan_objects(mc_bus_dev);
+	int error = -EINVAL;
+
+	dprc_init_all_resource_pools(mc_bus_dev);
+
+	/*
+	 * Discover free MC portals in the DPRC:
+	 */
+	error = dprc_scan_resources(mc_bus_dev, FSL_MC_POOL_MCP, "mcp");
+	if (error < 0)
+		goto error;
+
+	/*
+	 * Discover objects in the DPRC:
+	 */
+	error = dprc_scan_objects(mc_bus_dev);
+	if (error < 0)
+		goto error;
+
+	return 0;
+error:
+	dprc_cleanup_all_resource_pools(mc_bus_dev);
+	return error;
 }
 EXPORT_SYMBOL_GPL(dprc_scan_container);

@@ -344,6 +551,7 @@ static int dprc_remove(struct fsl_mc_device *mc_dev)
 		return -EINVAL;

 	device_for_each_child(&mc_dev->dev, NULL, __fsl_mc_device_remove);
+	dprc_cleanup_all_resource_pools(mc_dev);
 	error = dprc_close(mc_dev->mc_io, mc_dev->mc_handle);
 	if (error < 0)
 		dev_err(&mc_dev->dev, "dprc_close() failed: %d\n", error);
diff --git a/drivers/bus/fsl-mc/mc-allocator.c b/drivers/bus/fsl-mc/mc-allocator.c
new file mode 100644
index 0000000..3d48f4a
--- /dev/null
+++ b/drivers/bus/fsl-mc/mc-allocator.c
@@ -0,0 +1,568 @@
+/*
+ * Freescale MC object device allocator driver
+ *
+ * Copyright (C) 2013 Freescale Semiconductor, Inc.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/fsl/mc-private.h>
+#include <linux/fsl/mc-sys.h>
+#include <linux/module.h>
+#include <linux/fsl/dpbp-cmd.h>
+#include <linux/fsl/dpcon-cmd.h>
+#include "dpmcp-cmd.h"
+#include "dpmcp.h"
+
+/**
+ * fsl_mc_resource_pool_add_device - add allocatable device to a resource
+ * pool of a given MC bus
+ *
+ * @mc_bus: pointer to the MC bus
+ * @pool_type: MC bus pool type
+ * @mc_dev: Pointer to allocatable MC object device
+ *
+ * It adds an allocatable MC object device to a container's resource pool of
+ * the given resource type
+ */
+static int __must_check fsl_mc_resource_pool_add_device(struct fsl_mc_bus
+								*mc_bus,
+							enum fsl_mc_pool_type
+								pool_type,
+							struct fsl_mc_device
+								*mc_dev)
+{
+	struct fsl_mc_resource_pool *res_pool;
+	struct fsl_mc_resource *resource;
+	struct fsl_mc_device *mc_bus_dev = &mc_bus->mc_dev;
+	int error = -EINVAL;
+	bool mutex_locked = false;
+
+	if (WARN_ON(pool_type < 0 || pool_type >= FSL_MC_NUM_POOL_TYPES))
+		goto out;
+	if (WARN_ON(!FSL_MC_IS_ALLOCATABLE(mc_dev->obj_desc.type)))
+		goto out;
+	if (WARN_ON(mc_dev->resource))
+		goto out;
+
+	res_pool = &mc_bus->resource_pools[pool_type];
+	if (WARN_ON(res_pool->type != pool_type))
+		goto out;
+	if (WARN_ON(res_pool->mc_bus != mc_bus))
+		goto out;
+
+	mutex_lock(&res_pool->mutex);
+	mutex_locked = true;
+
+	if (WARN_ON(res_pool->max_count < 0))
+		goto out;
+	if (WARN_ON(res_pool->free_count < 0 ||
+		    res_pool->free_count > res_pool->max_count))
+		goto out;
+
+	resource = devm_kzalloc(&mc_bus_dev->dev, sizeof(*resource),
+				GFP_KERNEL);
+	if (!resource) {
+		error = -ENOMEM;
+		dev_err(&mc_bus_dev->dev,
+			"Failed to allocate memory for fsl_mc_resource\n");
+		goto out;
+	}
+
+	resource->type = pool_type;
+	resource->id = mc_dev->obj_desc.id;
+	resource->data = mc_dev;
+	resource->parent_pool = res_pool;
+	INIT_LIST_HEAD(&resource->node);
+	list_add_tail(&resource->node, &res_pool->free_list);
+	mc_dev->resource = resource;
+	res_pool->free_count++;
+	res_pool->max_count++;
+	error = 0;
+out:
+	if (mutex_locked)
+		mutex_unlock(&res_pool->mutex);
+
+	return error;
+}
+
+/**
+ * fsl_mc_resource_pool_remove_device - remove an allocatable device from a
+ * resource pool
+ *
+ * @mc_dev: Pointer to allocatable MC object device
+ *
+ * It permanently removes an allocatable MC object device from the resource
+ * pool, the device is currently in, as long as it is in the pool's free list.
+ */
+static int __must_check fsl_mc_resource_pool_remove_device(struct fsl_mc_device
+								   *mc_dev)
+{
+	struct fsl_mc_device *mc_bus_dev;
+	struct fsl_mc_bus *mc_bus;
+	struct fsl_mc_resource_pool *res_pool;
+	struct fsl_mc_resource *resource;
+	int error = -EINVAL;
+	bool mutex_locked = false;
+
+	if (WARN_ON(!FSL_MC_IS_ALLOCATABLE(mc_dev->obj_desc.type)))
+		goto out;
+
+	resource = mc_dev->resource;
+	if (WARN_ON(resource->data != mc_dev))
+		goto out;
+
+	mc_bus_dev = to_fsl_mc_device(mc_dev->dev.parent);
+	mc_bus = to_fsl_mc_bus(mc_bus_dev);
+	res_pool = resource->parent_pool;
+	if (WARN_ON(res_pool != &mc_bus->resource_pools[resource->type]))
+		goto out;
+
+	mutex_lock(&res_pool->mutex);
+	mutex_locked = true;
+
+	if (WARN_ON(res_pool->max_count <= 0))
+		goto out;
+	if (WARN_ON(res_pool->free_count <= 0 ||
+		    res_pool->free_count > res_pool->max_count))
+		goto out;
+
+	/*
+	 * If the device is currently allocated, its resource is not
+	 * in the free list and thus, the device cannot be removed.
+	 */
+	if (list_empty(&resource->node)) {
+		error = -EBUSY;
+		dev_err(&mc_bus_dev->dev,
+			"Device %s cannot be removed from resource pool\n",
+			dev_name(&mc_dev->dev));
+		goto out;
+	}
+
+	list_del(&resource->node);
+	INIT_LIST_HEAD(&resource->node);
+	res_pool->free_count--;
+	res_pool->max_count--;
+
+	devm_kfree(&mc_bus_dev->dev, resource);
+	mc_dev->resource = NULL;
+	error = 0;
+out:
+	if (mutex_locked)
+		mutex_unlock(&res_pool->mutex);
+
+	return error;
+}
+
+static const char *const fsl_mc_pool_type_strings[] = {
+	[FSL_MC_POOL_DPMCP] = "dpmcp",
+	[FSL_MC_POOL_DPBP] = "dpbp",
+	[FSL_MC_POOL_DPCON] = "dpcon",
+};
+
+static int __must_check object_type_to_pool_type(const char *object_type,
+						 enum fsl_mc_pool_type
+								*pool_type)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(fsl_mc_pool_type_strings); i++) {
+		if (strcmp(object_type, fsl_mc_pool_type_strings[i]) == 0) {
+			*pool_type = i;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+int __must_check fsl_mc_resource_allocate(struct fsl_mc_bus *mc_bus,
+					  enum fsl_mc_pool_type pool_type,
+					  struct fsl_mc_resource **new_resource)
+{
+	struct fsl_mc_resource_pool *res_pool;
+	struct fsl_mc_resource *resource;
+	struct fsl_mc_device *mc_bus_dev = &mc_bus->mc_dev;
+	int error = -EINVAL;
+	bool mutex_locked = false;
+
+	BUILD_BUG_ON(ARRAY_SIZE(fsl_mc_pool_type_strings) !=
+		     FSL_MC_NUM_POOL_TYPES);
+
+	*new_resource = NULL;
+	if (WARN_ON(pool_type < 0 || pool_type >= FSL_MC_NUM_POOL_TYPES))
+		goto error;
+
+	res_pool = &mc_bus->resource_pools[pool_type];
+	if (WARN_ON(res_pool->mc_bus != mc_bus))
+		goto error;
+
+	mutex_lock(&res_pool->mutex);
+	mutex_locked = true;
+	resource = list_first_entry_or_null(&res_pool->free_list,
+					    struct fsl_mc_resource, node);
+
+	if (!resource) {
+		WARN_ON(res_pool->free_count != 0);
+		error = -ENXIO;
+		dev_err(&mc_bus_dev->dev,
+			"No more resources of type %s left\n",
+			fsl_mc_pool_type_strings[pool_type]);
+		goto error;
+	}
+
+	if (WARN_ON(resource->type != pool_type))
+		goto error;
+	if (WARN_ON(resource->parent_pool != res_pool))
+		goto error;
+	if (WARN_ON(res_pool->free_count <= 0 ||
+		    res_pool->free_count > res_pool->max_count))
+		goto error;
+
+	list_del(&resource->node);
+	INIT_LIST_HEAD(&resource->node);
+
+	res_pool->free_count--;
+	mutex_unlock(&res_pool->mutex);
+	*new_resource = resource;
+	return 0;
+error:
+	if (mutex_locked)
+		mutex_unlock(&res_pool->mutex);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(fsl_mc_resource_allocate);
+
+void fsl_mc_resource_free(struct fsl_mc_resource *resource)
+{
+	struct fsl_mc_resource_pool *res_pool;
+	bool mutex_locked = false;
+
+	res_pool = resource->parent_pool;
+	if (WARN_ON(resource->type != res_pool->type))
+		goto out;
+
+	mutex_lock(&res_pool->mutex);
+	mutex_locked = true;
+	if (WARN_ON(res_pool->free_count < 0 ||
+		    res_pool->free_count >= res_pool->max_count))
+		goto out;
+
+	if (WARN_ON(!list_empty(&resource->node)))
+		goto out;
+
+	list_add_tail(&resource->node, &res_pool->free_list);
+	res_pool->free_count++;
+out:
+	if (mutex_locked)
+		mutex_unlock(&res_pool->mutex);
+}
+EXPORT_SYMBOL_GPL(fsl_mc_resource_free);
+
+/**
+ * fsl_mc_portal_allocate - Allocates an MC portal
+ *
+ * @mc_dev: MC device for which the MC portal is to be allocated
+ * @mc_io_flags: Flags for the fsl_mc_io object that wraps the allocated
+ * MC portal.
+ * @new_mc_io: Pointer to area where the pointer to the fsl_mc_io object
+ * that wraps the allocated MC portal is to be returned
+ *
+ * This function allocates an MC portal from the device's parent DPRC,
+ * from the corresponding MC bus' pool of MC portals and wraps
+ * it in a new fsl_mc_io object. If 'mc_dev' is a DPRC itself, the
+ * portal is allocated from its own MC bus.
+ */
+int __must_check fsl_mc_portal_allocate(struct fsl_mc_device *mc_dev,
+					uint16_t mc_io_flags,
+					struct fsl_mc_io **new_mc_io)
+{
+	struct fsl_mc_device *mc_bus_dev;
+	struct fsl_mc_bus *mc_bus;
+	phys_addr_t mc_portal_phys_addr;
+	size_t mc_portal_size;
+	struct fsl_mc_device *mc_adev;
+	int error = -EINVAL;
+	struct fsl_mc_resource *resource = NULL;
+	struct fsl_mc_io *mc_io = NULL;
+
+	if (mc_dev->flags & FSL_MC_IS_DPRC) {
+		mc_bus_dev = mc_dev;
+	} else {
+		if (WARN_ON(mc_dev->dev.parent->bus != &fsl_mc_bus_type))
+			return error;
+
+		mc_bus_dev = to_fsl_mc_device(mc_dev->dev.parent);
+	}
+
+	mc_bus = to_fsl_mc_bus(mc_bus_dev);
+	*new_mc_io = NULL;
+	error = fsl_mc_resource_allocate(mc_bus, FSL_MC_POOL_DPMCP, &resource);
+	if (error < 0)
+		return error;
+
+	mc_adev = resource->data;
+	if (WARN_ON(!mc_adev))
+		goto error_cleanup_resource;
+
+	if (WARN_ON(mc_adev->obj_desc.region_count == 0))
+		goto error;
+
+	mc_portal_phys_addr = mc_adev->regions[0].start;
+	mc_portal_size = mc_adev->regions[0].end -
+			 mc_adev->regions[0].start + 1;
+
+	if (WARN_ON(mc_portal_size != mc_bus_dev->mc_io->portal_size))
+		goto error_cleanup_resource;
+
+	error = fsl_create_mc_io(&mc_bus_dev->dev,
+				 mc_portal_phys_addr,
+				 mc_portal_size, resource,
+				 mc_io_flags, &mc_io);
+	if (error < 0)
+		goto error_cleanup_resource;
+
+	*new_mc_io = mc_io;
+	return 0;
+
+error_cleanup_resource:
+	fsl_mc_resource_free(resource);
+	return error;
+}
+EXPORT_SYMBOL_GPL(fsl_mc_portal_allocate);
+
+/**
+ * fsl_mc_portal_free - Returns an MC portal to the pool of free MC portals
+ * of a given MC bus
+ *
+ * @mc_io: Pointer to the fsl_mc_io object that wraps the MC portal to free
+ */
+void fsl_mc_portal_free(struct fsl_mc_io *mc_io)
+{
+	struct fsl_mc_resource *resource;
+
+	resource = mc_io->resource;
+	if (WARN_ON(resource->type != FSL_MC_POOL_DPMCP))
+		return;
+	if (WARN_ON(!resource->data))
+		return;
+
+	fsl_destroy_mc_io(mc_io);
+	fsl_mc_resource_free(resource);
+}
+EXPORT_SYMBOL_GPL(fsl_mc_portal_free);
+
+/**
+ * fsl_mc_portal_reset - Resets the dpmcp object for a given fsl_mc_io object
+ *
+ * @mc_io: Pointer to the fsl_mc_io object that wraps the MC portal to free
+ */
+int fsl_mc_portal_reset(struct fsl_mc_io *mc_io)
+{
+	int error;
+	uint16_t token;
+	struct fsl_mc_resource *resource = mc_io->resource;
+	struct fsl_mc_device *mc_dev = resource->data;
+
+	if (WARN_ON(resource->type != FSL_MC_POOL_DPMCP))
+		return -EINVAL;
+
+	if (WARN_ON(!mc_dev))
+		return -EINVAL;
+
+	error = dpmcp_open(mc_io, mc_dev->obj_desc.id, &token);
+	if (error < 0) {
+		dev_err(&mc_dev->dev, "dpmcp_open() failed: %d\n", error);
+		return error;
+	}
+
+	error = dpmcp_reset(mc_io, token);
+	if (error < 0) {
+		dev_err(&mc_dev->dev, "dpmcp_reset() failed: %d\n", error);
+		return error;
+	}
+
+	error = dpmcp_close(mc_io, token);
+	if (error < 0) {
+		dev_err(&mc_dev->dev, "dpmcp_close() failed: %d\n", error);
+		return error;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fsl_mc_portal_reset);
+
+/**
+ * fsl_mc_object_allocate - Allocates a MC object device of the given
+ * pool type from a given MC bus
+ *
+ * @mc_dev: MC device for which the MC object device is to be allocated
+ * @pool_type: MC bus resource pool type
+ * @new_mc_dev: Pointer to area where the pointer to the allocated
+ * MC object device is to be returned
+ *
+ * This function allocates a MC object device from the device's parent DPRC,
+ * from the corresponding MC bus' pool of allocatable MC object devices of
+ * the given resource type. mc_dev cannot be a DPRC itself.
+ *
+ * NOTE: pool_type must be different from FSL_MC_POOL_MCP, since MC
+ * portals are allocated using fsl_mc_portal_allocate(), instead of
+ * this function.
+ */
+int __must_check fsl_mc_object_allocate(struct fsl_mc_device *mc_dev,
+					enum fsl_mc_pool_type pool_type,
+					struct fsl_mc_device **new_mc_adev)
+{
+	struct fsl_mc_device *mc_bus_dev;
+	struct fsl_mc_bus *mc_bus;
+	struct fsl_mc_device *mc_adev;
+	int error = -EINVAL;
+	struct fsl_mc_resource *resource = NULL;
+
+	*new_mc_adev = NULL;
+	if (WARN_ON(mc_dev->flags & FSL_MC_IS_DPRC))
+		goto error;
+
+	if (WARN_ON(mc_dev->dev.parent->bus != &fsl_mc_bus_type))
+		goto error;
+
+	if (WARN_ON(pool_type == FSL_MC_POOL_DPMCP))
+		goto error;
+
+	mc_bus_dev = to_fsl_mc_device(mc_dev->dev.parent);
+	mc_bus = to_fsl_mc_bus(mc_bus_dev);
+	error = fsl_mc_resource_allocate(mc_bus, pool_type, &resource);
+	if (error < 0)
+		goto error;
+
+	mc_adev = resource->data;
+	if (WARN_ON(!mc_adev))
+		goto error;
+
+	*new_mc_adev = mc_adev;
+	return 0;
+error:
+	if (resource)
+		fsl_mc_resource_free(resource);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(fsl_mc_object_allocate);
+
+/**
+ * fsl_mc_object_free - Returns an allocatable MC object device to the
+ * corresponding resource pool of a given MC bus.
+ *
+ * @mc_adev: Pointer to the MC object device
+ */
+void fsl_mc_object_free(struct fsl_mc_device *mc_adev)
+{
+	struct fsl_mc_resource *resource;
+
+	resource = mc_adev->resource;
+	if (WARN_ON(resource->type == FSL_MC_POOL_DPMCP))
+		return;
+	if (WARN_ON(resource->data != mc_adev))
+		return;
+
+	fsl_mc_resource_free(resource);
+}
+EXPORT_SYMBOL_GPL(fsl_mc_object_free);
+
+/**
+ * fsl_mc_allocator_probe - callback invoked when an allocatable device is
+ * being added to the system
+ */
+static int fsl_mc_allocator_probe(struct fsl_mc_device *mc_dev)
+{
+	enum fsl_mc_pool_type pool_type;
+	struct fsl_mc_device *mc_bus_dev;
+	struct fsl_mc_bus *mc_bus;
+	int error = -EINVAL;
+
+	if (WARN_ON(!FSL_MC_IS_ALLOCATABLE(mc_dev->obj_desc.type)))
+		goto error;
+
+	mc_bus_dev = to_fsl_mc_device(mc_dev->dev.parent);
+	if (WARN_ON(mc_bus_dev->dev.bus != &fsl_mc_bus_type))
+		goto error;
+
+	mc_bus = to_fsl_mc_bus(mc_bus_dev);
+	error = object_type_to_pool_type(mc_dev->obj_desc.type, &pool_type);
+	if (error < 0)
+		goto error;
+
+	error = fsl_mc_resource_pool_add_device(mc_bus, pool_type, mc_dev);
+	if (error < 0)
+		goto error;
+
+	dev_info(&mc_dev->dev,
+		 "Allocatable MC object device bound to fsl_mc_allocator driver");
+	return 0;
+error:
+
+	return error;
+}
+
+/**
+ * fsl_mc_allocator_remove - callback invoked when an allocatable device is
+ * being removed from the system
+ */
+static int fsl_mc_allocator_remove(struct fsl_mc_device *mc_dev)
+{
+	int error = -EINVAL;
+
+	if (WARN_ON(!FSL_MC_IS_ALLOCATABLE(mc_dev->obj_desc.type)))
+		goto out;
+
+	error = fsl_mc_resource_pool_remove_device(mc_dev);
+	if (error < 0)
+		goto out;
+
+	dev_info(&mc_dev->dev, "Allocatable MC object device bound to driver");
+	error = 0;
+out:
+	return error;
+}
+
+static const struct fsl_mc_device_match_id match_id_table[] = {
+	{
+	 .vendor = FSL_MC_VENDOR_FREESCALE,
+	 .obj_type = "dpbp",
+	 .ver_major = DPBP_VER_MAJOR,
+	 .ver_minor = DPBP_VER_MINOR
+	},
+	{
+	 .vendor = FSL_MC_VENDOR_FREESCALE,
+	 .obj_type = "dpmcp",
+	 .ver_major = DPMCP_VER_MAJOR,
+	 .ver_minor = DPMCP_VER_MINOR
+	},
+	{
+	 .vendor = FSL_MC_VENDOR_FREESCALE,
+	 .obj_type = "dpcon",
+	 .ver_major = DPCON_VER_MAJOR,
+	 .ver_minor = DPCON_VER_MINOR
+	},
+	{.vendor = 0x0},
+};
+
+static struct fsl_mc_driver fsl_mc_allocator_driver = {
+	.driver = {
+		   .name = "fsl_mc_allocator",
+		   .owner = THIS_MODULE,
+		   .pm = NULL,
+		   },
+	.match_id_table = match_id_table,
+	.probe = fsl_mc_allocator_probe,
+	.remove = fsl_mc_allocator_remove,
+};
+
+module_fsl_mc_driver(fsl_mc_allocator_driver);
+
+MODULE_AUTHOR("Freescale Semiconductor Inc.");
+MODULE_DESCRIPTION("Freescale's MC object device allocator");
+MODULE_LICENSE("GPL");
diff --git a/drivers/bus/fsl-mc/mc-bus.c b/drivers/bus/fsl-mc/mc-bus.c
index 1967807..d91ef4a 100644
--- a/drivers/bus/fsl-mc/mc-bus.c
+++ b/drivers/bus/fsl-mc/mc-bus.c
@@ -269,6 +269,7 @@ int fsl_mc_device_add(struct dprc_obj_desc *obj_desc,
 {
 	int error;
 	struct fsl_mc_device *mc_dev = NULL;
+	struct fsl_mc_bus *mc_bus = NULL;
 	struct fsl_mc_device *parent_mc_dev;

 	if (parent_dev->bus == &fsl_mc_bus_type)
@@ -276,17 +277,28 @@ int fsl_mc_device_add(struct dprc_obj_desc *obj_desc,
 	else
 		parent_mc_dev = NULL;

-	/*
-	 * DPRC devices must have a dedicated MC portal
-	 */
-	if (WARN_ON(strcmp(obj_desc->type, "dprc") == 0 && !mc_io))
-		return -EINVAL;
+	if (strcmp(obj_desc->type, "dprc") == 0) {
+		/*
+		 * DPRC devices must have a dedicated MC portal
+		 */
+		if (WARN_ON(!mc_io))
+			return -EINVAL;

-	mc_dev = kmem_cache_zalloc(mc_dev_cache, GFP_KERNEL);
-	if (!mc_dev) {
-		dev_err(parent_dev,
-			"No memory to allocate fsl_mc_device\n");
-		return -ENOMEM;
+		/*
+		 * Allocate an MC bus device object:
+		 */
+		mc_bus = devm_kzalloc(parent_dev, sizeof(*mc_bus), GFP_KERNEL);
+		if (!mc_bus)
+			return -ENOMEM;
+
+		mc_dev = &mc_bus->mc_dev;
+	} else {
+		/*
+		 * Allocate a regular fsl_mc_device object:
+		 */
+		mc_dev = kmem_cache_zalloc(mc_dev_cache, GFP_KERNEL);
+		if (!mc_dev)
+			return -ENOMEM;
 	}

 	mc_dev->obj_desc = *obj_desc;
@@ -365,7 +377,11 @@ int fsl_mc_device_add(struct dprc_obj_desc *obj_desc,

 error_cleanup_dev:
 	kfree(mc_dev->regions);
-	kmem_cache_free(mc_dev_cache, mc_dev);
+	if (mc_bus)
+		devm_kfree(parent_dev, mc_bus);
+	else
+		kmem_cache_free(mc_dev_cache, mc_dev);
+
 	return error;
 }
 EXPORT_SYMBOL_GPL(fsl_mc_device_add);
@@ -378,6 +394,8 @@ EXPORT_SYMBOL_GPL(fsl_mc_device_add);
  */
 void fsl_mc_device_remove(struct fsl_mc_device *mc_dev)
 {
+	struct fsl_mc_bus *mc_bus = NULL;
+
 	kfree(mc_dev->regions);

 	/*
@@ -387,13 +405,23 @@ void fsl_mc_device_remove(struct fsl_mc_device *mc_dev)
 	put_device(&mc_dev->dev);

 	if (strcmp(mc_dev->obj_desc.type, "dprc") == 0) {
-		fsl_destroy_mc_io(mc_dev->mc_io);
+		struct fsl_mc_io *mc_io = mc_dev->mc_io;
+
+		mc_bus = to_fsl_mc_bus(mc_dev);
+		if (!mc_io->resource)
+			fsl_destroy_mc_io(mc_io);
+		else
+			fsl_mc_portal_free(mc_io);
+
 		if (&mc_dev->dev == fsl_mc_bus_type.dev_root)
 			fsl_mc_bus_type.dev_root = NULL;
 	}

 	mc_dev->mc_io = NULL;
-	kmem_cache_free(mc_dev_cache, mc_dev);
+	if (mc_bus)
+		devm_kfree(mc_dev->dev.parent, mc_bus);
+	else
+		kmem_cache_free(mc_dev_cache, mc_dev);
 }
 EXPORT_SYMBOL_GPL(fsl_mc_device_remove);

@@ -440,7 +468,7 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
 	mc_portal_phys_addr = res.start;
 	mc_portal_size = resource_size(&res);
 	error = fsl_create_mc_io(&pdev->dev, mc_portal_phys_addr,
-				 mc_portal_size, 0, &mc_io);
+				 mc_portal_size, NULL, 0, &mc_io);
 	if (error < 0)
 		return error;

diff --git a/drivers/bus/fsl-mc/mc-sys.c b/drivers/bus/fsl-mc/mc-sys.c
index 4476287..c5e91db 100644
--- a/drivers/bus/fsl-mc/mc-sys.c
+++ b/drivers/bus/fsl-mc/mc-sys.c
@@ -68,6 +68,7 @@
 int __must_check fsl_create_mc_io(struct device *dev,
 				  phys_addr_t mc_portal_phys_addr,
 				  uint32_t mc_portal_size,
+				  struct fsl_mc_resource *resource,
 				  uint32_t flags, struct fsl_mc_io **new_mc_io)
 {
 	struct fsl_mc_io *mc_io;
@@ -82,6 +83,7 @@ int __must_check fsl_create_mc_io(struct device *dev,
 	mc_io->flags = flags;
 	mc_io->portal_phys_addr = mc_portal_phys_addr;
 	mc_io->portal_size = mc_portal_size;
+	mc_io->resource = resource;
 	res = devm_request_mem_region(dev,
 				      mc_portal_phys_addr,
 				      mc_portal_size,
diff --git a/include/linux/fsl/dpbp-cmd.h b/include/linux/fsl/dpbp-cmd.h
new file mode 100644
index 0000000..1fd70a21
--- /dev/null
+++ b/include/linux/fsl/dpbp-cmd.h
@@ -0,0 +1,60 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+*
+* Redistribution and use in source and binary forms, with or without
+* modification, are permitted provided that the following conditions are met:
+* * Redistributions of source code must retain the above copyright
+* notice, this list of conditions and the following disclaimer.
+* * Redistributions in binary form must reproduce the above copyright
+* notice, this list of conditions and the following disclaimer in the
+* documentation and/or other materials provided with the distribution.
+* * Neither the name of the above-listed copyright holders nor the
+* names of any contributors may be used to endorse or promote products
+* derived from this software without specific prior written permission.
+*
+*
+* ALTERNATIVELY, this software may be distributed under the terms of the
+* GNU General Public License ("GPL") as published by the Free Software
+* Foundation, either version 2 of that License or (at your option) any
+* later version.
+*
+* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+* POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef _FSL_DPBP_CMD_H
+#define _FSL_DPBP_CMD_H
+
+/* DPBP Version */
+#define DPBP_VER_MAJOR				2
+#define DPBP_VER_MINOR				0
+
+/* Command IDs */
+#define DPBP_CMDID_CLOSE				0x800
+#define DPBP_CMDID_OPEN					0x804
+#define DPBP_CMDID_CREATE				0x904
+#define DPBP_CMDID_DESTROY				0x900
+
+#define DPBP_CMDID_ENABLE				0x002
+#define DPBP_CMDID_DISABLE				0x003
+#define DPBP_CMDID_GET_ATTR				0x004
+#define DPBP_CMDID_RESET				0x005
+#define DPBP_CMDID_IS_ENABLED				0x006
+
+#define DPBP_CMDID_SET_IRQ				0x010
+#define DPBP_CMDID_GET_IRQ				0x011
+#define DPBP_CMDID_SET_IRQ_ENABLE			0x012
+#define DPBP_CMDID_GET_IRQ_ENABLE			0x013
+#define DPBP_CMDID_SET_IRQ_MASK				0x014
+#define DPBP_CMDID_GET_IRQ_MASK				0x015
+#define DPBP_CMDID_GET_IRQ_STATUS			0x016
+#define DPBP_CMDID_CLEAR_IRQ_STATUS			0x017
+
+#endif /* _FSL_DPBP_CMD_H */
diff --git a/include/linux/fsl/dpbp.h b/include/linux/fsl/dpbp.h
new file mode 100644
index 0000000..f9c56a6
--- /dev/null
+++ b/include/linux/fsl/dpbp.h
@@ -0,0 +1,346 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+*
+* Redistribution and use in source and binary forms, with or without
+* modification, are permitted provided that the following conditions are met:
+* * Redistributions of source code must retain the above copyright
+* notice, this list of conditions and the following disclaimer.
+* * Redistributions in binary form must reproduce the above copyright
+* notice, this list of conditions and the following disclaimer in the
+* documentation and/or other materials provided with the distribution.
+* * Neither the name of the above-listed copyright holders nor the
+* names of any contributors may be used to endorse or promote products
+* derived from this software without specific prior written permission.
+*
+*
+* ALTERNATIVELY, this software may be distributed under the terms of the
+* GNU General Public License ("GPL") as published by the Free Software
+* Foundation, either version 2 of that License or (at your option) any
+* later version.
+*
+* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+* POSSIBILITY OF SUCH DAMAGE.
+*/
+/*
+ *  dpbp.h
+ *  Data Path Buffer Pool API
+ */
+#ifndef __FSL_DPBP_H
+#define __FSL_DPBP_H
+
+/*
+ * grp_dpbp	Data Path Buffer Pool API
+ *
+ * Contains initialization APIs and runtime control APIs for DPBP
+ *
+ */
+
+struct fsl_mc_io;
+
+/*
+ * Open a control session for the specified object
+ *
+ *		This function can be used to open a control session for an
+ *		already created object; an object may have been declared in
+ *		the DPL or by calling the dpbp_create() function.
+ *		This function returns a unique authentication token,
+ *		associated with the specific object ID and the specific MC
+ *		portal; this token must be used in all subsequent commands for
+ *		this specific object.
+ *
+ * mc_io		Pointer to MC portal's I/O object
+ * dpbp_id		DPBP unique ID
+ * token		Returned token; use in subsequent API calls
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_open(struct fsl_mc_io *mc_io, int dpbp_id, uint16_t *token);
+
+/*
+ * Close the control session of the object
+ *
+ *		After this function is called, no further operations are
+ *		allowed on the object without opening a new control session.
+ *
+ * mc_io		Pointer to MC portal's I/O object
+ * token		Token of DPBP object
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_close(struct fsl_mc_io *mc_io, uint16_t token);
+
+/*
+ * Structure representing DPBP configuration
+ */
+struct dpbp_cfg {
+	uint32_t options; /* place holder */
+};
+
+/*
+ * Create the DPBP object, allocate required resources and
+ *		perform required initialization.
+ *
+ *		The object can be created either by declaring it in the
+ *		DPL file, or by calling this function.
+ *
+ *		This function returns a unique authentication token,
+ *		associated with the specific object ID and the specific MC
+ *		portal; this token must be used in all subsequent calls to
+ *		this specific object. For objects that are created using the
+ *		DPL file, call dpbp_open() function to get an authentication
+ *		token first.
+ *
+ * mc_io	Pointer to MC portal's I/O object
+ * cfg	Configuration structure
+ * token	Returned token; use in subsequent API calls
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_create(struct fsl_mc_io	*mc_io,
+		const struct dpbp_cfg	*cfg,
+		uint16_t		*token);
+
+/*
+ * Destroy the DPBP object and release all its resources.
+ *
+ * mc_io	Pointer to MC portal's I/O object
+ * token	Token of DPBP object
+ *
+ * returns	'0' on Success; error code otherwise.
+ */
+int dpbp_destroy(struct fsl_mc_io *mc_io, uint16_t token);
+
+/*
+ * Enable the DPBP.
+ *
+ * mc_io	Pointer to MC portal's I/O object
+ * token	Token of DPBP object
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_enable(struct fsl_mc_io *mc_io, uint16_t token);
+
+/*
+ * Disable the DPBP.
+ *
+ * mc_io	Pointer to MC portal's I/O object
+ * token	Token of DPBP object
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_disable(struct fsl_mc_io *mc_io, uint16_t token);
+
+/*
+ * Check if the DPBP is enabled.
+ *
+ * mc_io	Pointer to MC portal's I/O object
+ * token	Token of DPBP object
+ * en	Returns '1' if object is enabled; '0' otherwise
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_is_enabled(struct fsl_mc_io *mc_io, uint16_t token, int *en);
+
+/*
+ * Reset the DPBP, returns the object to initial state.
+ *
+ * mc_io	Pointer to MC portal's I/O object
+ * token	Token of DPBP object
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_reset(struct fsl_mc_io *mc_io, uint16_t token);
+
+/*
+ * Set IRQ information for the DPBP to trigger an interrupt.
+ *
+ * mc_io		Pointer to MC portal's I/O object
+ * token		Token of DPBP object
+ * irq_index	Identifies the interrupt index to configure
+ * irq_addr	Address that must be written to
+ *				signal a message-based interrupt
+ * irq_val		Value to write into irq_addr address
+ * user_irq_id	A user defined number associated with this IRQ
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_set_irq(struct fsl_mc_io	*mc_io,
+		 uint16_t		token,
+		 uint8_t		irq_index,
+		 uint64_t		irq_addr,
+		 uint32_t		irq_val,
+		 int			user_irq_id);
+
+/*
+ * Get IRQ information from the DPBP.
+ *
+ * mc_io		Pointer to MC portal's I/O object
+ * token		Token of DPBP object
+ * irq_index	The interrupt index to configure
+ * type		Interrupt type: 0 represents message interrupt
+ *				type (both irq_addr and irq_val are valid)
+ * irq_addr	Address that must be written to
+ *				signal the message-based interrupt
+ * irq_val		Value to write into irq_addr address
+ * user_irq_id	A user defined number associated with this IRQ
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_get_irq(struct fsl_mc_io	*mc_io,
+		 uint16_t		token,
+		 uint8_t		irq_index,
+		 int			*type,
+		 uint64_t		*irq_addr,
+		 uint32_t		*irq_val,
+		 int			*user_irq_id);
+
+/*
+ * Set overall interrupt state.
+ *
+ * Allows GPP software to control when interrupts are generated.
+ * Each interrupt can have up to 32 causes.  The enable/disable control's the
+ * overall interrupt state. if the interrupt is disabled no causes will cause
+ * an interrupt.
+ *
+ * mc_io		Pointer to MC portal's I/O object
+ * token		Token of DPBP object
+ * irq_index	The interrupt index to configure
+ * en		Interrupt state - enable = 1, disable = 0
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_set_irq_enable(struct fsl_mc_io	*mc_io,
+			uint16_t		token,
+			uint8_t			irq_index,
+			uint8_t			en);
+
+/*
+ * Get overall interrupt state
+ *
+ * mc_io		Pointer to MC portal's I/O object
+ * token		Token of DPBP object
+ * irq_index	The interrupt index to configure
+ * en		Interrupt state - enable = 1, disable = 0
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_get_irq_enable(struct fsl_mc_io	*mc_io,
+			uint16_t		token,
+			uint8_t			irq_index,
+			uint8_t			*en);
+
+/*
+ * Set interrupt mask.
+ *
+ * Every interrupt can have up to 32 causes and the interrupt model supports
+ * masking/unmasking each cause independently
+ *
+ * mc_io		Pointer to MC portal's I/O object
+ * token		Token of DPBP object
+ * irq_index	The interrupt index to configure
+ * mask		Event mask to trigger interrupt;
+ *				each bit:
+ *					0 = ignore event
+ *					1 = consider event for asserting IRQ
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_set_irq_mask(struct fsl_mc_io	*mc_io,
+		      uint16_t		token,
+		      uint8_t		irq_index,
+		      uint32_t		mask);
+
+/*
+ * Get interrupt mask.
+ *
+ * Every interrupt can have up to 32 causes and the interrupt model supports
+ * masking/unmasking each cause independently
+ *
+ * mc_io		Pointer to MC portal's I/O object
+ * token		Token of DPBP object
+ * irq_index	The interrupt index to configure
+ * mask		Event mask to trigger interrupt
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_get_irq_mask(struct fsl_mc_io	*mc_io,
+		      uint16_t		token,
+		      uint8_t		irq_index,
+		      uint32_t		*mask);
+
+/*
+ * Get the current status of any pending interrupts.
+ *
+ * mc_io		Pointer to MC portal's I/O object
+ * token		Token of DPBP object
+ * irq_index	The interrupt index to configure
+ * status		Interrupts status - one bit per cause:
+ *					0 = no interrupt pending
+ *					1 = interrupt pending
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_get_irq_status(struct fsl_mc_io	*mc_io,
+			uint16_t		token,
+			uint8_t			irq_index,
+			uint32_t		*status);
+
+/*
+ * Clear a pending interrupt's status
+ *
+ * mc_io		Pointer to MC portal's I/O object
+ * token		Token of DPBP object
+ * irq_index	The interrupt index to configure
+ * status		Bits to clear (W1C) - one bit per cause:
+ *					0 = don't change
+ *					1 = clear status bit
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_clear_irq_status(struct fsl_mc_io	*mc_io,
+			  uint16_t		token,
+			  uint8_t		irq_index,
+			  uint32_t		status);
+
+/*
+ * Structure representing DPBP attributes
+ */
+struct dpbp_attr {
+	/* DPBP object id */
+	int id;
+	/* DPBP version */
+	struct {
+		/* DPBP major version */
+		uint16_t major;
+		/* DPBP minor version */
+		uint16_t minor;
+	} version;
+	/*
+	 * Hardware buffer pool ID; should be used as an argument in
+	 * acquire/release operations on buffers
+	 */
+	uint16_t bpid;
+};
+
+/*
+ * Retrieve DPBP attributes.
+ *
+ * mc_io	Pointer to MC portal's I/O object
+ * token	Token of DPBP object
+ * attr	Object's attributes
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpbp_get_attributes(struct fsl_mc_io	*mc_io,
+			uint16_t		token,
+			struct dpbp_attr	*attr);
+
+#endif /* __FSL_DPBP_H */
diff --git a/include/linux/fsl/dpcon-cmd.h b/include/linux/fsl/dpcon-cmd.h
new file mode 100644
index 0000000..48e7a09
--- /dev/null
+++ b/include/linux/fsl/dpcon-cmd.h
@@ -0,0 +1,62 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+*
+* Redistribution and use in source and binary forms, with or without
+* modification, are permitted provided that the following conditions are met:
+* * Redistributions of source code must retain the above copyright
+* notice, this list of conditions and the following disclaimer.
+* * Redistributions in binary form must reproduce the above copyright
+* notice, this list of conditions and the following disclaimer in the
+* documentation and/or other materials provided with the distribution.
+* * Neither the name of the above-listed copyright holders nor the
+* names of any contributors may be used to endorse or promote products
+* derived from this software without specific prior written permission.
+*
+*
+* ALTERNATIVELY, this software may be distributed under the terms of the
+* GNU General Public License ("GPL") as published by the Free Software
+* Foundation, either version 2 of that License or (at your option) any
+* later version.
+*
+* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+* POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef _FSL_DPCON_CMD_H
+#define _FSL_DPCON_CMD_H
+
+/* DPCON Version */
+#define DPCON_VER_MAJOR				2
+#define DPCON_VER_MINOR				0
+
+/* Command IDs */
+#define DPCON_CMDID_CLOSE				0x800
+#define DPCON_CMDID_OPEN				0x808
+#define DPCON_CMDID_CREATE				0x908
+#define DPCON_CMDID_DESTROY				0x900
+
+#define DPCON_CMDID_ENABLE				0x002
+#define DPCON_CMDID_DISABLE				0x003
+#define DPCON_CMDID_GET_ATTR				0x004
+#define DPCON_CMDID_RESET				0x005
+#define DPCON_CMDID_IS_ENABLED				0x006
+
+#define DPCON_CMDID_SET_IRQ				0x010
+#define DPCON_CMDID_GET_IRQ				0x011
+#define DPCON_CMDID_SET_IRQ_ENABLE			0x012
+#define DPCON_CMDID_GET_IRQ_ENABLE			0x013
+#define DPCON_CMDID_SET_IRQ_MASK			0x014
+#define DPCON_CMDID_GET_IRQ_MASK			0x015
+#define DPCON_CMDID_GET_IRQ_STATUS			0x016
+#define DPCON_CMDID_CLEAR_IRQ_STATUS			0x017
+
+#define DPCON_CMDID_SET_NOTIFICATION			0x100
+
+#endif /* _FSL_DPCON_CMD_H */
diff --git a/include/linux/fsl/mc-private.h b/include/linux/fsl/mc-private.h
index 431a0b1..4d4996d 100644
--- a/include/linux/fsl/mc-private.h
+++ b/include/linux/fsl/mc-private.h
@@ -25,6 +25,40 @@
 	(strcmp(_obj_type, "dpbp") == 0 || \
 	 strcmp(_obj_type, "dpcon") == 0)

+/**
+ * struct fsl_mc_resource_pool - Pool of MC resources of a given
+ * type
+ * @type: type of resources in the pool
+ * @max_count: maximum number of resources in the pool
+ * @free_count: number of free resources in the pool
+ * @mutex: mutex to serialize access to the pool's free list
+ * @free_list: anchor node of list of free resources in the pool
+ * @mc_bus: pointer to the MC bus that owns this resource pool
+ */
+struct fsl_mc_resource_pool {
+	enum fsl_mc_pool_type type;
+	int16_t max_count;
+	int16_t free_count;
+	struct mutex mutex;	/* serializes access to free_list */
+	struct list_head free_list;
+	struct fsl_mc_bus *mc_bus;
+};
+
+/**
+ * struct fsl_mc_bus - logical bus that correspods to a physical DPRC
+ * @mc_dev: fsl-mc device for the bus device itself.
+ * @resource_pools: array of resource pools (one pool per resource type)
+ * for this MC bus. These resources represent allocatable entities
+ * from the physical DPRC.
+ */
+struct fsl_mc_bus {
+	struct fsl_mc_device mc_dev;
+	struct fsl_mc_resource_pool resource_pools[FSL_MC_NUM_POOL_TYPES];
+};
+
+#define to_fsl_mc_bus(_mc_dev) \
+	container_of(_mc_dev, struct fsl_mc_bus, mc_dev)
+
 int __must_check fsl_mc_device_add(struct dprc_obj_desc *obj_desc,
 				   struct fsl_mc_io *mc_io,
 				   struct device *parent_dev,
@@ -40,4 +74,11 @@ int __init dprc_driver_init(void);

 void __exit dprc_driver_exit(void);

+int __must_check fsl_mc_resource_allocate(struct fsl_mc_bus *mc_bus,
+					  enum fsl_mc_pool_type pool_type,
+					  struct fsl_mc_resource
+							  **new_resource);
+
+void fsl_mc_resource_free(struct fsl_mc_resource *resource);
+
 #endif /* _FSL_MC_PRIVATE_H_ */
diff --git a/include/linux/fsl/mc-sys.h b/include/linux/fsl/mc-sys.h
index abfd6a2..cb3b5a2 100644
--- a/include/linux/fsl/mc-sys.h
+++ b/include/linux/fsl/mc-sys.h
@@ -40,6 +40,7 @@
 #include <linux/io.h>
 #include <linux/dma-mapping.h>

+struct fsl_mc_resource;
 struct mc_command;

 /**
@@ -49,6 +50,9 @@ struct mc_command;
  * @portal_size: MC command portal size in bytes
  * @portal_phys_addr: MC command portal physical address
  * @portal_virt_addr: MC command portal virtual address
+ * @resource: generic resource associated with the MC portal if
+ * the MC portal came from a resource pool, or NULL if the MC portal
+ * is permanently bound to a device (e.g., a DPRC)
  */
 struct fsl_mc_io {
 	struct device *dev;
@@ -56,11 +60,13 @@ struct fsl_mc_io {
 	uint32_t portal_size;
 	phys_addr_t portal_phys_addr;
 	void __iomem *portal_virt_addr;
+	struct fsl_mc_resource *resource;
 };

 int __must_check fsl_create_mc_io(struct device *dev,
 				  phys_addr_t mc_portal_phys_addr,
 				  uint32_t mc_portal_size,
+				  struct fsl_mc_resource *resource,
 				  uint32_t flags, struct fsl_mc_io **new_mc_io);

 void fsl_destroy_mc_io(struct fsl_mc_io *mc_io);
diff --git a/include/linux/fsl/mc.h b/include/linux/fsl/mc.h
index 5d89d1bf..8bb0310 100644
--- a/include/linux/fsl/mc.h
+++ b/include/linux/fsl/mc.h
@@ -67,6 +67,44 @@ struct fsl_mc_device_match_id {
 };

 /**
+ * enum fsl_mc_pool_type - Types of allocatable MC bus resources
+ *
+ * Entries in these enum are used as indices in the array of resource
+ * pools of an fsl_mc_dprc object.
+ */
+enum fsl_mc_pool_type {
+	FSL_MC_POOL_MCP = 0x0,	/* corresponds to "mcpid" in the MC */
+	FSL_MC_POOL_DPBP,	/* corresponds to "dpbp" in the MC */
+	FSL_MC_POOL_DPCON,	/* corresponds to "dpcon" in the MC */
+
+	/*
+	 * NOTE: New resource pool types must be added before this entry
+	 */
+	FSL_MC_NUM_POOL_TYPES
+};
+
+/**
+ * struct fsl_mc_resource - MC generic resource
+ * @type: type of resource
+ * @id: unique MC resource Id within the resources of the same type
+ * @data: pointer to resource-specific data if the resource is currently
+ * allocated, or NULL if the resource is not currently allocated.
+ * @parent_pool: pointer to the parent resource pool from which this
+ * resource is allocated from.
+ * @node: Node in the free list of the corresponding resource pool
+ *
+ * NOTE: This structure is to be embedded as a field of specific
+ * MC resource structures.
+ */
+struct fsl_mc_resource {
+	enum fsl_mc_pool_type type;
+	int32_t id;
+	void *data;
+	struct fsl_mc_resource_pool *parent_pool;
+	struct list_head node;
+};
+
+/**
  * Bit masks for a MC object device (struct fsl_mc_device) flags
  */
 #define FSL_MC_IS_DPRC	0x0001
@@ -87,6 +125,7 @@ struct fsl_mc_device_match_id {
  * NULL if none.
  * @obj_desc: MC description of the DPAA device
  * @regions: pointer to array of MMIO region entries
+ * @resource: generic resource associated with this MC object device, if any.
  *
  * Generic device object for MC object devices that are "attached" to a
  * MC bus.
@@ -96,6 +135,17 @@ struct fsl_mc_device_match_id {
  * - The SMMU notifier callback gets invoked after device_add() has been
  *   called for an MC object device, but before the device-specific probe
  *   callback gets called.
+ * - DP_OBJ_DPRC objects are the only MC objects that have built-in MC
+ *   portals. For all other MC objects, their device drivers are responsible for
+ *   allocating MC portals for them by calling fsl_mc_portal_allocate().
+ * - Some types of MC objects (e.g., DP_OBJ_DPBP, DP_OBJ_DPCON) are
+ *   treated as resources that can be allocated/deallocated from the
+ *   corresponding resource pool in the object's parent DPRC, using the
+ *   fsl_mc_object_allocate()/fsl_mc_object_free() functions. These MC objects
+ *   are known as "allocatable" objects. For them, the corresponding
+ *   fsl_mc_device's 'resource' points to the associated resource object.
+ *   For MC objects that are not allocatable (e.g., DP_OBJ_DPRC, DP_OBJ_DPNI),
+ *   'resource' is NULL.
  */
 struct fsl_mc_device {
 	struct device dev;
@@ -106,6 +156,7 @@ struct fsl_mc_device {
 	struct fsl_mc_io *mc_io;
 	struct dprc_obj_desc obj_desc;
 	struct resource *regions;
+	struct fsl_mc_resource *resource;
 };

 #define to_fsl_mc_device(_dev) \
@@ -132,6 +183,18 @@ int __must_check __fsl_mc_driver_register(struct fsl_mc_driver *fsl_mc_driver,

 void fsl_mc_driver_unregister(struct fsl_mc_driver *driver);

+int __must_check fsl_mc_portal_allocate(struct fsl_mc_device *mc_dev,
+					uint16_t mc_io_flags,
+					struct fsl_mc_io **new_mc_io);
+
+void fsl_mc_portal_free(struct fsl_mc_io *mc_io);
+
+int __must_check fsl_mc_object_allocate(struct fsl_mc_device *mc_dev,
+					enum fsl_mc_pool_type pool_type,
+					struct fsl_mc_device **new_mc_adev);
+
+void fsl_mc_object_free(struct fsl_mc_device *mc_adev);
+
 extern struct bus_type fsl_mc_bus_type;

 #endif /* _FSL_MC_H_ */
--
2.2.2

