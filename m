Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab3EBJg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 05:36:58 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:36172 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3EBJg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 05:36:57 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1367485129-4423-1-git-send-email-imre.deak@intel.com>
References: <1367485129-4423-1-git-send-email-imre.deak@intel.com>
Date: Thu, 2 May 2013 11:36:56 +0200
Message-ID: <CAKMK7uEL0kbS1j=gEu_GzUevseeKQ6JuZWPptr96JumCYurfnQ@mail.gmail.com>
Subject: Re: [PATCH] wait: fix false timeouts when using wait_event_timeout()
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Imre Deak <imre.deak@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Lukas Czerner <lczerner@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 10:58 AM, Imre Deak <imre.deak@intel.com> wrote:
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

We have 3 instances of this bug in drm/i915. One case even where we
switch between the interruptible and not interruptible
wait_event_timeout variants, foolishly presuming they have the same
semantics. I very much like this.

Acked-by:  Daniel Vetter <daniel.vetter@ffwll.ch>
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
