Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaCYWfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:35:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:5746 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbaCYWfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:35:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,730,1389772800"; 
   d="scan'208";a="507508589"
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] tools, perf: Allow the user to disable time stamps
References: <1395780272-27106-1-git-send-email-andi@firstfloor.org>
	<CABPqkBSpoc1LX3=hZTnwM9KAeu943kbS0UgCbupWJf1idtdWNg@mail.gmail.com>
	<20140325210109.GH15074@tassilo.jf.intel.com>
	<CABPqkBT48Nx0qkPgnS=JsX0Etb7Xr1rLgoOAk1bt7L+DHvugGA@mail.gmail.com>
Date: Tue, 25 Mar 2014 15:34:52 -0700
In-Reply-To: <CABPqkBT48Nx0qkPgnS=JsX0Etb7Xr1rLgoOAk1bt7L+DHvugGA@mail.gmail.com>
	(Stephane Eranian's message of "Tue, 25 Mar 2014 23:15:05 +0100")
Message-ID: <87wqfhoqk3.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@google.com> writes:
>>
> But getting the mmaps at the right moment is crucial for some apps
> especially if address space is recycled otherwise symbolization
> may be incorrect.

Yes that is why it is only an option and not default.
You need to know what you're doing.

BTW I think the recycle case is not very likely on non JIT.

>> You're right for some special analysis it matters, that is why
>> it is only an option.
>>
>> But for the standard "only care about perf report and
>> don't care about about program startup" case it's a nice saving.
>>
> How do you know in advance you won't need mmap ordering?

When I measure a long running process and I know it doesn't
fork/dlopen/jit. Using --initial-delay also helps to skip
the startup phase or attaching later.

I believe it's actually a good choice for most non
forky workloads. But yes it cannot be made default.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
