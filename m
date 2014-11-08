Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaKHSkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:40:21 -0500
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:27981
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751370AbaKHSkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:40:17 -0500
X-WSS-ID: 0NEQH70-07-RDX-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>, <linux-api@vger.kernel.org>
Subject: [PATCH v5 07/24] amdkfd: Add IOCTL set definitions of amdkfd
Date: Sat, 8 Nov 2014 20:37:28 +0200
Message-ID: <1415471865-1893-8-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51234002)(189002)(199003)(101416001)(89996001)(88136002)(68736004)(19580395003)(19580405001)(97736003)(76176999)(99396003)(120916001)(104166001)(84676001)(87286001)(102836001)(50986999)(44976005)(92566001)(33646002)(87936001)(46102003)(31966008)(4396001)(50226001)(107046002)(229853001)(105586002)(62966003)(50466002)(77156002)(92726001)(48376002)(77096003)(53416004)(93916002)(21056001)(95666004)(86362001)(47776003)(106466001)(64706001)(36756003)(20776003)(129583001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0201MB1077;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0201MB1077;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0201MB1077;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0201MB1077;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- KFD_IOC_GET_VERSION:
	Retrieves the interface version of amdkfd

- KFD_IOC_CREATE_QUEUE:
	Creates a usermode queue that runs on a specific GPU device

- KFD_IOC_DESTROY_QUEUE:
	Destroys an existing usermode queue

- KFD_IOC_SET_MEMORY_POLICY:
	Sets the memory policy of the default and alternate aperture of the
        calling process

- KFD_IOC_GET_CLOCK_COUNTERS:
	Retrieves counters (timestamps) of CPU and GPU

- KFD_IOC_GET_PROCESS_APERTURES:
	Retrieves information about process apertures that were initialized
        during the open() call of the amdkfd device

- KFD_IOC_UPDATE_QUEUE:
	Updates configuration of an existing usermode queue

v3: Remove pragma pack and pmc ioctls. Added parameter for doorbell offset and
a comment on counters

v5:

Add define for AQL queues.
Fix arguments of Get Version IOCTL
Make IOCTL's structures to be the same size on 32/64 bit

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 include/uapi/linux/kfd_ioctl.h | 154 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 154 insertions(+)
 create mode 100644 include/uapi/linux/kfd_ioctl.h

diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
new file mode 100644
index 0000000..fa1bc6d
--- /dev/null
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -0,0 +1,154 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef KFD_IOCTL_H_INCLUDED
+#define KFD_IOCTL_H_INCLUDED
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define KFD_IOCTL_MAJOR_VERSION 1
+#define KFD_IOCTL_MINOR_VERSION 2
+
+struct kfd_ioctl_get_version_args {
+	uint32_t major_version;	/* from KFD */
+	uint32_t minor_version;	/* from KFD */
+};
+
+/* For kfd_ioctl_create_queue_args.queue_type. */
+#define KFD_IOC_QUEUE_TYPE_COMPUTE	0
+#define KFD_IOC_QUEUE_TYPE_SDMA		1
+#define KFD_IOC_QUEUE_TYPE_COMPUTE_AQL	2
+
+#define KFD_MAX_QUEUE_PERCENTAGE	100
+#define KFD_MAX_QUEUE_PRIORITY		15
+
+struct kfd_ioctl_create_queue_args {
+	uint64_t ring_base_address;	/* to KFD */
+	uint64_t write_pointer_address;	/* from KFD */
+	uint64_t read_pointer_address;	/* from KFD */
+	uint64_t doorbell_offset;	/* from KFD */
+
+	uint32_t ring_size;		/* to KFD */
+	uint32_t gpu_id;		/* to KFD */
+	uint32_t queue_type;		/* to KFD */
+	uint32_t queue_percentage;	/* to KFD */
+	uint32_t queue_priority;	/* to KFD */
+	uint32_t queue_id;		/* from KFD */
+
+	uint64_t eop_buffer_address;	/* to KFD */
+	uint64_t eop_buffer_size;	/* to KFD */
+	uint64_t ctx_save_restore_address; /* to KFD */
+	uint64_t ctx_save_restore_size;	/* to KFD */
+};
+
+struct kfd_ioctl_destroy_queue_args {
+	uint32_t queue_id;		/* to KFD */
+	uint32_t pad;
+};
+
+struct kfd_ioctl_update_queue_args {
+	uint64_t ring_base_address;	/* to KFD */
+
+	uint32_t queue_id;		/* to KFD */
+	uint32_t ring_size;		/* to KFD */
+	uint32_t queue_percentage;	/* to KFD */
+	uint32_t queue_priority;	/* to KFD */
+};
+
+/* For kfd_ioctl_set_memory_policy_args.default_policy and alternate_policy */
+#define KFD_IOC_CACHE_POLICY_COHERENT 0
+#define KFD_IOC_CACHE_POLICY_NONCOHERENT 1
+
+struct kfd_ioctl_set_memory_policy_args {
+	uint64_t alternate_aperture_base;	/* to KFD */
+	uint64_t alternate_aperture_size;	/* to KFD */
+
+	uint32_t gpu_id;			/* to KFD */
+	uint32_t default_policy;		/* to KFD */
+	uint32_t alternate_policy;		/* to KFD */
+	uint32_t pad;
+};
+
+/*
+ * All counters are monotonic. They are used for profiling of compute jobs.
+ * The profiling is done by userspace.
+ *
+ * In case of GPU reset, the counter should not be affected.
+ */
+
+struct kfd_ioctl_get_clock_counters_args {
+	uint64_t gpu_clock_counter;	/* from KFD */
+	uint64_t cpu_clock_counter;	/* from KFD */
+	uint64_t system_clock_counter;	/* from KFD */
+	uint64_t system_clock_freq;	/* from KFD */
+
+	uint32_t gpu_id;		/* to KFD */
+	uint32_t pad;
+};
+
+#define NUM_OF_SUPPORTED_GPUS 7
+
+struct kfd_process_device_apertures {
+	uint64_t lds_base;		/* from KFD */
+	uint64_t lds_limit;		/* from KFD */
+	uint64_t scratch_base;		/* from KFD */
+	uint64_t scratch_limit;		/* from KFD */
+	uint64_t gpuvm_base;		/* from KFD */
+	uint64_t gpuvm_limit;		/* from KFD */
+	uint32_t gpu_id;		/* from KFD */
+	uint32_t pad;
+};
+
+struct kfd_ioctl_get_process_apertures_args {
+	struct kfd_process_device_apertures
+			process_apertures[NUM_OF_SUPPORTED_GPUS];/* from KFD */
+
+	/* from KFD, should be in the range [1 - NUM_OF_SUPPORTED_GPUS] */
+	uint32_t num_of_nodes;
+	uint32_t pad;
+};
+
+#define KFD_IOC_MAGIC 'K'
+
+#define KFD_IOC_GET_VERSION \
+		_IOR(KFD_IOC_MAGIC, 1, struct kfd_ioctl_get_version_args)
+
+#define KFD_IOC_CREATE_QUEUE \
+		_IOWR(KFD_IOC_MAGIC, 2, struct kfd_ioctl_create_queue_args)
+
+#define KFD_IOC_DESTROY_QUEUE \
+	_IOWR(KFD_IOC_MAGIC, 3, struct kfd_ioctl_destroy_queue_args)
+
+#define KFD_IOC_SET_MEMORY_POLICY \
+	_IOW(KFD_IOC_MAGIC, 4, struct kfd_ioctl_set_memory_policy_args)
+
+#define KFD_IOC_GET_CLOCK_COUNTERS \
+	_IOWR(KFD_IOC_MAGIC, 5, struct kfd_ioctl_get_clock_counters_args)
+
+#define KFD_IOC_GET_PROCESS_APERTURES \
+	_IOR(KFD_IOC_MAGIC, 6, struct kfd_ioctl_get_process_apertures_args)
+
+#define KFD_IOC_UPDATE_QUEUE \
+	_IOW(KFD_IOC_MAGIC, 7, struct kfd_ioctl_update_queue_args)
+
+#endif
-- 
2.1.0

