Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaJQHaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:30:11 -0400
Received: from shelob.surriel.com ([74.92.59.67]:35985 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbaJQHaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:30:06 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: chegu_vinod@hp.com, peterz@infradead.org, mingo@redhat.com,
        mgorman@suse.de
Subject: [PATCH 0/6] sched,numa: weigh nearby nodes for task placement on complex NUMA topologies (v2)
Date: Fri, 17 Oct 2014 03:29:48 -0400
Message-Id: <1413530994-9732-1-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set integrates two algorithms I have previously tested,
one for glueless mesh NUMA topologies, where NUMA nodes communicate
with far-away nodes through intermediary nodes, and backplane
topologies, where communication with far-away NUMA nodes happens
through backplane controllers (which cannot run tasks).

Due to the inavailability of 8 node systems, and the fact that I
am flying out to Linuxcon Europe / Plumbers / KVM Forum on Friday,
I have not tested these patches yet. However, with a conference (and
many familiar faces) coming up, it seemed like a good idea to get
the code out there, anyway.

Vinod tested the v1 series + patch 6 on a backplane topology
system, and I changed v2 on a glueless mesh topology system.
The patches appear to behave.

Placement of tasks on smaller, directly connected, NUMA systems
should not be affected at all by this patch serie


v2: remove the hops table, and use numa_distance instead, tested
    on a system with glueless mesh topology, not yet tested on
    a backplane style system (but the algorithm should be unchanged)


