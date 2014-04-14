Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaDNUPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:15:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:38444 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaDNUPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:15:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,859,1389772800"; 
   d="scan'208";a="520342004"
From: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH 8/8] misc: mic: add support for loading/unloading dma driver
Date: Mon, 14 Apr 2014 13:15:05 -0700
Message-Id: <7204f6dac6ee1bf6f1bd66b353f92ff3341e5740.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
In-Reply-To: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modprobe dma driver upon start and remove it upon unload.

Signed-off-by: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
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
1.8.2.2

