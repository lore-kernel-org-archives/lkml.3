Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaLDVLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:11:07 -0500
Received: from mga03.intel.com ([134.134.136.65]:14833 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbaLDVLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:11:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,518,1413270000"; 
   d="scan'208";a="618812076"
From: Ashutosh Dixit <ashutosh.dixit@intel.com>
To: Jonathan Corbet <corbet@lwn.net>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Streetman <ddstreet@ieee.org>, Jennings <sjennings@variantweb.net>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Nikhil Rao <nikhil.rao@intel.com>,
        Daniel Borkmann <dborkman@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Subject: [PATCH linux-next] Documentation: Build mic/mpssd only for x86_64
Date: Thu,  4 Dec 2014 13:27:29 -0800
Message-Id: <25c04eb72c621fc9bdf0aae25782ff5bad5a4b97.1417728278.git.ashutosh.dixit@intel.com>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mic/mpssd along with MIC drivers are currently only usable on
x86_64. So build mic/mpssd only for x86_64 to avoid build breaks on
big-endian systems.

Reported-by: Daniel Borkmann <dborkman@redhat.com>
Reported-by: Dan Streetman <ddstreet@gmail.com>
Suggested-by: Peter Foley <pefoley2@pefoley.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
---
 Documentation/mic/mpssd/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mic/mpssd/Makefile b/Documentation/mic/mpssd/Makefile
index 0f31568..f47fe6b 100644
--- a/Documentation/mic/mpssd/Makefile
+++ b/Documentation/mic/mpssd/Makefile
@@ -1,5 +1,5 @@
 # List of programs to build
-hostprogs-y := mpssd
+hostprogs-$(CONFIG_X86_64) := mpssd
 
 mpssd-objs := mpssd.o sysfs.o
 
-- 
2.0.0.rc3.2.g998f840

