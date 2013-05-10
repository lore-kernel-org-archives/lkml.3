Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3EJN7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:59:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59067
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984Ab3EJN7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:59:45 -0400
Date: Fri, 10 May 2013 15:58:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/9] liblockdep: Wrap kernel/lockdep.c to allow usage
 from userspace
Message-ID: <20130510135811.GB304@dyad.programming.kicks-ass.net>
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com>
 <1368115089-8909-3-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368115089-8909-3-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 11:58:02AM -0400, Sasha Levin wrote:
> +#ifndef CALLER_ADDR0
> +#define _THIS_IP_ CALLER_ADDR0
> +#define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
> +#endif

That's wrong.. _THIS_IP_ should be the address of 'here'. What you have there is _RET_IP_.


