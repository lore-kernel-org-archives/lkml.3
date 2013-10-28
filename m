Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3J1MSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:18:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49580 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab3J1MSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:18:09 -0400
Date: Mon, 28 Oct 2013 13:17:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 3/4] perf,x86: add Intel RAPL PMU support
Message-ID: <20131028121747.GL19466@laptop.lan>
References: <1382533085-7166-1-git-send-email-eranian@google.com>
 <1382533085-7166-4-git-send-email-eranian@google.com>
 <20131025111422.GC1219@krava.redhat.com>
 <CABPqkBR0gEz7cauev0hk=oofO1m9RP=wP3NK3j0y7EiNE8j3tg@mail.gmail.com>
 <CABPqkBShxTc3wBkwWej6gaWJK3GmdtV71hNdozabnbwpesXx_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBShxTc3wBkwWej6gaWJK3GmdtV71hNdozabnbwpesXx_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:33:50AM +0100, Stephane Eranian wrote:
> If we have that, then it may not be necessary anymore
> to express the raw count in the 1/2^32 J unit like we
> are currently doing. This loses a bit of precision. We
> could as well expose the actual raw count and export
> the actual unit via sysfs. For instance, on SNB/IVB the
> unit is 1/2^16, but on Haswell it is 1/2^14.

2^-32 can losslessly express both 2^-16 and 2^-14.

Notably: 2^18/2^32 = 2^(18-32) = 2^-14.

So no, 2^-32 does not loose precision.

The only side effect of always using 2^-32 is that we can only maximally
represent 2^32 (from 64-32), whereas when using 2^-14 we could maximally
represent 2^50.

That said; 2^32 Joule ~ 4.2 GJ which is a rather large quantity of
energy; one I would hope is out there when measuring package energy
costs over any reasonable amount of time.

So the only reason to switch away from using the 32.32 fixed point would
be if someone can make a reasonable argument for why 4.2 GJ is not
sufficient and they need 1 PJ (yes, peta-joule, as in we need a private
nuclear reactor to power this CPU).


