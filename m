Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965792Ab3E2LPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:15:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51388 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965590Ab3E2LPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:15:20 -0400
Date: Wed, 29 May 2013 13:15:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/9] liblockdep: Support using LD_PRELOAD
Message-ID: <20130529111515.GG12193@twins.programming.kicks-ass.net>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
 <1368674141-10796-8-git-send-email-sasha.levin@oracle.com>
 <20130522092453.GH18810@twins.programming.kicks-ass.net>
 <51A50708.3000203@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A50708.3000203@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 03:35:36PM -0400, Sasha Levin wrote:
> On 05/22/2013 05:24 AM, Peter Zijlstra wrote:
> > Do we still need this with the glibc __pthread_* static initialization?
> 
> Sadly we do.
> 
> We need to deal with the two things that cause allocation in our code (because
> they loop back into our code via malloc()->malloc_init()->pthread_mutex_init() ).
> 
> The first one was the glibc trick to avoid the malloc() caused by dlsym(). The
> second one is the malloc() we do when we allocate new lock. Static allocation
> deals with that one.

OK.. fair enough
