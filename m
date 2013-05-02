Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab3EBM3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:29:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758558Ab3EBM3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:29:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1367485129-4423-1-git-send-email-imre.deak@intel.com>
References: <1367485129-4423-1-git-send-email-imre.deak@intel.com>
To: Imre Deak <imre.deak@intel.com>
Cc: dhowells@redhat.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wait: fix false timeouts when using wait_event_timeout()
Date: Thu, 02 May 2013 13:29:44 +0100
Message-ID: <3633.1367497784@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imre Deak <imre.deak@intel.com> wrote:

> Many callers of the wait_event_timeout() and
> wait_event_interruptible_timeout() expect that the return value will be
> positive if the specified condition becomes true before the timeout
> elapses. However, at the moment this isn't guaranteed. If the wake-up
> handler is delayed enough, the time remaining until timeout will be
> calculated as 0 - and passed back as a return value - even if the
> condition became true before the timeout has passed.
> 
> Fix this by returning at least 1 if the condition becomes true. This
> semantic is in line with what wait_for_condition_timeout() does; see
> commit bb10ed09 - "sched: fix wait_for_completion_timeout() spurious
> failure under heavy load".
> 
> Signed-off-by: Imre Deak <imre.deak@intel.com>

Acked-by: David Howells <dhowells@redhat.com>
