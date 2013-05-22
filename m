Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab3EVJMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:12:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37875 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab3EVJL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:11:59 -0400
Date: Wed, 22 May 2013 11:11:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] kernel/sched/core.c: need return NULL when BUG() is
 defined as empty.
Message-ID: <20130522091156.GC18810@twins.programming.kicks-ass.net>
References: <5199D565.4070307@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5199D565.4070307@asianux.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 03:48:53PM +0800, Chen Gang wrote:
> 
> When neither CONFIG_BUG nor HAVE_ARCH_BUG is defined, need let function
> return failure value ('NULL') instead of random value.

What will such a kernel do? Happily continue running whenever we hit a
BUG? that seems like a particularly bad idea. Should we not have a stub
BUG() function like:

void BUG(void) __attribute__((noreturn))
{
	local_irq_disable();
	while (1) ;
}

Which would at least halt things?
