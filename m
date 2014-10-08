Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaJHTiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:38:08 -0400
Received: from shelob.surriel.com ([74.92.59.67]:34528 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaJHTiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:38:03 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: [PATCH RFC 0/5] sched,numa: task placement with complex NUMA topologies
Date: Wed,  8 Oct 2014 15:37:25 -0400
Message-Id: <1412797050-8903-1-git-send-email-riel@redhat.com>
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

The algorithms have been tested before, on both kinds of system.
The new thing about this series is that both algorithms have been
integrated into the same code base, and new code to select the
preferred_nid for tasks in numa groups.

Placement of tasks on smaller, directly connected, NUMA systems
should not be affected at all by this patch series.

I am interested in reviews, as well as test results on larger
NUMA systems :)

