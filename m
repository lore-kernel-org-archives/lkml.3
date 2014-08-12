Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaHLOnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:43:19 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:56483 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaHLOnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:43:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140812055527.GI9918@twins.programming.kicks-ass.net>
References: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com>
 <1407797503-24727-3-git-send-email-bobby.prani@gmail.com> <20140812055527.GI9918@twins.programming.kicks-ass.net>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 12 Aug 2014 10:42:45 -0400
Message-ID: <CAJhHMCAk3VQVE_wqojF48ozB52igHGGdJQQVV+rrOCFTf-RqdQ@mail.gmail.com>
Subject: Re: [PATCH] sched: Remove ACCESS_ONCE() for jiffies
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        "open list:SCHEDULER" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 1:55 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Aug 11, 2014 at 06:51:41PM -0400, Pranith Kumar wrote:
>> jiffies is declared as a volatile variable. Therefore it is not neccessary to
>> use ACCESS_ONCE() while reading it.
>
> It also doesn't hurt and it documents intent, so I'm inclined to keep
> it.

It looks more like an inconsistency. These are the only three places
which use ACCESS_ONCE() for jiffies. Also, in doc/memory-barriers.txt,
it explicitly states that ACCESS_ONCE(jiffies) is not necessary. I
grepped for this usage after reading that document just to make sure
and found these three uses.

But yes, there is no harm being done by using ACCESS_ONCE().

-- 
Pranith
