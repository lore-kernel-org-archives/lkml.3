Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997Ab3EBT4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:56:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:30300 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761345Ab3EBT4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:56:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,597,1363158000"; 
   d="scan'208";a="331473246"
Message-ID: <1367524609.19739.8.camel@ideak-mobl>
Subject: Re: [PATCH] wait: fix false timeouts when using wait_event_timeout()
From: Imre Deak <imre.deak@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: David Howells <dhowells@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 02 May 2013 22:56:49 +0300
In-Reply-To: <20130502123517.GL7800@kernel.dk>
References: <1367485129-4423-1-git-send-email-imre.deak@intel.com>
	 <3633.1367497784@warthog.procyon.org.uk> <20130502123517.GL7800@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 14:35 +0200, Jens Axboe wrote:
> On Thu, May 02 2013, David Howells wrote:
> > Imre Deak <imre.deak@intel.com> wrote:
> > 
> > > Many callers of the wait_event_timeout() and
> > > wait_event_interruptible_timeout() expect that the return value will be
> > > positive if the specified condition becomes true before the timeout
> > > elapses. However, at the moment this isn't guaranteed. If the wake-up
> > > handler is delayed enough, the time remaining until timeout will be
> > > calculated as 0 - and passed back as a return value - even if the
> > > condition became true before the timeout has passed.
> > > 
> > > Fix this by returning at least 1 if the condition becomes true. This
> > > semantic is in line with what wait_for_condition_timeout() does; see
> > > commit bb10ed09 - "sched: fix wait_for_completion_timeout() spurious
> > > failure under heavy load".
> > > 
> > > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > 
> > Acked-by: David Howells <dhowells@redhat.com>
> 
> You can add mine, too:
> 
> Acked-by: Jens Axboe <axboe@kernel.dk>

Ok, I think we agree that the +1 thing in schedule_timeout() discussed
in this thread should be handled separately, so if there is no other
objection I'd be happy if this patch was merged through someone's tree
as-is.

--Imre


