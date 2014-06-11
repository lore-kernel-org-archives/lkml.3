Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaFKPmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:42:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:10495 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801AbaFKPmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:42:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,458,1400050800"; 
   d="scan'208";a="444330413"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [RFC v2 0/7] perf: perf: add AUX space to ring_buffer
Date: Wed, 11 Jun 2014 18:41:43 +0300
Message-Id: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Here's the 2nd go at the AUX area. This covers pretty much what I need
for Intel PT buffer management.

Alexander Shishkin (6):
  perf: add data_{offset,size} to user_page
  perf: support high-order allocations for AUX space
  perf: add a capability for AUX_NO_SG pmus to do software double
    buffering
  perf: add a pmu capability for "exclusive" events
  perf: add api for pmus to write to AUX space
  perf: add AUX record

Peter Zijlstra (1):
  perf: add AUX area to ring buffer for raw data streams

 include/linux/perf_event.h      |  39 ++++++-
 include/uapi/linux/perf_event.h |  36 +++++++
 kernel/events/core.c            | 225 ++++++++++++++++++++++++++++++++++------
 kernel/events/internal.h        |  27 +++++
 kernel/events/ring_buffer.c     | 182 +++++++++++++++++++++++++++++++-
 5 files changed, 475 insertions(+), 34 deletions(-)

-- 
2.0.0

