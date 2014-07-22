Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaGVIKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:10:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:46682 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbaGVIKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:10:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,708,1400050800"; 
   d="scan'208";a="573497420"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v3 0/7] perf, x86: large PEBS interrupt threshold
Date: Tue, 22 Jul 2014 16:09:53 +0800
Message-Id: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements large PEBS interrupt threshold. For some
limited cases, it can significantly reduce the sample overhead. Please
read patch 6's commit message for more information.

changes since v1:
  - drop patch 'perf, core: Add all PMUs to pmu_idr'
  - add comments for case that multiple counters overflow simultaneously
changes since v2:
  - rename perf_sched_cb_{enable,disable} to perf_sched_cb_user_{inc,dec} 
  - use flag to indicate auto reload mechanism
  - move codes that setup PEBS sample data to separate function
  - output the PEBS records in batch 
  - enable this for All (PEBS capable) hardware 
  - more description for the multiplex
