Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab3EBMfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:35:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48306 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759266Ab3EBMfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:35:38 -0400
Date: Thu, 2 May 2013 14:35:17 +0200
From: Jens Axboe <axboe@kernel.dk>
To: David Howells <dhowells@redhat.com>
Cc: Imre Deak <imre.deak@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wait: fix false timeouts when using wait_event_timeout()
Message-ID: <20130502123517.GL7800@kernel.dk>
References: <1367485129-4423-1-git-send-email-imre.deak@intel.com>
 <3633.1367497784@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3633.1367497784@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02 2013, David Howells wrote:
> Imre Deak <imre.deak@intel.com> wrote:
> 
> > Many callers of the wait_event_timeout() and
> > wait_event_interruptible_timeout() expect that the return value will be
> > positive if the specified condition becomes true before the timeout
> > elapses. However, at the moment this isn't guaranteed. If the wake-up
> > handler is delayed enough, the time remaining until timeout will be
> > calculated as 0 - and passed back as a return value - even if the
> > condition became true before the timeout has passed.
> > 
> > Fix this by returning at least 1 if the condition becomes true. This
> > semantic is in line with what wait_for_condition_timeout() does; see
> > commit bb10ed09 - "sched: fix wait_for_completion_timeout() spurious
> > failure under heavy load".
> > 
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> 
> Acked-by: David Howells <dhowells@redhat.com>

You can add mine, too:

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

