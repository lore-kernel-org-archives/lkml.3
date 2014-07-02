Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbaGBTBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:01:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249AbaGBTBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:01:00 -0400
Date: Wed, 2 Jul 2014 20:59:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] rcu: uninline rcu_read_lock_held()
Message-ID: <20140702185915.GA18357@redhat.com>
References: <20140630161837.GA15873@redhat.com> <20140630202420.GG4603@linux.vnet.ibm.com> <20140701145523.GA12547@redhat.com> <20140702153901.GA9535@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702153901.GA9535@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Oleg Nesterov wrote:
>
> And this naturally suggests that rcu_read_lock_held() should be uninlined
> too (and rcu_read_lock_sched_held(), but this needs another patch).
>
> But I still can't understand the difference reported by "size vmlinux",
>
> 	- 5541731 3014560 14757888 23314179
> 	+ 5513182 3026848 14757888 23297918
>
> it removes 28K from .text, but somehow it adds 12K to .data. I do not
> see any difference in .data when I compare individual .o files before/
> after this patch.

OK, it doesn't add to .data. This is because of INIT_TASK_DATA(THREAD_SIZE)
in vmlinux.lds.S, see the changelog.

If you think this makes sense I will will spam you again. We can also
uninline rcu_read_lock_sched_held(), mostly for consistency. But this
needs a separate change.

Oleg.

