Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab3HGGWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:22:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47222 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3HGGWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:22:49 -0400
Message-ID: <5201E7B0.5070802@canonical.com>
Date: Wed, 07 Aug 2013 08:22:40 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH] mutex: fix deadlock injection
References: <20130701082221.GA14112@gmail.com> <CA+55aFwfsz6e5oQAdZw-YyYzwJXCPjKJKiLEXxn7ujU7KWX97Q@mail.gmail.com> <51D3C4C8.8060701@canonical.com> <20130705062345.GA29487@gmail.com> <51F775B5.201@canonical.com> <20130730084102.GI3008@twins.programming.kicks-ass.net> <CAPM=9ty0B=HR-g1vLoe51LpRZH8zH1yBzTSfhJg5yXceF+afdw@mail.gmail.com>
In-Reply-To: <CAPM=9ty0B=HR-g1vLoe51LpRZH8zH1yBzTSfhJg5yXceF+afdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-08-13 02:05, Dave Airlie schreef:
> On Tue, Jul 30, 2013 at 6:41 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, Jul 30, 2013 at 10:13:41AM +0200, Maarten Lankhorst wrote:
>>> The check needs to be for > 1, because ctx->acquired is already incremented.
>>> This will prevent ww_mutex_lock_slow from returning -EDEADLK and not locking
>>> the mutex. It caused a lot of false gpu lockups on radeon with
>>> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y because a function that shouldn't be able
>>> to return -EDEADLK did.
>>>
>>> Cc: Alex Deucher <alexander.deucher@amd.com>
>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Should this be merged via Ingo? or will I queue it in my -fixes?
>
> Dave.
>
It's in tip:core/urgent, so I imagine you don't need to queue it.
