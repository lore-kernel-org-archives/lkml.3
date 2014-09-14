Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaINJOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 05:14:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:41851 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaINJOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 05:14:45 -0400
Date: Sun, 14 Sep 2014 11:14:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/3] perf: Do not POLLHUP event if it has children
Message-ID: <20140914091440.GO346@worktop.programming.kicks-ass.net>
References: <1410520708-19275-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410520708-19275-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 01:18:26PM +0200, Jiri Olsa wrote:
> Currently we return POLLHUP in event polling if the monitored
> process is done, but we didn't consider possible children,
> that might be still running and producing data.
> 
> Before returning POLLHUP making sure that
>    1) the monitored task has exited and that
>    2) we don't have any children to monitor
> 
> Also adding parent wakeup when the child event is gone.
> 
> Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Thanks Jiri (for all three patches)!
