Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaLSRm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:42:59 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:61483 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaLSRm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:42:58 -0500
MIME-Version: 1.0
In-Reply-To: <20141219172728.GN30905@twins.programming.kicks-ass.net>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
 <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com>
 <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com>
 <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com>
 <20141219112350.GJ30905@twins.programming.kicks-ass.net> <CALCETrXRs5mXYq8OPH-WYqWPoD=35WccnHh7Bcm-YZMjW3ADcw@mail.gmail.com>
 <20141219170334.GM30905@twins.programming.kicks-ass.net> <CALCETrWGQY7YbOyAmApLDPVyW=dS+7xnu4hL_VXt=HG2Pyk-sA@mail.gmail.com>
 <20141219172728.GN30905@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 19 Dec 2014 09:42:36 -0800
Message-ID: <CALCETrWxziEYyGrujXWScAfNsw2nWGMVEPRK-ck2Rniktjhpfg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shaohua Li <shli@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Kernel-team@fb.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 9:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Dec 19, 2014 at 09:07:49AM -0800, Andy Lutomirski wrote:
>> Re-asking my old question: would it make sense to add a vdso helper
>> for the magic self-monitoring interface?  Or, at the very least, we
>> could try to tidy up the docs a bit.
>
> I find it really helps (performance wise) to strip down that magic to
> the bare minimum required.
>
> A VDSO helper would always have to do everything.  I suppose we could
> provide a generic helper, one can always hand code the stuff anyhow.
>
> Then again, what is the benefit of having it in the VDSO as opposed to a
> regular DSO?

The benefit of using the VDSO is that it means that we can change the
data structure whenever we want.  The __vdso_clock_gettime data
structure changes on a somewhat regular basis.

Other than that, a regular DSO is somewhat easier.

>
> Updating the docs is always good.

:)

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
