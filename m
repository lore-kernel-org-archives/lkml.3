Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaDGS4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:56:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926AbaDGSzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:55:38 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, namhyung@gmail.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/4 v2] perf: Make some functions generic
Date: Mon,  7 Apr 2014 14:55:20 -0400
Message-Id: <1396896924-129847-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just converts some private functions into global ones
that can be used by other tools like the c2c tool I am trying to merge.

Don Zickus (4):
  perf: Allow ability to map cpus to nodes easily
  perf: Use cpu/possible instead of cpu/kernel_max
  perf, kmem: Utilize the new generic cpunode_map
  perf, callchain: Add generic report parse callchain callback function

 tools/perf/builtin-kmem.c   |  78 +----------------------
 tools/perf/builtin-report.c |  81 +-----------------------
 tools/perf/util/callchain.c |  82 ++++++++++++++++++++++++
 tools/perf/util/callchain.h |   1 +
 tools/perf/util/cpumap.c    | 149 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/cpumap.h    |  35 +++++++++++
 6 files changed, 273 insertions(+), 153 deletions(-)

-- 
1.7.11.7

