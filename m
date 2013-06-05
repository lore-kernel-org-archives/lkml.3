Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab3FESwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 14:52:12 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:55077 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093Ab3FESwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 14:52:10 -0400
Subject: [PATCH v4 6/8] powerpc/pseries: Distinguish between a os-partition
 and non-os partition
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Thu, 06 Jun 2013 00:21:59 +0530
Message-ID: <20130605185159.25794.87413.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130605184756.25794.43872.stgit@aruna-ThinkPad-T420>
References: <20130605184756.25794.43872.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060518-5490-0000-0000-0000039736C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce os_partition member in nvram_os_partition structure to identify
if the partition is an os partition or not. This will be useful to handle
non-os partitions of-config and common.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/powerpc/platforms/pseries/nvram.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/nvram.c b/arch/powerpc/platforms/pseries/nvram.c
index 78d72f0..714ed8a 100644
--- a/arch/powerpc/platforms/pseries/nvram.c
+++ b/arch/powerpc/platforms/pseries/nvram.c
@@ -53,20 +53,23 @@ struct nvram_os_partition {
 	int min_size;	/* minimum acceptable size (0 means req_size) */
 	long size;	/* size of data portion (excluding err_log_info) */
 	long index;	/* offset of data portion of partition */
+	bool os_partition; /* partition initialized by OS, not FW */
 };
 
 static struct nvram_os_partition rtas_log_partition = {
 	.name = "ibm,rtas-log",
 	.req_size = 2079,
 	.min_size = 1055,
-	.index = -1
+	.index = -1,
+	.os_partition = true
 };
 
 static struct nvram_os_partition oops_log_partition = {
 	.name = "lnx,oops-log",
 	.req_size = 4000,
 	.min_size = 2000,
-	.index = -1
+	.index = -1,
+	.os_partition = true
 };
 
 static const char *pseries_nvram_os_partitions[] = {

