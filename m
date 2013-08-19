Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab3HSQN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:13:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36040 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3HSQNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:13:25 -0400
Message-Id: <20130819160058.539049611@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 18:00:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@surriel.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 00/10] Various load-balance cleanups/optimizations -v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After poking at them a little more I feel somewhat more confident.

I found one more bug, but this one was my own fault, we should also clear
sds->busiest_stat.avg_load because update_sd_pick_busiest() reads that before
we set it.

Moved the memset optimization and the fix for that into a separate patch.

Other than that, there's a sched_domain degenerate fix; and a new way to detect
group_imb (which relies on the sched_domain fix).

