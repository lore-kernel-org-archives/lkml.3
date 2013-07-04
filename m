Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3GDFgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:36:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:24897 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab3GDFgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:36:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,992,1363158000"; 
   d="scan'208";a="360319187"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, hpa@linux.intel.com, tim.c.chen@linux.intel.com
Cc: linux-kernel@vger.kernel.org, andi.kleen@intel.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu
Subject: [URGENT rfc patch 0/3] tsc clocksource bug fix
Date: Thu,  4 Jul 2013 13:34:13 +0800
Message-Id: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We find some benchmarks drop a lot on tip/sched/core on many Intel boxes,
like oltp, tbench, hackbench etc. and bisected the commit 5d33b883ae
cause this regression. Due to this commit, the clocksource was changed
to hpet from tsc even tsc will be set CLOCK_SOURCE_VALID_FOR_HRES later
in clocksource_watchdog. 

Tim Chen said the hpet reading cost much. That cause this regression.

This patchset fixed this bug by re-select clocksource after this flag set
on tsc.

BTW,
If the tsc is marked as constant and nonstop, could we set it as system
clocksource when do tsc register? w/o checking it on clocksource_watchdog?

regards!
Alex

