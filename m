Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbaISPas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:30:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:60855 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626AbaISPar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:30:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,555,1406617200"; 
   d="scan'208";a="605437150"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: sparse@chrisli.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Rustad <mark.d.rustad@intel.com>
Subject: [PATCH 0/7] Silence even more W=2 warnings
Date: Fri, 19 Sep 2014 08:29:33 -0700
Message-Id: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches silence over 100,000 warnings in a W=2
kernel build. This series does most of it by using the compilers
diagnostic controls. The first patch in the series adds macros to
invoke the pragmas for those controls. Macros are provided for GCC
and clang. Although they are highly compatible in this area, macros
are provided for compiler-specific controls, and there is one
example that uses a clang-specific control (look for DIAG_CLANG_IGNORE).

Some missing-field-initializers warnings were resolved using
the diagnostic control macros simply because so many lines
would have had to have been changed. At this stage Mark thought 
about avoiding possible merge issues. If the maintainer would 
rather resolve them by using designated initialization, just 
say so.

The combined effect of this patch series and his other patches
that did not use these diagnostic control macros was to reduce 
the number of W=2 warnings from 127,164 to 1,345!

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Mark Rustad (7):
  compiler: Add diagnostic control macros
  x86: Silence initializer-overrides warnings
  atomic: Silence nested-externs warnings
  bitops: Silence nested-externs warnings
  signal: Silence nested-externs warnings
  mm: Silence nested-externs warnings
  sched: Silence nested-externs warnings

 arch/x86/ia32/syscall_ia32.c   |  2 ++
 include/linux/atomic.h         |  2 ++
 include/linux/bitops.h         |  2 ++
 include/linux/compiler-clang.h | 26 ++++++++++++++++++++++++++
 include/linux/compiler-gcc4.h  | 31 +++++++++++++++++++++++++++++++
 include/linux/compiler.h       | 20 ++++++++++++++++++++
 include/linux/mm.h             |  2 ++
 include/linux/sched.h          |  2 ++
 include/linux/signal.h         |  6 ++++++
 9 files changed, 93 insertions(+)

-- 
1.9.3

