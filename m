Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbaDIRR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:17:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49432 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbaDIRR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:17:58 -0400
Date: Wed, 9 Apr 2014 19:16:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/5] sched: Convert thread_group_cputime() to use
 for_each_thread()
Message-ID: <20140409171607.GA13498@dyad.arnhem.chello.nl>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
 <1397059882-23063-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397059882-23063-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 06:11:18PM +0200, Frederic Weisbecker wrote:
> do_each_thread/while_each_thread iterators are deprecated by
> for_each_thread/for_each_process_thread() APIs.
> 
> Lets convert the callers in the cputime code accounting. The ultimate
> goal is to remove the struct task_struct::thread_group field and
> the corresponding do_each_thread/while_each_thread iterators that are
> RCU unsafe.
> 
> It also makes thread_group_cputime() eventually RCU-safe.

this fails to explain how the current code is broken.
