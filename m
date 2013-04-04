Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763433Ab3DDQyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:54:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56628 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763188Ab3DDQys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:54:48 -0400
Message-ID: <1365094476.2609.123.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, daniel.vetter@ffwll.ch, x86@kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org
Date: Thu, 04 Apr 2013 18:54:36 +0200
In-Reply-To: <20130404133123.GW2228@phenom.ffwll.local>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
	 <1364900432.18374.24.camel@laptop> <515AF1C1.7080508@canonical.com>
	 <1364921954.20640.22.camel@laptop> <1365076908.2609.94.camel@laptop>
	 <20130404133123.GW2228@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
> Well, it was a good read and I'm rather happy that we agree on the
> ww_ctx
> thing (whatever it's called in the end), even though we have slightly
> different reasons for it.

Yeah, I tried various weirdness to get out from under it, but the whole
progress/fairness thing made it rather hard. Ideally you'd be able to
use some existing scheduler state since its the same goal, but the
whole wakeup-retry muck makes that hard.

> I don't really have a useful idea to make the retry handling for users
> more rusty-compliant though, and I'm still unhappy with all current
> naming
> proposals ;-)

Ah, naming,.. yeah I'm not too terribly attached to most of them. I
just want to avoid something that's reasonably well known to mean
something different.

Furthermore, since we use the wound/wait symmetry breaking it would
make sense for that to appear somewhere in the name.



