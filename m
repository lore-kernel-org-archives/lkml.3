Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab3G3IlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:41:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40185 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab3G3IlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:41:11 -0400
Date: Tue, 30 Jul 2013 10:41:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH] mutex: fix deadlock injection
Message-ID: <20130730084102.GI3008@twins.programming.kicks-ass.net>
References: <20130701082221.GA14112@gmail.com>
 <CA+55aFwfsz6e5oQAdZw-YyYzwJXCPjKJKiLEXxn7ujU7KWX97Q@mail.gmail.com>
 <51D3C4C8.8060701@canonical.com>
 <20130705062345.GA29487@gmail.com>
 <51F775B5.201@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F775B5.201@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 10:13:41AM +0200, Maarten Lankhorst wrote:
> The check needs to be for > 1, because ctx->acquired is already incremented.
> This will prevent ww_mutex_lock_slow from returning -EDEADLK and not locking
> the mutex. It caused a lot of false gpu lockups on radeon with
> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y because a function that shouldn't be able
> to return -EDEADLK did.
> 
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Thanks!
