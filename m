Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaAIB7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:59:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33890 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaAIB71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:59:27 -0500
Message-ID: <52CE0252.4090106@oracle.com>
Date: Thu, 09 Jan 2014 09:58:42 +0800
From: ethan zhao <ethan.zhao@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: joro@8bytes.org, dwmw2@infradead.org, yinghai@kernel.org,
        bhelgaas@google.com, jiang.liu@linux.intel.com
CC: iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH Trivial] intel-iommu: check return value of device_to_iommu()
 before using it
Content-Type: multipart/mixed;
 boundary="------------030603040806070308050806"
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030603040806070308050806
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

in function iommu_support_dev_iotlb(),return value of device_to_iommu()
is used without checking, this could cause NULL pointer issue.

this patch is for v3.12.6

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
  drivers/iommu/intel-iommu.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 40203ad..5b4531a 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1105,6 +1105,8 @@ static struct device_domain_info 
*iommu_support_dev_iotlb(
      struct device_domain_info *info;
      struct intel_iommu *iommu = device_to_iommu(segment, bus, devfn);

+    if (!iommu)
+        return NULL;
      if (!ecap_dev_iotlb_support(iommu->ecap))
          return NULL;

-- 
1.7.1


--------------030603040806070308050806
Content-Type: text/x-patch;
 name="0001-intel-iommu-check-return-value-of-device_to_iommu-be.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-intel-iommu-check-return-value-of-device_to_iommu-be.pa";
 filename*1="tch"

>From 27d8cdd3fcc6f4ff5cc2ba36d8d5ea0a97823a17 Mon Sep 17 00:00:00 2001
From: ethan.zhao <ethan.zhao@oracle.com>
Date: Thu, 9 Jan 2014 08:40:16 -0500
Subject: [PATCH] intel-iommu: check return value of device_to_iommu() before using it

in function iommu_support_dev_iotlb(),return value of device_to_iommu()
is used without checking, this could cause NULL pointer issue.

this patch is for v3.12.6

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 drivers/iommu/intel-iommu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 40203ad..5b4531a 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1105,6 +1105,8 @@ static struct device_domain_info *iommu_support_dev_iotlb(
 	struct device_domain_info *info;
 	struct intel_iommu *iommu = device_to_iommu(segment, bus, devfn);
 
+	if (!iommu)
+		return NULL;
 	if (!ecap_dev_iotlb_support(iommu->ecap))
 		return NULL;
 
-- 
1.7.1


--------------030603040806070308050806--
