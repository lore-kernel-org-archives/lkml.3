Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965685Ab3HHO7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:59:39 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:45496 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965294Ab3HHO7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:59:38 -0400
Date: Thu, 8 Aug 2013 14:59:36 +0000
From: Christoph Lameter <cl@gentwo.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2 1/2] mm: make vmstat_update periodic run conditional
In-Reply-To: <CAOtvUMe=QQni4Ouu=P_vh8QSb4ZdnaX_fW1twn3QFcOjYgJBGA@mail.gmail.com>
Message-ID: <000001405e70a92f-3b2a0b89-f807-45d7-af70-9e7292156dd4-000000@email.amazonses.com>
References: <CAOtvUMc5w3zNe8ed6qX0OOM__3F_hOTqvFa1AkdXF0PHvzGZqg@mail.gmail.com> <1371672168-9869-1-git-send-email-gilad@benyossef.com> <0000013f61e7609b-a8d1907b-8169-4f77-ab83-a624a8d0ab4a-000000@email.amazonses.com>
 <CAOtvUMe=QQni4Ouu=P_vh8QSb4ZdnaX_fW1twn3QFcOjYgJBGA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.08-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Aug 2013, Gilad Ben-Yossef wrote:

> vmstat_update runs from the vmstat work queue item by the workqueue
> kernel thread.
>
> If this code is running, it means there are at least two schedulable tasks:
> 1. The workqueue kernel thread, because it is running.
> 2. At least one more task, otherwise were were in idle and the
> workqueue kernel thread
> would not execute this work item.
>
> Unfortunately, having two schedulable tasks means we're not running
> tickless, so the check
> will never trigger - or have I've missed something obvious?

The vmstat update is deferrable work. As such it is not required to run
and can be pushed off. It will not be considered for the calculation of
the next timer interupt. See __next_timer_interrupt().



