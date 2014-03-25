Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaCYWPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:15:10 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:38913 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaCYWPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:15:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140325210109.GH15074@tassilo.jf.intel.com>
References: <1395780272-27106-1-git-send-email-andi@firstfloor.org>
	<CABPqkBSpoc1LX3=hZTnwM9KAeu943kbS0UgCbupWJf1idtdWNg@mail.gmail.com>
	<20140325210109.GH15074@tassilo.jf.intel.com>
Date: Tue, 25 Mar 2014 23:15:05 +0100
Message-ID: <CABPqkBT48Nx0qkPgnS=JsX0Etb7Xr1rLgoOAk1bt7L+DHvugGA@mail.gmail.com>
Subject: Re: [PATCH] tools, perf: Allow the user to disable time stamps
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 10:01 PM, Andi Kleen <ak@linux.intel.com> wrote:
>>
>> Timestamp are useful to order samples during reporting.
>> How do you do with it if you monitor multi-threaded (multi-cpu)
>> workloads. This is only good for single thread or single CPU
>> measurements. Or am I missing something?
>
> For a perf report order doesn't matter (except against mmaps)
> The CPUs are still separated of course
>
But getting the mmaps at the right moment is crucial for some apps
especially if address space is recycled otherwise symbolization
may be incorrect.

> You're right for some special analysis it matters, that is why
> it is only an option.
>
> But for the standard "only care about perf report and
> don't care about about program startup" case it's a nice saving.
>
How do you know in advance you won't need mmap ordering?
