Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbaCUIEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:04:40 -0400
Received: from evbyminsa0102.epam.com ([217.21.63.37]:21081 "EHLO
	EVBYMINSA0102.epam.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaCUIEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:04:34 -0400
Date: Fri, 21 Mar 2014 23:02:49 +0300
From: Artem Fetishev <artem_fetishev@epam.com>
To: <peterz@infradead.org>, <jmdavis@link.com>,
        <kosaki.motohiro@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Bug 71331 - mlock yields processor to lower priority process
Message-ID: <20140321200248.GB6264@owamsq.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.6.164.188]
X-ClientProxiedBy: EVBYMINSA0102.epam.com (10.6.110.11) To
 EVBYMINSA0111.epam.com (10.6.110.13)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am looking at a use-case when a real-time task (B) of higher priority is sometimes preempted by another real-time task (A) of lower priority. Well, B is not really preempted. It calls mlockall() which forces task B to yield the CPU. Under certain conditions, mlockall() calls lru_add_drain_all() which schedules a deferred work and wants the calling task to wait until that work is complete by putting the task into TASK_UNINTERRUPTIBLE state and calling schedule_timeout().

Tasks utilize SCHED_FIFO policy.

See details here: https://bugzilla.kernel.org/show_bug.cgi?id=71331

Besides mlockall, there are other kernel paths which make use of lru_add_drain_all() and schedule_timeout(), so I guess there are bunch of other syscalls which may lead to the above use-case.

So the question is: is above use-case an expected behavior of real-time tasks or is it a bug in mlockall (i.e. it should not interrupt a real-time process)?

Thanks,
-Artem
