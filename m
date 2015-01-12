Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbbALXLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:11:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:32013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbbALXKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:10:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="511204110"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next v2 13/13] misc: mic: add support for loading/unloading SCIF driver
Date: Mon, 12 Jan 2015 15:10:07 -0800
Message-Id: <0d95c292a3058671b18472e5805c74f1a7d8e207.1421097390.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1421097390.git.sudeep.dutt@intel.com>
References: <cover.1421097390.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1421097390.git.sudeep.dutt@intel.com>
References: <cover.1421097390.git.sudeep.dutt@intel.com>
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

