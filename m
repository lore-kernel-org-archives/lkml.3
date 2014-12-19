Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaLSR1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:27:46 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaLSR1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:27:45 -0500
Date: Fri, 19 Dec 2014 18:27:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Shaohua Li <shli@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Kernel-team@fb.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
Message-ID: <20141219172728.GN30905@twins.programming.kicks-ass.net>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
 <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com>
 <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com>
 <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com>
 <20141219112350.GJ30905@twins.programming.kicks-ass.net>
 <CALCETrXRs5mXYq8OPH-WYqWPoD=35WccnHh7Bcm-YZMjW3ADcw@mail.gmail.com>
 <20141219170334.GM30905@twins.programming.kicks-ass.net>
 <CALCETrWGQY7YbOyAmApLDPVyW=dS+7xnu4hL_VXt=HG2Pyk-sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWGQY7YbOyAmApLDPVyW=dS+7xnu4hL_VXt=HG2Pyk-sA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 09:07:49AM -0800, Andy Lutomirski wrote:
> Re-asking my old question: would it make sense to add a vdso helper
> for the magic self-monitoring interface?  Or, at the very least, we
> could try to tidy up the docs a bit.

I find it really helps (performance wise) to strip down that magic to
the bare minimum required.

A VDSO helper would always have to do everything.  I suppose we could
provide a generic helper, one can always hand code the stuff anyhow.

Then again, what is the benefit of having it in the VDSO as opposed to a
regular DSO?

Updating the docs is always good.
