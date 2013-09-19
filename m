Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3ISJQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:16:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37447 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab3ISJQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:16:57 -0400
Date: Thu, 19 Sep 2013 11:16:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: eranian@gmail.com
Cc: Peter Zijlstra <peterz@infradead.org>, Vince Weaver <vince@deater.net>,
        Peter Anvin <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        adrian.hunter@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Fix broken union in ' struct
 perf_event_mmap_page'
Message-ID: <20130919091653.GC14112@gmail.com>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
 <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
 <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
 <20130918085722.GL12926@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy>
 <20130918154224.GK9326@twins.programming.kicks-ass.net>
 <CAMsRxfKRp5DRzCL54fzxLf02pNbBsA_61-LUBFTmbuL=L8QqzQ@mail.gmail.com>
 <20130919084349.GM9326@twins.programming.kicks-ass.net>
 <CAMsRxf+uBbCfn0XNgKya-m_sxLAh28jRASwnx_BNMjYqh77-QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMsRxf+uBbCfn0XNgKya-m_sxLAh28jRASwnx_BNMjYqh77-QA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@googlemail.com> wrote:

> On Thu, Sep 19, 2013 at 10:43 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, Sep 18, 2013 at 08:33:53PM +0200, Stephane Eranian wrote:
> >> On Wed, Sep 18, 2013 at 5:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > On Wed, Sep 18, 2013 at 10:19:32AM -0400, Vince Weaver wrote:
> >> >> Can you point to any code that is fixed by the commit?
> >> >
> >> > I have some, but I don't think a lot of people use it.
> >> >
> >> > Would you be ok with something like the below? It should preserve
> >> > functionality for code that only cares about cap_usr_rdpmc (PAPI).
> >> >
> >> > Stephane, does libpfm use any of these?
> >> >
> >> Yes, there is an example using this. Need to verify it is not broken
> >> currently (self_count.c).
> >
> > So if that only uses cap_usr_rdpmc, you have the same issue as Vince and
> > the proposed solutions would work for you too.
> >
> > If you also use cap_usr_time we've a bit of a problem.
> 
> I need to look at this program again, was written a long time ago. It 
> does not use cap_usr_rdpmc nor cap_use_time for sure.

If it does not use either flag (which in released kernels is really a 
single flag ABI-wise) then it should be fine.

Thanks,

	Ingo
