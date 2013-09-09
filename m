Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3IILPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:15:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48238 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3IILPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:15:22 -0400
Date: Mon, 9 Sep 2013 13:15:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, leiwen@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: Question regarding list_for_each_entry_safe usage in
 move_one_task
Message-ID: <20130909111508.GO31370@twins.programming.kicks-ass.net>
References: <CALZhoST+i8TOfQtu-z-bFrwmAVERZ6gHO1k_M_J24se8Hq_qyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoST+i8TOfQtu-z-bFrwmAVERZ6gHO1k_M_J24se8Hq_qyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 02:26:45PM +0800, Lei Wen wrote:
> Hi Peter,
> 
> I find one list API usage may not be correct in current fair.c code.
> In move_one_task function, it may iterate through whole cfs_tasks
> list to get one task to move.
> 
> But in dequeue_task(), it would delete one task node from list
> without the lock protection. So that we could see from
> list_for_each_entry_safe API definitoin:

Both sites hold the required rq->lock.
