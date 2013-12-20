Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab3LTI65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:58:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49697 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab3LTI64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:58:56 -0500
Date: Fri, 20 Dec 2013 09:58:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] pid: change task_struct::pid to read-only
Message-ID: <20131220085846.GA21999@twins.programming.kicks-ass.net>
References: <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com>
 <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
 <20131217095801.GF21999@twins.programming.kicks-ass.net>
 <20131220044826.GF14944@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220044826.GF14944@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 11:48:26PM -0500, Richard Guy Briggs wrote:
> On 13/12/17, Peter Zijlstra wrote:
> > On Mon, Dec 16, 2013 at 04:03:38PM -0500, Richard Guy Briggs wrote:
> > > task->pid is only ever assigned once (well ok, twice).  For system health and
> > > secure logging confidence, make it const to make it much more intentional when
> > > it is being changed.
> > > ---
> > > 
> > > Peter, as you had suggested, does this approach work for you in terms of making
> > > task_struct::pid a lot more difficult to accidentally change to try to preserve
> > > its integrity?
> > 
> > Yeah, looks good to me.
> 
> Ok, who would carry this patch?  You?  AKPM?  Me?

Andrew seems to be the him who carries PID stuff. I don't think I can make
a case that its scheduler related.

> Any opinions about Oleg's macro idea?

I'm undecided.. on the one hand the macro makes it too easy to change
const stuff, on the other hand it makes it explicit and easily
greppable.


