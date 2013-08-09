Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966753Ab3HIK2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:28:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966467Ab3HIK2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:28:32 -0400
Date: Fri, 9 Aug 2013 12:28:02 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/3] perf: Rollback callchain buffer refcount under the
 callchain mutex
Message-ID: <20130809102802.GC1045@krava.brq.redhat.com>
References: <1375460996-16329-1-git-send-email-fweisbec@gmail.com>
 <1375460996-16329-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375460996-16329-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 06:29:54PM +0200, Frederic Weisbecker wrote:
> When we fail to allocate the callchain buffers, we rollback the refcount
> we did and return from get_callchain_buffers().
> 
> However we take the refcount and allocate under the callchain lock
> but the rollback is done outside the lock.
> 
> As a result, while we rollback, some concurrent callchain user may
> call get_callchain_buffers(), see the non-zero refcount and give up
> because the buffers are NULL without itself retrying the allocation.
> 
> The consequences aren't that bad but that behaviour looks weird enough and
> it's better to give their chances to the following callchain users where
> we failed.
> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jiri Olsa <jolsa@redhat.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>
