Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab3HGAFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 20:05:38 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:56282 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab3HGAFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 20:05:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130730084102.GI3008@twins.programming.kicks-ass.net>
References: <20130701082221.GA14112@gmail.com>
	<CA+55aFwfsz6e5oQAdZw-YyYzwJXCPjKJKiLEXxn7ujU7KWX97Q@mail.gmail.com>
	<51D3C4C8.8060701@canonical.com>
	<20130705062345.GA29487@gmail.com>
	<51F775B5.201@canonical.com>
	<20130730084102.GI3008@twins.programming.kicks-ass.net>
Date: Wed, 7 Aug 2013 10:05:35 +1000
Message-ID: <CAPM=9ty0B=HR-g1vLoe51LpRZH8zH1yBzTSfhJg5yXceF+afdw@mail.gmail.com>
Subject: Re: [PATCH] mutex: fix deadlock injection
From: Dave Airlie <airlied@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 6:41 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jul 30, 2013 at 10:13:41AM +0200, Maarten Lankhorst wrote:
>> The check needs to be for > 1, because ctx->acquired is already incremented.
>> This will prevent ww_mutex_lock_slow from returning -EDEADLK and not locking
>> the mutex. It caused a lot of false gpu lockups on radeon with
>> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y because a function that shouldn't be able
>> to return -EDEADLK did.
>>
>> Cc: Alex Deucher <alexander.deucher@amd.com>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Should this be merged via Ingo? or will I queue it in my -fixes?

Dave.
