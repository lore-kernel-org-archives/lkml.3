Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965192AbaDKRYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:24:31 -0400
Received: from shelob.surriel.com ([74.92.59.67]:48410 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaDKRY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:24:28 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, chegu_vinod@hp.com,
        mgorman@suse.de
Subject: [PATCH 0/3] sched,numa: reduce page migrations with pseudo-interleaving
Date: Fri, 11 Apr 2014 13:00:26 -0400
Message-Id: <1397235629-16328-1-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pseudo-interleaving code deals fairly well with the placement
of tasks that are part of workloads that span multiple NUMA nodes,
but the code has a number of corner cases left that can result in
higher than desired overhead.

This patch series reduces the overhead slightly, mostly visible
through a lower number of page migrations, while leaving the
throughput of the workload essentially unchanged.

On smaller NUMA systems, these patches should have little or no
effect. On a 4 node test system, I did see a reduction in the
number of page migrations running SPECjbb2005; autonuma-benchmark
appears to be unaffected.

NUMA page migrations on an 8 node system running SPECjbb2005,
courtesy of Vinod:

			vanilla		with patch
8 - 1 socket wide:	9138324		8918971
4 - 2 socket wide:	8239914		7315148
2 - 4 socket wide:	5732744		3849624
1 - 8 socket wide:	3348475		2660347 

