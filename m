Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab3IBG0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 02:26:47 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:56541 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3IBG0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:26:46 -0400
MIME-Version: 1.0
Date: Mon, 2 Sep 2013 14:26:45 +0800
Message-ID: <CALZhoST+i8TOfQtu-z-bFrwmAVERZ6gHO1k_M_J24se8Hq_qyw@mail.gmail.com>
Subject: Question regarding list_for_each_entry_safe usage in move_one_task
From: Lei Wen <adrian.wenl@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        mingo@redhat.com, leiwen@marvell.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I find one list API usage may not be correct in current fair.c code.
In move_one_task function, it may iterate through whole cfs_tasks
list to get one task to move.

But in dequeue_task(), it would delete one task node from list
without the lock protection. So that we could see from
list_for_each_entry_safe API definitoin:

#define list_for_each_entry_safe(pos, n, head, member)
 \
        for (pos = list_entry((head)->next, typeof(*pos), member),      \
                n = list_entry(pos->member.next, typeof(*pos),
member); \
             &pos->member != (head);                                    \
             pos = n, n = list_entry(n->member.next, typeof(*n), member))

As this task node may be listed in the middle of this queue chain, it
may lead to error of searching for the next node when iterating.

Would this be possible to happen? Please help to comment it.

Thanks,
Lei
