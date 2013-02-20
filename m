Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881Ab3BTTyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:54:11 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:61188 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934450Ab3BTTyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:54:09 -0500
MIME-Version: 1.0
In-Reply-To: <20130220154344.GD23293@tassilo.jf.intel.com>
References: <1361355312-3323-1-git-send-email-eranian@google.com>
	<20130220154344.GD23293@tassilo.jf.intel.com>
Date: Wed, 20 Feb 2013 20:54:08 +0100
Message-ID: <CABPqkBS58oMw8Gs7AVN0OMvLuFYH4iXXRHBx3Ep1Mbru=gLVtg@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: add Intel IvyBridge event scheduling constraints
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 4:43 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On Wed, Feb 20, 2013 at 11:15:12AM +0100, Stephane Eranian wrote:
>> Intel IvyBridge processor has different constraints compared
>> to SandyBridge. Therefore it needs its own contraint table.
>> This patch adds the constraint table. Without this patch,
>> the events listed in the patch may not be scheduled correctly
>> and bogus counts may be collected.
>
> Thanks. I ran into this problem too and was about to write
> a similar patch.
>
>> +     INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_EXECUTE */
>> +     INTEL_UEVENT_CONSTRAINT(0x05a3, 0xf), /* CYCLE_ACTIVITY.STALLS_L2_PENDING */
>> +     INTEL_UEVENT_CONSTRAINT(0x06a3, 0xf), /* CYCLE_ACTIVITY.STALLS_LDM_PENDING */
>> +     INTEL_UEVENT_CONSTRAINT(0x08a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
>> +     INTEL_UEVENT_CONSTRAINT(0x0ca3, 0x4), /* CYCLE_ACTIVITY.STALLS_L1D_PENDING */
>
>
> Except for LDM_PENDING the CYCLE_ACTIVITY events have been also added to Sandy Bridge.
> So it should be also added there.
>
As far as I know and I double-checked the documentation I have, there
is no CYCLE_ACTIVITY
event on SNB or SNB-EP.

> In fact I think you can still share the table because it would just add some
> non existent events to Sandy Bridge, which is a noop.
>
I don't see the point of this, except saving a few bytes. Isn't it
better to keep each PMU separate?


> -Andi
>
