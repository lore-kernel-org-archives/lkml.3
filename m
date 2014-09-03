Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbaICLcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:32:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbaICLcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:32:13 -0400
Date: Wed, 3 Sep 2014 13:32:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Cong Wang <cwang@twopensource.com>
Subject: Re: [Patch v2] perf_event: fix a race condition in
 perf_remove_from_context()
Message-ID: <20140903113205.GN4783@worktop.ger.corp.intel.com>
References: <1409696840-843-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409696840-843-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 03:27:20PM -0700, Cong Wang wrote:
> From: Cong Wang <cwang@twopensource.com>
> 
> We saw a kernel soft lockup in perf_remove_from_context(),
> it looks like the `perf` process, when exiting, could not go
> out of the retry loop. Meanwhile, the target process was forking
> a child. So either the target process should execute the smp
> function call to deactive the event (if it was running) or it should
> do a context switch which deactives the event.
> 
> It seems we optimize out a context switch in perf_event_context_sched_out(),
> and what's more important, we still test an obsolete task pointer when
> retrying, so no one actually would deactive that event in this situation.
> Fix it directly by reloading the task pointer in perf_remove_from_context().
> This should cure the above soft lockup.
> 
> Cc: stable@vger.kernel.org
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Signed-off-by: Cong Wang <cwang@twopensource.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks!
