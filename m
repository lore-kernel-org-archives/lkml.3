Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab3HUAUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:20:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:55874 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab3HUAUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:20:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,923,1367996400"; 
   d="scan'208";a="390573751"
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Mike Frysinger <vapier@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v2 0/8] turbostat: Build fixes, 32-bit support, and cleanups
Date: Tue, 20 Aug 2013 17:20:11 -0700
Message-Id: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.8.4.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series includes build fixes, warning fixes, and cleanups discovered
while adding turbostat to ChromeOS.

The first and third patches should go into stable, and I've CCed them
accordingly.

The first patch unbreaks the turbostat build on systems
with older versions of kernel headers.

The third patch is required to build on 32-bit x86.

The second and fourth patches fix warnings.

Patches 5-7 are code cleanups, and the last patch adds turbostat itself to
.gitignore.

Josh Triplett (8):
  turbostat: Don't put unprocessed uapi headers in the include path
  turbostat: Don't attempt to printf an off_t with %zx
  turbostat: Use GCC's CPUID functions to support PIC
  turbostat: Check return value of fscanf
  turbostat: Add a helper to parse a single int out of a file
  turbostat: Factor out common function to open file and exit on failure
  turbostat: Clean up error handling; disambiguate error messages; use
    err and errx
  turbostat: Add a .gitignore to ignore the compiled turbostat binary

 tools/power/x86/turbostat/.gitignore  |   1 +
 tools/power/x86/turbostat/Makefile    |   2 +-
 tools/power/x86/turbostat/turbostat.c | 210 +++++++++++++---------------------
 3 files changed, 82 insertions(+), 131 deletions(-)
 create mode 100644 tools/power/x86/turbostat/.gitignore

-- 
1.8.4.rc3

