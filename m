Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaIVGyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 02:54:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbaIVGyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 02:54:21 -0400
Date: Mon, 22 Sep 2014 07:54:17 +0100
From: Mel Gorman <mgorman@suse.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/numa: kill the wrong/dead TASK_DEAD check in
 task_numa_fault()
Message-ID: <20140922065417.GB17501@suse.de>
References: <20140921194743.GA30114@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140921194743.GA30114@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 09:47:43PM +0200, Oleg Nesterov wrote:
> current->state == TASK_DEAD means that the task is doing its last
> schedule(), page fault is obviously impossible at this stage.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I was going to complain that the check would protect against a spurious
allocation during fault but a task in this state should not be faulting
any more.

Acked-by: Mel Gorman <mgorman@suse.de>

Thanks.

-- 
Mel Gorman
SUSE Labs
