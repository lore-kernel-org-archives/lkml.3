Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3LQJ6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:58:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37537 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3LQJ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:58:11 -0500
Date: Tue, 17 Dec 2013 10:58:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] pid: change task_struct::pid to read-only
Message-ID: <20131217095801.GF21999@twins.programming.kicks-ass.net>
References: <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com>
 <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 04:03:38PM -0500, Richard Guy Briggs wrote:
> task->pid is only ever assigned once (well ok, twice).  For system health and
> secure logging confidence, make it const to make it much more intentional when
> it is being changed.
> ---
> 
> Peter, as you had suggested, does this approach work for you in terms of making
> task_struct::pid a lot more difficult to accidentally change to try to preserve
> its integrity?

Yeah, looks good to me.

> Is the use of memcpy() significantly different from *p = *q ?

You'd have to look at the asm, but I suspect gcc knows to do full struct
copies using mempcy.
