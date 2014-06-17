Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbaFQNYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:24:06 -0400
Received: from relay.parallels.com ([195.214.232.42]:34342 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaFQNYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:24:04 -0400
Message-ID: <1403011439.27674.43.camel@tkhai>
Subject: [PATCH 0/3] Fix shutdown of cpu which having throttled rq
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <tkhai@yandex.ru>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Mike Galbraith" <umgwanakikbuti@gmail.com>, <khorenko@parallels.com>
Date: Tue, 17 Jun 2014 17:23:59 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a result from discussion "[PATCH 1/2] sched: Rework migrate_tasks()":

	https://lkml.org/lkml/2014/6/11/166

The problem is cfs_rq and rt_rq may stay throttled in the moment
of task migration from dead cpu. This patch fixes that for fair
and RT classes. No fix for deadline class yet, it's coming soon.

Thanks
---

Kirill Tkhai (3):
      sched/fair: Disable runtime_enabled on dying rq
      sched/rt: __disable_runtime: Enqueue just unthrottled rt_rq back on the stack
      sched: Rework check_for_tasks()


 kernel/cpu.c        |   33 ++++++++++++++++++++-------------
 kernel/sched/fair.c |   22 ++++++++++++++++++++++
 kernel/sched/rt.c   |    3 +++
 3 files changed, 45 insertions(+), 13 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>


