Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbaCNWR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:17:27 -0400
Received: from forward4h.mail.yandex.net ([84.201.186.22]:59065 "EHLO
	forward4h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbaCNWR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:17:26 -0400
X-Yandex-Uniq: 34357a0c-117b-4e13-a478-bb5aab40125f
Authentication-Results: smtp1h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1394835217.18748.26.camel@HP-250-G1-Notebook-PC>
Subject: [PATCH 0/4] sched/rt: Substract number throttled rt_rq's tasks from
 rq->nr_running
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 15 Mar 2014 02:13:37 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset makes RT class to fit generic scheme, which is used in fair and
deadline classes.

Number of tasks of throttled rt_rq and its children is being decremented from
rq->nr_running, when rt_rq becomes throlled.

---

Kirill Tkhai (4):
      sched/rt: Sum number of all children tasks in hierarhy at rt_nr_running
      sched/rt: Add accessors rq_of_rt_se()
      sched/rt: Substract number of tasks of throttled queues from rq->nr_running
      sched: Revert commit 4c6c4e38c4e9


 kernel/sched/fair.c  |    4 --
 kernel/sched/rt.c    |  115 +++++++++++++++++++++++++++++++++++++++++++-------
 kernel/sched/sched.h |   14 +-----
 3 files changed, 102 insertions(+), 31 deletions(-)

-- 
Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>


