Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab3BGTUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:20:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30448 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab3BGTUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:20:02 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=M5gr15I6uLgA:10 a=4LOHUIvq3iT-KwMADyAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360264798.2621.101.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 07 Feb 2013 14:19:58 -0500
In-Reply-To: <20130207190754.GB25223@gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	 <1360205415.2621.60.camel@gandalf.local.home>
	 <20130207111025.GD8945@gmail.com>
	 <CAFTL4hySiyn8Ci6XKFSRsMr7FabgpwSbOuNDP_GsefFDsbT2Cg@mail.gmail.com>
	 <20130207190754.GB25223@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 20:07 +0100, Ingo Molnar wrote:

> Could we just simplify things and make this an unconditional 
> option of NO_HZ? Any reason why we'd want to make this 
> configurable, other than debugging?

I think the worry is the overhead that is required to keep it active. It
requires the context_tracking being enabled. Although, we may be able to
have both working. 

Frederic, can we switch between context_tracking timing and tick base at
run time?

If we can have it enabled without overhead then I see no problem with
it. We still need the boot time kernel parameter to implement it. Hmm,
even if we can't dynamically switch between context_tracking and tick
base, we could make that decision at boot up based off of the kernel
parameters.


> 
> I'm worried about the proliferation of not easily separable 
> config options. We already have way too many timer and scheduler 
> options to begin with.

I agree.

> 
> > At least for now we seem to agree on CONFIG_NO_HZ_IDLE and 
> > keep CONFIG_NO_HZ for compatibility. Are you ok with that? If 
> > so I'll send a patch.
> 
> What would be the name of the new config option?
> 
> Can we just keep CONFIG_NO_HZ and extend it with your bits, and 
> make sure they work well?

As long as we do not introduce performance regressions. If we can keep
it active without causing the system to slow down when not in use, then
I think it should be always enabled if CONFIG_NO_HZ is selected.

-- Steve


