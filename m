Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3EVJOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:14:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37976 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3EVJOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:14:54 -0400
Date: Wed, 22 May 2013 11:14:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
Message-ID: <20130522091449.GD18810@twins.programming.kicks-ass.net>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
 <1368674141-10796-3-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368674141-10796-3-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:15:34PM -0400, Sasha Levin wrote:
> kernel/lockdep.c deals with validating locking scenarios for
> various architectures supported by the kernel. There isn't
> anything kernel specific going on in lockdep, and when we
> compare userspace to other architectures that don't have to deal
> with irqs such as s390, they become all too similar.
> 
> We wrap kernel/lockdep.c and include/linux/lockdep.h with
> several headers which allow us to build and use lockdep from
> userspace. We don't touch the kernel code itself which means
> that any work done on lockdep in the kernel will automatically
> benefit userspace lockdep as well!
> 
> +
> +#ifndef CALLER_ADDR0
> +#define _THIS_IP_ CALLER_ADDR0
> +#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> +#endif

Why are you making _THIS_IP_ equal to _RET_IP_ ?
