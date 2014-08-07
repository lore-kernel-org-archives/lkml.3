Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaHGXwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 19:52:13 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:46671 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHGXwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 19:52:07 -0400
Message-ID: <1407455524.2513.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 0/7] locking/rwsem: enable reader opt-spinning &
 writer respin
From: Davidlohr Bueso <davidlohr@hp.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Date: Thu, 07 Aug 2014 16:52:04 -0700
In-Reply-To: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-07 at 18:26 -0400, Waiman Long wrote:
> v1->v2:
>  - Remove patch 1 which changes preempt_enable() to
>    preempt_enable_no_resched().
>  - Remove the RWSEM_READ_OWNED macro and assume readers own the lock
>    when owner is NULL.
>  - Reduce the spin threshold to 64.

So I still don't like this, and the fact that it is used in some
virtualization locking bits doesn't really address the concerns about
arbitrary logic in our general locking code.

Also, why did you reduce it from 100 to 64? This very much wants to be
commented.

Thanks,
Davidlohr

