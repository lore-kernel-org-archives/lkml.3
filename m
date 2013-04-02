Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920Ab3DBLFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:05:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43889 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab3DBLE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:04:59 -0400
Message-ID: <1364900687.18374.28.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        daniel.vetter@ffwll.ch, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-media@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 02 Apr 2013 13:04:47 +0200
In-Reply-To: <20130228102502.15191.14146.stgit@patser>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 11:25 +0100, Maarten Lankhorst wrote:
> +The algorithm that TTM came up with for dealing with this problem is
> +quite simple.  For each group of buffers (execbuf) that need to be
> +locked, the caller would be assigned a unique reservation_id, from a
> +global counter.  In case of deadlock while locking all the buffers
> +associated with a execbuf, the one with the lowest reservation_id
> +wins, and the one with the higher reservation_id unlocks all of the
> +buffers that it has already locked, and then tries again.

So the thing that made me cringe inside when I read this was making it
all work on -rt, where we also need to take PI into account and ensure
the entire thing is deterministic.

It _might_ be 'easy' and we could fall back to PI mutex behaviour in
the case the reservation IDs match; however the entire for-all-bufs
retry loops do worry me still.

Head hurts, needs more time to ponder. It would be good if someone else
(this would probably be you maarten) would also consider this and
explore
this 'interesting' problem space :-)

