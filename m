Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaCXTdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:33:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbaCXTdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:15 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/4] perf: Make some functions generic
Date: Mon, 24 Mar 2014 15:32:53 -0400
Message-Id: <1395689577-214654-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch just converts some private functions into global ones
that can be used by other tools like the c2c tool I am trying to merge.

Don Zickus (4):
  perf: Allow ability to map cpus to nodes easily
  perf, kmem: Utilize the new generic cpunode_map
  perf, callchain: Add generic report parse callchain callback function
  perf, report: Use new generic report parse callchain callback

 tools/perf/builtin-kmem.c   |  78 +------------------------
 tools/perf/builtin-report.c |  77 +-----------------------
 tools/perf/util/callchain.c |  83 ++++++++++++++++++++++++++
 tools/perf/util/callchain.h |   1 +
 tools/perf/util/cpumap.c    | 139 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/cpumap.h    |  35 +++++++++++
 6 files changed, 262 insertions(+), 151 deletions(-)

-- 
1.7.11.7

