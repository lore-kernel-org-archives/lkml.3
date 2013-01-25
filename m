Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3AYWhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:37:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:4294 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370Ab3AYWdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:33:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,541,1355126400"; 
   d="scan'208";a="195255838"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org
Subject: perf PMU support for Haswell: Extended functionality v1
Date: Fri, 25 Jan 2013 14:32:54 -0800
Message-Id: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on v7 of the earlier combined Haswell PMU patchkit.
The basic functionality has moved into a separate patchkit.
These patches implement more advanced functionality. Most
of the functionality is related to TSX.

This applies on top of the basic hsw/pmu4-basics patchkit posted
separately.

Some of this touches similar areas as Stephane's patchkit, with
some shared patches too.

Available at 
git://git.kernel.org/pub/scm/linux/kernel/ak/linux-misc.git hsw/pmu4

High level overview:

- Easy high level TSX measurement in perf stat -T
- Transaction events and attributes implemented with sysfs enumeration
- Export arch perfmon events in sysfs 
- Generic weightend profiling for memory latency and transaction abort costs.
- Support for address profiling
- KVM support to do basic TSX profiling from guests
- Support for filtering/displaying transaction abort types based on 
PEBS information

For more details on the Haswell PMU please see the SDM. For more details on TSX
please see http://halobates.de/adding-lock-elision-to-linux.pdf

Some of the added features could be added to older CPUs too. I plan
to do this, but in separate patches.

Open:
- Weight sorting does not work (see thread), not a show stopper.

-Andi
