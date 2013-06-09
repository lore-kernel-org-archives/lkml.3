Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3FIP7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 11:59:39 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:37212 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3FIP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 11:59:38 -0400
MIME-Version: 1.0
Date: Sun, 9 Jun 2013 23:59:36 +0800
Message-ID: <CALZhoSSEfXyojD70cannzG9NxvqXTw6r_L5bxT9Ew+JbFhuxKg@mail.gmail.com>
Subject: Question regarding put_prev_task in preempted condition
From: Lei Wen <adrian.wenl@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

While I am checking the preempt related code, I find a interesting part.
That is when preempt_schedule is called, for its preempt_count be added
PREEMPT_ACTIVE, so in __schedule() it could not be dequeued from rq
by deactivate_task.

Thus in put_prev_task, which is called a little later in __schedule(), it
would call put_prev_task_fair, which finally calls put_prev_entity.
For current task is not dequeued from rq, so in this function, it would
enqueue it again to the rq by __enqueue_entity.

Is there any reason to do like this, since entity already is over rq,
why need to queue it again?

And if current rq's vruntime distribution like below, and vruntime with 8
is the task that would be get preempted. So in __enqueue_entity,
its rb_left/rb_right would be set as NULL and reinserted into this RB tree.
Then seems to me now, the entity with vruntime of 3 would be disappeared
from the RB tree.
            13
           /  \
         8    19
        /  \
      3    11

I am not sure whether I understand the whole process correctly...
Would the example as above happen in our real life?

Thanks,
Lei
