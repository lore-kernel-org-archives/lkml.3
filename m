Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaIJIhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:37:17 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:64408 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaIJIhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:37:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140910075954.GW3588@twins.programming.kicks-ass.net>
References: <1410310148-26260-1-git-send-email-andi@firstfloor.org>
	<1410310148-26260-2-git-send-email-andi@firstfloor.org>
	<20140910075926.GM6758@twins.programming.kicks-ass.net>
	<20140910075954.GW3588@twins.programming.kicks-ass.net>
Date: Wed, 10 Sep 2014 10:37:14 +0200
Message-ID: <CABPqkBQBVRph9+aXC6F3=QxkVXXYVH8wM4rPwKBY8dpCtf1z_A@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf, x86: Use INTEL_FLAGS_UEVENT_CONSTRAINT for PRECDIST
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 9:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Sep 10, 2014 at 09:59:26AM +0200, Peter Zijlstra wrote:
>> On Tue, Sep 09, 2014 at 05:49:08PM -0700, Andi Kleen wrote:
>> > From: Andi Kleen <ak@linux.intel.com>
>> >
>> > The earlier commit 86a04461a made near all PEBS on
>> > Sandy/IvyBridge/Haswell to reject non zero flags.
>>
>> What's magic about nehalem and westmere?
>
> And core2 and whatever else we support PEBS for, for that matter.

nhm, wsm, core2 do not have precise distribution (PREC_DIST) umask to
inst_Retired.

But as I said before, PEBS events do not support any filters. cycles
-> uops_retired:any_inv=1:cmask=1
being an exception.
