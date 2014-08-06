Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaHFNTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:19:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaHFNTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:19:24 -0400
From: Mel Gorman <mgorman@suse.de>
To: Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Nicolas Pitre <nico@linaro.org>
Cc: Mike Galbraith <mgalbraith@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 0/4] Reduce overhead of menu governor
Date: Wed,  6 Aug 2014 14:19:17 +0100
Message-Id: <1407331161-4642-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The menu_select function is heavy and is very noticable in profiles for
workloads that enter/leave idle state a lot. This primarily happens
for scheduler microbenchmarks. The biggest contibution is the standard
deviation calculations and comparisons but the excessive calls into
the scheduler core do not help.

It would be nice to reduce the number of times nr_iowait is checked to
once per 8 intervals but I was not sure how to measure what the general
impact of such a change could be.

Similiarly I looked at different ways the standard deviation could be
calculated but the standard equivalent calculations potentially overflow.
It could be done as rolling average and rolling deviation but again
it was unclear how that could be evaluated. Tips on how the goodness/badness
of governor changes are evalated would be nice.

In the meantime, here are patches against some  of the obvious stuff.

 drivers/cpuidle/governors/menu.c | 43 +++++++++++++++++++++-------------------
 include/linux/sched.h            |  3 +--
 kernel/sched/core.c              |  7 +++++++
 kernel/sched/proc.c              |  7 -------
 4 files changed, 31 insertions(+), 29 deletions(-)

-- 
1.8.4.5

