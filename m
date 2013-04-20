Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3DTTX2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:23:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:51316 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab3DTTT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:19:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="229707687"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: acme@redhat.com, linux-kernel@vger.kernel.org
Subject: perf PMU support for Haswell v8
Date: Sat, 20 Apr 2013 12:19:08 -0700
Message-Id: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a heavily updated version of the Haswell PMU TSX and other
patchkit, on top of the separate "basic haswell" patchkit

This adds perf PMU support for the upcoming Haswell core. The patchkit 
is fairly large, mainly due to various enhancement for TSX. TSX tuning
relies heavily on the PMU, so I tried hard to make all facilities 
easily available. In addition it also has some other enhancements.

Overview:
- perf stat -T to get high level transaction statistics
- A generic set of transaction events
- Support for transaction abort flags to distingush abort types
- Support for transaction abort weight
- Full support for transaction LBR flags
- KVM support to run perf stat -T in a guest
- Full width counters and checkpointed counter support
- Address support for all PEBS events

This includes changes to the core perf code, to the x86 specific part,
to the perf user land tools and to KVM

Available at 
git://git.kernel.org/pub/scm/linux/kernel/ak/linux-misc.git hsw/pmu6

For more details on the Haswell PMU please see the SDM. For more details on TSX
please see http://halobates.de/adding-lock-elision-to-linux.pdf

[dropped old changelog]

-Andi
