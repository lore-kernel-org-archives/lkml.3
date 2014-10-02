Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaJBXfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 19:35:36 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:43886 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaJBXfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 19:35:34 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Foley <pefoley2@pefoley.com>, rdunlap@infradead.org,
        linux-doc@vger.kernel.org, sudeep.dutt@intel.com, nikhil.rao@intel.com,
        ashutosh.dixit@intel.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, harshavardhan.r.kharche@intel.com,
        caz.yokoyama@intel.com, dasaratharaman.chandramouli@intel.com,
        jkosina@suse.cz
Subject: [PATCH] Documentation: update include path for mpssd
Date: Thu,  2 Oct 2014 19:35:26 -0400
Message-Id: <1412292926-21742-1-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412292579-21519-1-git-send-email-pefoley2@pefoley.com>
References: <1412292579-21519-1-git-send-email-pefoley2@pefoley.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs.c includes mpssd.h which includes virtio_ids.h.
sysfs.c doesn't have the proper include flags set to use the latest
headers, so this causes a build error if the system headers are too old.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
Cc: rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org
Cc: sudeep.dutt@intel.com
Cc: nikhil.rao@intel.com
Cc: ashutosh.dixit@intel.com
Cc: akpm@linux-foundation.org
Cc: gregkh@linuxfoundation.org
Cc: harshavardhan.r.kharche@intel.com
Cc: caz.yokoyama@intel.com
Cc: dasaratharaman.chandramouli@intel.com
Cc: jkosina@suse.cz
---

Resending with missing CC to Documentation maintainer

 Documentation/mic/mpssd/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mic/mpssd/Makefile b/Documentation/mic/mpssd/Makefile
index 505d84f..0f31568 100644
--- a/Documentation/mic/mpssd/Makefile
+++ b/Documentation/mic/mpssd/Makefile
@@ -6,7 +6,7 @@ mpssd-objs := mpssd.o sysfs.o
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
-HOSTCFLAGS_mpssd.o += -I$(objtree)/usr/include -I$(srctree)/tools/include
+HOSTCFLAGS += -I$(objtree)/usr/include -I$(srctree)/tools/include
 
 ifdef DEBUG
 HOSTCFLAGS += -DDEBUG=$(DEBUG)
-- 
2.1.1

