Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab3AQUnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 15:43:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:33895 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab3AQUho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 15:37:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,486,1355126400"; 
   d="scan'208";a="273439801"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org
Subject: perf PMU support for Haswell v7
Date: Thu, 17 Jan 2013 12:36:23 -0800
Message-Id: <1358455012-12287-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Updated version for the latest master tree and fixes.  See end for details.
All feedback addressed. Ready for merging.]

This adds perf PMU support for the upcoming Haswell core. The patchkit 
is fairly large, mainly due to various enhancement for TSX. TSX tuning
relies heavily on the PMU, so I tried hard to make all facilities 
easily available. In addition it also has some other enhancements.

This includes changes to the core perf code, to the x86 specific part,
to the perf user land tools and to KVM

Available at 
git://git.kernel.org/pub/scm/linux/kernel/ak/linux-misc.git hsw/pmu3

High level overview:

- Basic Haswell PMU support
- Easy high level TSX measurement in perf stat -T
- Transaction events and attributes implemented with sysfs enumeration
- Export arch perfmon events in sysfs 
- Generic weightend profiling for memory latency and transaction abort costs.
- Support for address profiling
- Support for filtering events inside/outside transactions
- KVM support to do this from guests
- Support for filtering/displaying transaction abort types based on 
PEBS information
- LBR support for transactions

For more details on the Haswell PMU please see the SDM. For more details on TSX
please see http://halobates.de/adding-lock-elision-to-linux.pdf

Some of the added features could be added to older CPUs too. I plan
to do this, but in separate patches.

v2: Removed generic transaction events and qualifiers and use sysfs
enumeration. Also export arch perfmon, so that the qualifiers work.
Fixed various issues this exposed. Don't use a special macro for the
TSX constraints anymore. Address other review feedback.
Added pdir event in sysfs.

v3: Fix various bugs and address review comments.
tx-aborts instead of cpu/tx-aborts/ works now (with some limitations)
cpu/instructions,intx=1/ works now

v4:
Addressed all review feedback (I hope). See changelog in individual patches.
KVM support now works again with more changes.
Forbid some more flag combinations that don't work well.

v5:
Rebased on latest perf/core. New method for sysfs events.
Obsolete patches dropped. Added one patch from Stephane.
Fixed generic aliases inside cpu//
Improved transaction flags decoding
Addressed all review feedback (except for two minor items in
perf tools from Namhyung)

v6:
Fix WERROR=1 build with latest fixes.
Address KVM feedback. 
Improve transaction flags display.

v7:
Rebase to 3.8-rc3.
Some minor fixes based on feedback.
Fix for spurious NMI added.
Removed debug patch for spurious NMIs.

-Andi
