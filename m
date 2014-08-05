Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbaHEPcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:32:24 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:11418
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751885AbaHEPcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:32:18 -0400
X-WSS-ID: 0N9UB5O-07-3EX-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "David Airlie" <airlied@linux.ie>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>,
        Alexander Deucher <alexdeucher@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>, <Andrew.Lewycky@amd.com>,
        <deathsimple@vodafone.de>, <michel.daenzer@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v3 07/23] amdkfd: Add IOCTL set definitions of amdkfd
Date: Tue, 5 Aug 2014 18:30:35 +0300
Message-ID: <1407252651-3539-8-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(51234002)(64706001)(92726001)(92566001)(85852003)(83072002)(89996001)(88136002)(20776003)(87286001)(47776003)(50226001)(4396001)(19580395003)(19580405001)(83322001)(44976005)(95666004)(105586002)(50986999)(31966008)(99396002)(106466001)(21056001)(107046002)(87936001)(33646002)(74502001)(74662001)(229853001)(76176999)(79102001)(77982001)(62966002)(84676001)(36756003)(77096002)(46102001)(77156001)(81342001)(48376002)(50466002)(97736001)(102836001)(81542001)(85306004)(80022001)(104166001)(68736004)(76482001)(101416001)(86362001)(129583001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB037;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
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

(v3) remove pragma pack

(v3) remove pmc ioctls

(v3) add parameter for doorbell offset

(v3) add comment on counters

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 include/uapi/linux/kfd_ioctl.h | 123 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 include/uapi/linux/kfd_ioctl.h

diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
new file mode 100644
index 0000000..a06e021
--- /dev/null
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -0,0 +1,123 @@
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
+#define KFD_IOCTL_CURRENT_VERSION 1
+
+struct kfd_ioctl_get_version_args {
+	uint32_t min_supported_version;	/* from KFD */
+	uint32_t max_supported_version;	/* from KFD */
+};
+
+/* For kfd_ioctl_create_queue_args.queue_type. */
+#define KFD_IOC_QUEUE_TYPE_COMPUTE   0
+#define KFD_IOC_QUEUE_TYPE_SDMA      1
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
+};
+
+struct kfd_ioctl_destroy_queue_args {
+	uint32_t queue_id;		/* to KFD */
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
+};
+
+struct kfd_ioctl_get_process_apertures_args {
+	struct kfd_process_device_apertures process_apertures[NUM_OF_SUPPORTED_GPUS];/* from KFD */
+	uint8_t num_of_nodes; /* from KFD, should be in the range [1 - NUM_OF_SUPPORTED_GPUS]*/
+};
+
+#define KFD_IOC_MAGIC 'K'
+
+#define KFD_IOC_GET_VERSION		_IOR(KFD_IOC_MAGIC, 1, struct kfd_ioctl_get_version_args)
+#define KFD_IOC_CREATE_QUEUE		_IOWR(KFD_IOC_MAGIC, 2, struct kfd_ioctl_create_queue_args)
+#define KFD_IOC_DESTROY_QUEUE		_IOWR(KFD_IOC_MAGIC, 3, struct kfd_ioctl_destroy_queue_args)
+#define KFD_IOC_SET_MEMORY_POLICY	_IOW(KFD_IOC_MAGIC, 4, struct kfd_ioctl_set_memory_policy_args)
+#define KFD_IOC_GET_CLOCK_COUNTERS	_IOWR(KFD_IOC_MAGIC, 5, struct kfd_ioctl_get_clock_counters_args)
+#define KFD_IOC_GET_PROCESS_APERTURES	_IOR(KFD_IOC_MAGIC, 6, struct kfd_ioctl_get_process_apertures_args)
+#define KFD_IOC_UPDATE_QUEUE		_IOW(KFD_IOC_MAGIC, 7, struct kfd_ioctl_update_queue_args)
+
+#endif
-- 
1.9.1

