Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093AbaE2VY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:24:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:60496 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109AbaE2VYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:24:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,936,1392192000"; 
   d="scan'208";a="519900300"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH char-misc-next v2 8/8] misc: mic: add support for loading/unloading dma driver
Date: Thu, 29 May 2014 14:24:05 -0700
Message-Id: <6794c5147a03c2356ebb305b10c18e05e0c95a54.1401397315.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1401397315.git.sudeep.dutt@intel.com>
References: <cover.1401397315.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1401397315.git.sudeep.dutt@intel.com>
References: <cover.1401397315.git.sudeep.dutt@intel.com>
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

