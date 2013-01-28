Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3A1WUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:20:39 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:59702 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3A1WUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:20:36 -0500
MIME-Version: 1.0
In-Reply-To: <20130128220810.GV30577@one.firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
	<1359151245-13179-6-git-send-email-andi@firstfloor.org>
	<CABPqkBR=vZ-S0PTZDFk03f3vXah+Ozi8KHmDGH8Q01ROO+LYFg@mail.gmail.com>
	<20130128220810.GV30577@one.firstfloor.org>
Date: Mon, 28 Jan 2013 23:20:35 +0100
Message-ID: <CABPqkBQaBu44LUxh5Q4+4vJvEU_KFKqi0Dx3mfTwxgSQDhiOUA@mail.gmail.com>
Subject: Re: [PATCH 05/12] perf, x86: Support Haswell v4 LBR format
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 11:08 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> > -               if (lbr_format == LBR_FORMAT_EIP_FLAGS) {
>> > +               if (lbr_format == LBR_FORMAT_EIP_FLAGS ||
>> > +                   lbr_format == LBR_FORMAT_EIP_FLAGS2) {
>> >                         mis = !!(from & LBR_FROM_FLAG_MISPRED);
>> >                         pred = !mis;
>> > -                       from = (u64)((((s64)from) << 1) >> 1);
>> > +                       if (lbr_format == LBR_FORMAT_EIP_FLAGS)
>> > +                               from = (u64)((((s64)from) << 1) >> 1);
>> > +                       else if (lbr_format == LBR_FORMAT_EIP_FLAGS2) {
>> > +                               intx = !!(from & LBR_FROM_FLAG_INTX);
>> > +                               abort = !!(from & LBR_FROM_FLAG_ABORT);
>> > +                               from = (u64)((((s64)from) << 3) >> 3);
>> > +                       }
>> >                 }
>> >
>> Wouldn't all that be more readable with a switch-case, especially given
>> that lbr_format could be extended.
>
> The current version works for me.

I know it works. I am questioning the style: hard to read.
