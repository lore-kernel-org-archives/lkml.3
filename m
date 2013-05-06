Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab3EFRoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 13:44:22 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:60592 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3EFRoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 13:44:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130502073720.GH7521@dyad.programming.kicks-ass.net>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
	<1366844694-2770-2-git-send-email-andi@firstfloor.org>
	<20130502073720.GH7521@dyad.programming.kicks-ass.net>
Date: Mon, 6 May 2013 19:44:19 +0200
Message-ID: <CABPqkBQb23aJJXhrnYOOG+RWZgfVfyAFS+ksAKxczVOqjtricQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf, x86: Don't allow unusual PEBS raw flags
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 9:37 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Apr 24, 2013 at 04:04:54PM -0700, Andi Kleen wrote:
>> From: Andi Kleen <ak@linux.intel.com>
>>
>> The PEBS documentation in the Intel SDM 18.6.1.1 states:
>>
>> """
>> PEBS events are only valid when the following fields of IA32_PERFEVTSELx are all
>> zero: AnyThread, Edge, Invert, CMask.
>> """
>>
>> Since we had problems with this earlier, don't allow cmask, any, edge, invert
>> as raw events, except for the ones explicitly listed as pebs_aliases.
>
> If its a simple matter of crap in crap out without affecting anything else we
> shouldn't do anything.
>
The problem here is that you are sampling an instruction which did not cause
the event you are measuring. Remember that using cmask, changes the
nature of what's being measured (from event to cycles).


> The only reason to interfere with the programming is if invalid programming can
> affect others like with that MEM_*_RETIRED failure on ivb.
