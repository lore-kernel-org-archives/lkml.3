Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162529Ab3DEVDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:03:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:40523 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162095Ab3DEVDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:03:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,416,1363158000"; 
   d="scan'208";a="223402316"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, Randy Dunlap <rdunlap@infradead.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v2] RAPL (Running Average Power Limit) driver
Date: Fri,  5 Apr 2013 14:02:03 -0700
Message-Id: <1365195724-8945-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since V2:
	- use 'struct device' instead of raw kobject to represent
	  RAPL domains
	- changed eventfd control interface to use event string
	  instead of passing file descriptors that cannot be
	  authenticated in sysfs directory
	- clean ups based on v1 reviews
		- use kcalloc for arrays
		- drop dependencies on X86
		- misc cleanups

I don have a checkpatch error which I think it is not valid. I can
fix it by avoiding the macro/adding more lines.

ERROR: Macros with complex values should be enclosed in parenthesis
#735: FILE: platform/x86/intel_rapl.c:735:
+#define RO_PRIMITIVE(name)						\
+	primitive_show_fn(name)						\
+	static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL)

If i put parenthesis around it to mute the error then it won't compile.

I attempted to come up with a simple version as Greg suggested to
just expose cooling device but then I realized we could lose many
key functionalities partially due to the correlations among RAPL
control knobs. I am still working on this since it is not as simple as
deleting the advanced interfaces, I would have to do some setup based
on best guesses.

Jacob Pan (1):
  Introduce Intel RAPL cooling device driver

 Documentation/ABI/testing/sysfs-class-intel-rapl |  121 ++
 drivers/platform/x86/Kconfig                     |    9 +
 drivers/platform/x86/Makefile                    |    1 +
 drivers/platform/x86/intel_rapl.c                | 1285 ++++++++++++++++++++++
 drivers/platform/x86/intel_rapl.h                |  244 ++++
 5 files changed, 1660 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-intel-rapl
 create mode 100644 drivers/platform/x86/intel_rapl.c
 create mode 100644 drivers/platform/x86/intel_rapl.h

-- 
1.7.9.5

