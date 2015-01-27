Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbbA0Aef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:34:35 -0500
Received: from mga09.intel.com ([134.134.136.24]:34224 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365AbbA0Ada (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:33:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,471,1418112000"; 
   d="scan'208";a="517961027"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next v3 13/13] misc: mic: add support for loading/unloading SCIF driver
Date: Mon, 26 Jan 2015 16:32:54 -0800
Message-Id: <9f80433c2c9bc52fe6396cc1753e60fa266fa9cd.1422317099.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1422317099.git.sudeep.dutt@intel.com>
References: <cover.1422317099.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1422317099.git.sudeep.dutt@intel.com>
References: <cover.1422317099.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modprobe SCIF driver upon start and remove it upon unload

Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 Documentation/mic/mpssd/mpss | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/Documentation/mic/mpssd/mpss b/Documentation/mic/mpssd/mpss
index cacbdb0..582aad4 100755
--- a/Documentation/mic/mpssd/mpss
+++ b/Documentation/mic/mpssd/mpss
@@ -35,6 +35,7 @@
 
 exec=/usr/sbin/mpssd
 sysfs="/sys/class/mic"
+mic_modules="mic_host mic_x100_dma scif"
 
 start()
 {
@@ -48,18 +49,15 @@ start()
 	fi
 
 	echo -e $"Starting MPSS Stack"
-	echo -e $"Loading MIC_X100_DMA & MIC_HOST Modules"
+	echo -e $"Loading MIC drivers:" $mic_modules
 
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
+	modprobe -a $mic_modules
+	RETVAL=$?
+	if [ $RETVAL -ne 0 ]; then
+		failure
+		echo
+		return $RETVAL
+	fi
 
 	# Start the daemon
 	echo -n $"Starting MPSSD "
@@ -170,8 +168,8 @@ unload()
 	stop
 
 	sleep 5
-	echo -n $"Removing MIC_HOST & MIC_X100_DMA Modules: "
-	modprobe -r mic_host mic_x100_dma
+	echo -n $"Removing MIC drivers:" $mic_modules
+	modprobe -r $mic_modules
 	RETVAL=$?
 	[ $RETVAL -ne 0 ] && failure || success
 	echo
-- 
1.8.2.1

