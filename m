Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaGKVHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 17:07:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:38269 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbaGKVFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 17:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,645,1400050800"; 
   d="scan'208";a="456056345"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH char-misc-next v3 8/8] misc: mic: add support for loading/unloading dma driver
Date: Fri, 11 Jul 2014 14:04:26 -0700
Message-Id: <4ba1f69dc17343adb69760244e6302b9dd52e478.1405109402.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1405109401.git.sudeep.dutt@intel.com>
References: <cover.1405109401.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1405109401.git.sudeep.dutt@intel.com>
References: <cover.1405109401.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Siva Yerramreddy <yshivakrishna@gmail.com>

modprobe dma driver upon start and remove it upon unload.

Signed-off-by: Siva Yerramreddy <yshivakrishna@gmail.com>
---
 Documentation/mic/mpssd/mpss | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/mic/mpssd/mpss b/Documentation/mic/mpssd/mpss
index 3136c68..cacbdb0 100755
--- a/Documentation/mic/mpssd/mpss
+++ b/Documentation/mic/mpssd/mpss
@@ -48,18 +48,18 @@ start()
 	fi
 
 	echo -e $"Starting MPSS Stack"
-	echo -e $"Loading MIC_HOST Module"
+	echo -e $"Loading MIC_X100_DMA & MIC_HOST Modules"
 
-	# Ensure the driver is loaded
-	if [ ! -d "$sysfs" ]; then
-		modprobe mic_host
+	for f in "mic_host" "mic_x100_dma"
+	do
+		modprobe $f
 		RETVAL=$?
 		if [ $RETVAL -ne 0 ]; then
 			failure
 			echo
 			return $RETVAL
 		fi
-	fi
+	done
 
 	# Start the daemon
 	echo -n $"Starting MPSSD "
@@ -170,8 +170,8 @@ unload()
 	stop
 
 	sleep 5
-	echo -n $"Removing MIC_HOST Module: "
-	modprobe -r mic_host
+	echo -n $"Removing MIC_HOST & MIC_X100_DMA Modules: "
+	modprobe -r mic_host mic_x100_dma
 	RETVAL=$?
 	[ $RETVAL -ne 0 ] && failure || success
 	echo
-- 
1.8.2.1

