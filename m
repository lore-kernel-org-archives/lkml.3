Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab3AODzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:55:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58550 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3AODza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:55:30 -0500
Message-ID: <1358222122.25910.25.camel@marge.simpson.net>
Subject: Re: [PATCH] sched_rt: Use root_domain of rt_rq not current processor
From: Mike Galbraith <bitbucket@online.de>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: peterz@infradead.org, mingo@elte.hu, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Jan 2013 04:55:22 +0100
In-Reply-To: <1358186131-29494-1-git-send-email-sbohrer@rgmadvisors.com>
References: <1357884213.5716.35.camel@marge.simpson.net>
	 <1358186131-29494-1-git-send-email-sbohrer@rgmadvisors.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:LvrrOoiaV6R82hc+hC4yJ57CTIaJ91dfBM0M3mrK3Ys
 Maw2YuhFvC02MW3C0uz2M5PB9n1iwn00NRHdvtv+KEMMA9T1Tr
 hK6ByL+kgnWsGZzhBpiX5vPKBB/+Dvl38phUEVxBDOWHAAsJOO
 NW4Z5vJ+K3yxCL07PbzaiOzzWrzT+xvMHTqPjbN8VxgjyHKbEs
 S0SxlRD5i39TvihGuu9dFEoWCRPfmcTbfpOVwpSPr1t03Avuik
 G0YaMPpNoymluVZxz9gTiph49/i+EG7jYHVGtqSIXJAIQEOyG0
 kfeHLyVdTu7a3HSckPbWJs4huHYq+ousy5seXU+g3HUpXkTgum
 MUKWcG/Rs4ZSWCHZOnKYUPhit2TMWKIA1cfoQkZibtmJHnCXJt
 e/ejQX2zzFQuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-14 at 11:55 -0600, Shawn Bohrer wrote: 
> When the system has multiple domains do_sched_rt_period_timer() can run
> on any CPU and may iterate over all rt_rq in cpu_online_mask.  This
> means when balance_runtime() is run for a given rt_rq that rt_rq may be
> in a different rd than the current processor.  Thus if we use
> smp_processor_id() to get rd in do_balance_runtime() we may borrow
> runtime from a rt_rq that is not part of our rd.
> 
> This changes do_balance_runtime to get the rd from the passed in rt_rq
> ensuring that we borrow runtime only from the correct rd for the given
> rt_rq.
> 
> This fixes a BUG at kernel/sched/rt.c:687! in __disable_runtime when we
> try reclaim runtime lent to other rt_rq but runtime has been lent to
> a rt_rq in another rd.

Ah, so there was only one cpu in span when the bug fired in your case.
Good fix.  Damn throttle bugs are at least as deadly as the bugs the
thing tries to protect you from.  (Yet) another one bites the dust ;-)

> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>

That wants a Cc: stable@vger.kernel.org too.

-Mike

