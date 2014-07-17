Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbaGQNcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:32:21 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:46081
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756732AbaGQNcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:32:17 -0400
X-WSS-ID: 0N8UYXO-07-BZS-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "Oded Gabbay" <oded.gabbay@amd.com>, <linux-kernel@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: [PATCH v2 08/25] amdkfd: Add IOCTL set definitions of amdkfd
Date: Thu, 17 Jul 2014 16:29:15 +0300
Message-ID: <1405603773-32688-9-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51234002)(199002)(189002)(44976005)(31966008)(85306003)(48376002)(64706001)(95666004)(81542001)(68736004)(77156001)(99396002)(47776003)(20776003)(92566001)(101416001)(77096002)(80022001)(36756003)(77982001)(50466002)(105586002)(4396001)(85852003)(92726001)(89996001)(74502001)(81342001)(76482001)(97736001)(19580395003)(74662001)(83322001)(19580405001)(104166001)(106466001)(87936001)(87286001)(229853001)(76176999)(21056001)(50986999)(83072002)(107046002)(50226001)(84676001)(33646002)(62966002)(46102001)(86362001)(102836001)(79102001)(93916002)(88136002)(129583001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
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
	Sets the memory policy of the default and alternate aperture of the calling process

- KFD_IOC_GET_CLOCK_COUNTERS:
	Retrieves counters (timestamps) of CPU and GPU

- KFD_IOC_GET_PROCESS_APERTURES:
	Retrieves information about process apertures that were initialized
during the open() call of the amdkfd device

- KFD_IOC_UPDATE_QUEUE:
	Updates configuration of an existing usermode queue

- KFD_IOC_PMC_ACQUIRE_ACCESS:
	Acquires exclusive access (from other HSA processes) to the performance
counters of the GPU

- KFD_IOC_PMC_RELEASE_ACCESS:
	Releases exclusive access of the GPU's performance counters

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 include/uapi/linux/kfd_ioctl.h | 133 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)
 create mode 100644 include/uapi/linux/kfd_ioctl.h

diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
new file mode 100644
index 0000000..3cedd1a
--- /dev/null
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -0,0 +1,133 @@
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
+/* The 64-bit ABI is the authoritative version. */
+#pragma pack(push, 1)
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
+	uint64_t doorbell_address;	/* from KFD */
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
+struct kfd_ioctl_pmc_acquire_access_args {
+	uint64_t trace_id;		/* to KFD */
+	uint32_t gpu_id;		/* to KFD */
+};
+
+struct kfd_ioctl_pmc_release_access_args {
+	uint64_t trace_id;		/* to KFD */
+	uint32_t gpu_id;		/* to KFD */
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
+#define KFD_IOC_PMC_ACQUIRE_ACCESS	_IOW(KFD_IOC_MAGIC, 12, struct kfd_ioctl_pmc_acquire_access_args)
+#define KFD_IOC_PMC_RELEASE_ACCESS	_IOW(KFD_IOC_MAGIC, 13, struct kfd_ioctl_pmc_release_access_args)
+
+#pragma pack(pop)
+
+#endif
-- 
1.9.1

