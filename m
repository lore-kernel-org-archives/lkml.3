Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab3EGHFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:05:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:53688 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab3EGHFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:05:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,627,1363158000"; 
   d="scan'208";a="298699265"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>
Subject: [PATCH 4/4] driver: provide sysfs interfaces to access SMX parameter
Date: Tue,  7 May 2013 22:55:19 +0800
Message-Id: <1367938519-840-5-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These interfaces are located in /sys/devices/platform/intel_txt/parameter/,
showing specific parameter information for SMX features supported by
the processor.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Signed-off-by: Gang Wei <gang.wei@intel.com>
---
 Documentation/ABI/testing/sysfs-platform-intel-txt |   65 +++++
 drivers/platform/x86/intel_txt/Makefile            |    2 +-
 drivers/platform/x86/intel_txt/txt-parameter.c     |  253 ++++++++++++++++++++
 drivers/platform/x86/intel_txt/txt-parameter.h     |   40 ++++
 drivers/platform/x86/intel_txt/txt-sysfs.c         |    5 +
 5 files changed, 364 insertions(+), 1 deletion(-)
 create mode 100644 drivers/platform/x86/intel_txt/txt-parameter.c
 create mode 100644 drivers/platform/x86/intel_txt/txt-parameter.h

diff --git a/Documentation/ABI/testing/sysfs-platform-intel-txt b/Documentation/ABI/testing/sysfs-platform-intel-txt
index ccacac3..c2f9720 100644
--- a/Documentation/ABI/testing/sysfs-platform-intel-txt
+++ b/Documentation/ABI/testing/sysfs-platform-intel-txt
@@ -335,3 +335,68 @@ Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
 Description:	The "block_index" property allows you to set the block
 		index for output.
 
+What:		/sys/devices/platform/intel_txt/parameter/
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	The parameter/ directory exposes specific parameter
+		information for SMX features supported by the processor.
+
+What:		/sys/devices/platform/intel_txt/parameter/acm_max_size
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	The "acm_max_size" property will show max size of
+		authenticated code execution area.
+
+What:		/sys/devices/platform/intel_txt/parameter/acm_mem_types
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	The "acm_max_types" property will show external memory
+		types supported during AC mode.
+
+What:		/sys/devices/platform/intel_txt/parameter/senter_controls
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	The "senter_controls" property will show selective SENTER
+		functionality control.
+
+What:		/sys/devices/platform/intel_txt/parameter/preserve_mce
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	The "preserve_mce" property produces a '1' if machine
+		check status registers can be preserved through ENTERACCS
+		and SENTER.
+
+What:		/sys/devices/platform/intel_txt/parameter/proc_based_scrtm
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	The "proc_based_scrtm" property produces a '1' if this
+		processor implements a processorrooted S-CRTM capability
+		and '0' if not (S-CRTM is rooted in BIOS).
+
+What:		/sys/devices/platform/intel_txt/parameter/n_versions
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	The "n_versions" property will show AC module version
+		numbers supported.
+
+What:		/sys/devices/platform/intel_txt/parameter/acm_version
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	The "acm_version" property will output supported AC
+		module version, including version comparison mask and
+		version index.
+
+What:		/sys/devices/platform/intel_txt/parameter/acm_version_index
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	The "acm_version_index" property allows you to set the
+		version index for output.
diff --git a/drivers/platform/x86/intel_txt/Makefile b/drivers/platform/x86/intel_txt/Makefile
index 2265370..5914c11 100644
--- a/drivers/platform/x86/intel_txt/Makefile
+++ b/drivers/platform/x86/intel_txt/Makefile
@@ -2,4 +2,4 @@
 # Makefile for the intel TXT drivers.
 #
 obj-$(CONFIG_INTEL_TXT_DRIVER) += intel_txt.o
-intel_txt-y := txt-sysfs.o txt-config.o txt-log.o
+intel_txt-y := txt-sysfs.o txt-config.o txt-log.o txt-parameter.o
diff --git a/drivers/platform/x86/intel_txt/txt-parameter.c b/drivers/platform/x86/intel_txt/txt-parameter.c
new file mode 100644
index 0000000..b8be55e
--- /dev/null
+++ b/drivers/platform/x86/intel_txt/txt-parameter.c
@@ -0,0 +1,253 @@
+/*
+ * txt-parameter.c
+ *
+ * specific parameter information for SMX features supported by the processor.
+ *
+ * - parameter/
+ *   n_versions		-r--r--r--;
+ *   acm_max_size	-r--r--r--;
+ *   acm_mem_types	-r--r--r--;
+ *   senter_controls	-r--r--r--;
+ *   proc_based_scrtm	-r--r--r--;
+ *   preserve_mce	-r--r--r--;
+ *   acm_version_index	-rw-rw-r--; desginate which acm_version will be output
+ *   acm_version	-r--r--r--;
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sysfs.h>
+
+#include "txt-parameter.h"
+
+static u32 acm_version_index;
+
+static void __getsec_parameters(uint32_t index, int *param_type,
+				uint32_t *peax, uint32_t *pebx,
+				uint32_t *pecx)
+{
+	uint32_t eax = 0, ebx = 0, ecx = 0;
+
+	__asm__ __volatile__ (IA32_GETSEC_OPCODE "\n"
+			      : "=a"(eax), "=b"(ebx), "=c"(ecx)
+			      : "a"(IA32_GETSEC_PARAMETERS), "b"(index));
+
+	*param_type = eax & 0x1f;
+	*peax = eax;
+	*pebx = ebx;
+	*pecx = ecx;
+}
+
+static bool get_parameters(struct getsec_parameters *params)
+{
+	uint32_t index, eax, ebx, ecx;
+	int param_type;
+
+	write_cr4(read_cr4() | CR4_SMXE);
+
+	memset(params, 0, sizeof(struct getsec_parameters));
+	params->acm_max_size = DEF_ACM_MAX_SIZE;
+	params->acm_mem_types = DEF_ACM_MEM_TYPES;
+	params->senter_controls = DEF_SENTER_CTRLS;
+	params->proc_based_scrtm = false;
+	params->preserve_mce = false;
+
+	index = 0;
+	do {
+		__getsec_parameters(index++, &param_type, &eax, &ebx, &ecx);
+
+		switch (param_type) {
+		case 1:
+			if (params->n_versions == MAX_SUPPORTED_ACM_VERSIONS)
+				continue;
+			params->acm_versions[params->n_versions].mask = ebx;
+			params->acm_versions[params->n_versions].version = ecx;
+			params->n_versions++;
+			break;
+
+		case 2:
+			params->acm_max_size = eax & 0xffffffe0;
+			break;
+
+		case 3:
+			params->acm_mem_types = eax & 0xffffffe0;
+			break;
+
+		case 4:
+			params->senter_controls = (eax & 0x00007fff) >> 8;
+			break;
+
+		case 5:
+			params->proc_based_scrtm =
+				(eax & 0x00000020) ? true : false;
+			params->preserve_mce =
+				(eax & 0x00000040) ? true : false;
+			break;
+
+		default:
+			param_type = 0;
+			break;
+		}
+	} while (param_type != 0);
+
+	if (params->n_versions == 0) {
+		params->acm_versions[0].mask = DEF_ACM_VER_MASK;
+		params->acm_versions[0].version = DEF_ACM_VER_SUPPORTED;
+		params->n_versions = 1;
+	}
+
+	return true;
+}
+
+static ssize_t show_param(char *buf, u32 index)
+{
+	struct getsec_parameters params;
+
+	if (!get_parameters(&params))
+		return -EPERM;
+
+	switch (index) {
+	case off_n_versions:
+		return scnprintf(buf, PAGE_SIZE, "%d\n",
+				params.n_versions);
+
+	case off_acm_max_size:
+		return scnprintf(buf, PAGE_SIZE, "%u\n",
+				 params.acm_max_size);
+
+	case off_acm_mem_types:
+		return scnprintf(buf, PAGE_SIZE, "%u\n",
+				 params.acm_mem_types);
+
+	case off_senter_controls:
+		return scnprintf(buf, PAGE_SIZE, "%u\n",
+				 params.senter_controls);
+
+	case off_proc_based_scrtm:
+		return scnprintf(buf, PAGE_SIZE, "%d\n",
+				 params.proc_based_scrtm);
+
+	case off_preserve_mce:
+		return scnprintf(buf, PAGE_SIZE, "%d\n",
+				 params.preserve_mce);
+
+	case off_acm_version:
+		return scnprintf(buf, PAGE_SIZE,
+			"mask: %u\nversion: %u\n",
+			params.acm_versions[acm_version_index].mask,
+			params.acm_versions[acm_version_index].version);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+ssize_t txt_show_param_nversions(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	return show_param(buf, off_n_versions);
+}
+static DEVICE_ATTR(n_versions, S_IRUGO, txt_show_param_nversions, NULL);
+
+ssize_t txt_show_param_acmmaxsize(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	return show_param(buf, off_acm_max_size);
+}
+static DEVICE_ATTR(acm_max_size, S_IRUGO, txt_show_param_acmmaxsize, NULL);
+
+ssize_t txt_show_param_acmmemtypes(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	return show_param(buf, off_acm_mem_types);
+}
+static DEVICE_ATTR(acm_mem_types, S_IRUGO, txt_show_param_acmmemtypes, NULL);
+
+ssize_t txt_show_param_senter(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	return show_param(buf, off_senter_controls);
+}
+static DEVICE_ATTR(senter_controls, S_IRUGO, txt_show_param_senter, NULL);
+
+ssize_t txt_show_param_proc(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	return show_param(buf, off_proc_based_scrtm);
+}
+static DEVICE_ATTR(proc_based_scrtm, S_IRUGO, txt_show_param_proc, NULL);
+
+ssize_t txt_show_param_preserve(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return show_param(buf, off_preserve_mce);
+}
+static DEVICE_ATTR(preserve_mce, S_IRUGO, txt_show_param_preserve, NULL);
+
+ssize_t txt_show_param_acmvindex(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", acm_version_index);
+}
+
+ssize_t txt_store_param_acmvindex(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	u32 index;
+	struct getsec_parameters params;
+
+	sscanf(buf, "%d", &index);
+
+	if (!get_parameters(&params))
+		return -EPERM;
+
+	if (index >= params.n_versions)
+		return -EINVAL;
+
+	acm_version_index = index;
+
+	return count;
+}
+static DEVICE_ATTR(acm_version_index, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_param_acmvindex, txt_store_param_acmvindex);
+
+ssize_t txt_show_param_acmversion(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	return show_param(buf, off_acm_version);
+}
+static DEVICE_ATTR(acm_version, S_IRUGO, txt_show_param_acmversion, NULL);
+
+static struct attribute *param_attrs[] = {
+	&dev_attr_n_versions.attr,
+	&dev_attr_acm_max_size.attr,
+	&dev_attr_acm_mem_types.attr,
+	&dev_attr_senter_controls.attr,
+	&dev_attr_proc_based_scrtm.attr,
+	&dev_attr_preserve_mce.attr,
+	&dev_attr_acm_version_index.attr,
+	&dev_attr_acm_version.attr,
+	NULL,
+};
+
+static struct attribute_group param_attr_grp = {
+	.name = "parameter",
+	.attrs = param_attrs
+};
+
+int sysfs_create_parameter(struct kobject *parent)
+{
+	return sysfs_create_group(parent, &param_attr_grp);
+}
+EXPORT_SYMBOL_GPL(sysfs_create_parameter);
+
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/platform/x86/intel_txt/txt-parameter.h b/drivers/platform/x86/intel_txt/txt-parameter.h
new file mode 100644
index 0000000..cdd681f
--- /dev/null
+++ b/drivers/platform/x86/intel_txt/txt-parameter.h
@@ -0,0 +1,40 @@
+#ifndef __PARAMETER_H__
+#define __PARAMETER_H__
+
+#define CR4_SMXE 0x00004000
+#define MAX_SUPPORTED_ACM_VERSIONS 16
+
+#define DEF_ACM_MAX_SIZE	0x8000
+#define DEF_ACM_VER_MASK	0xffffffff
+#define DEF_ACM_VER_SUPPORTED	0x00
+#define DEF_ACM_MEM_TYPES	0x0100
+#define DEF_SENTER_CTRLS	0x00
+
+#define IA32_GETSEC_OPCODE	".byte 0x0f,0x37"
+#define IA32_GETSEC_PARAMETERS	6
+
+#define off_n_versions		1
+#define off_acm_max_size	2
+#define off_acm_mem_types	3
+#define off_senter_controls	4
+#define off_proc_based_scrtm	5
+#define off_preserve_mce	6
+#define off_acm_version		7
+
+typedef struct getsec_parameters {
+	struct {
+		uint32_t mask;
+		uint32_t version;
+	} acm_versions[MAX_SUPPORTED_ACM_VERSIONS];
+	int n_versions;
+	uint32_t acm_max_size;
+	uint32_t acm_mem_types;
+	uint32_t senter_controls;
+	bool proc_based_scrtm;
+	bool preserve_mce;
+} getsec_parameters_t;
+
+extern int sysfs_create_parameter(struct kobject *parent);
+
+#endif /* __PARAMETER_H__ */
+
diff --git a/drivers/platform/x86/intel_txt/txt-sysfs.c b/drivers/platform/x86/intel_txt/txt-sysfs.c
index af556b6..7d4f111 100644
--- a/drivers/platform/x86/intel_txt/txt-sysfs.c
+++ b/drivers/platform/x86/intel_txt/txt-sysfs.c
@@ -17,6 +17,7 @@
 
 #include "txt-config.h"
 #include "txt-log.h"
+#include "txt-parameter.h"
 
 #define DEV_NAME "intel_txt"
 static struct platform_device *txt_pdev;
@@ -37,6 +38,10 @@ static int __init txt_sysfs_init(void)
 	if (retval)
 		goto err;
 
+	retval = sysfs_create_parameter(&txt_pdev->dev.kobj);
+	if (retval)
+		goto err;
+
 	return 0;
 
 err:
-- 
1.7.9.5

