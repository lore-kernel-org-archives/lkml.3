Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbaGaGpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:45:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:8726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbaGaGpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:45:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="578059800"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v4 0/9] perf, x86: large PEBS interrupt threshold
Date: Thu, 31 Jul 2014 14:44:55 +0800
Message-Id: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
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
changes since v3:
  - ignore conflicting PEBS record
