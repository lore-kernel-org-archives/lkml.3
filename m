Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbaLJTtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:49:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:61026 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932986AbaLJTtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="621770568"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 13/13] misc: mic: add support for loading/unloading SCIF driver
Date: Wed, 10 Dec 2014 11:47:53 -0800
Message-Id: <db1f5fba5770c83cb82fb8109380b6691d1b968d.1418237176.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modprobe SCIF driver upon start and remove it upon unload

Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 Documentation/mic/mpssd/mpss | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/Documentation/mic/mpssd/mpss b/Documentation/mic/mpssd/mpss
index cacbdb0..fa0e99e 100755
--- a/Documentation/mic/mpssd/mpss
+++ b/Documentation/mic/mpssd/mpss
@@ -48,18 +48,15 @@ start()
 	fi
 
 	echo -e $"Starting MPSS Stack"
-	echo -e $"Loading MIC_X100_DMA & MIC_HOST Modules"
+	echo -e $"Loading MIC_HOST, MIC_X100_DMA & SCIF Modules"
 
-	for f in "mic_host" "mic_x100_dma"
-	do
-		modprobe $f
-		RETVAL=$?
-		if [ $RETVAL -ne 0 ]; then
-			failure
-			echo
-			return $RETVAL
-		fi
-	done
+	modprobe -a mic_host mic_x100_dma scif
+	RETVAL=$?
+	if [ $RETVAL -ne 0 ]; then
+		failure
+		echo
+		return $RETVAL
+	fi
 
 	# Start the daemon
 	echo -n $"Starting MPSSD "
@@ -170,8 +167,8 @@ unload()
 	stop
 
 	sleep 5
-	echo -n $"Removing MIC_HOST & MIC_X100_DMA Modules: "
-	modprobe -r mic_host mic_x100_dma
+	echo -n $"Removing SCIF, MIC_HOST & MIC_X100_DMA Modules: "
+	modprobe -r scif mic_host mic_x100_dma scif
 	RETVAL=$?
 	[ $RETVAL -ne 0 ] && failure || success
 	echo
-- 
1.8.2.1

