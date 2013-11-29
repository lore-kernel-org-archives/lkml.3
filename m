Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3K2XZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 18:25:17 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:37521 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3K2XZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 18:25:13 -0500
MIME-Version: 1.0
In-Reply-To: <20131129203103.GJ4266@pd.tnic>
References: <1384275531-10892-1-git-send-email-eranian@google.com>
	<1384275531-10892-4-git-send-email-eranian@google.com>
	<alpine.DEB.2.02.1311271328590.22932@pianoman.cluster.toy>
	<CABPqkBScotKO03hTA6YNcD4sDVj_Gx1fjicmWOJh_MBYTF+rfQ@mail.gmail.com>
	<alpine.DEB.2.02.1311271653280.24499@pianoman.cluster.toy>
	<20131128122619.GA6561@gmail.com>
	<CABPqkBSiLkDCcLFz5oxs2KS02LbiMNoAucrcx36aYqodiVpCpg@mail.gmail.com>
	<alpine.DEB.2.02.1311291413430.13064@pianoman.cluster.toy>
	<CABPqkBTvhgXm_UNWDEgjP4aVf=G2MxfgBpnJBsiAZpcg7x-r=w@mail.gmail.com>
	<20131129203103.GJ4266@pd.tnic>
Date: Sat, 30 Nov 2013 00:25:10 +0100
Message-ID: <CABPqkBRtBESMT-+FokR0+JYYL3Q=GUG-e5gZGOeHT3wOOtEaow@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince,

Ok, I have added PP1 now and it works fine on my HSW desktop.
What I want to know now is what is this map to on servers?
And on clients, it is always mapped to the GFX. If so, then
we can use a more specific name: power/energy-gfx/

I will send a patch soon.

Thanks.

On Fri, Nov 29, 2013 at 9:31 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Nov 29, 2013 at 09:09:46PM +0100, Stephane Eranian wrote:
>> > So in theory it would be harmless to export the values even if not
>> > supported.  What is the worst failure mode?  That somehow a recent CPU
>> > doesn't support the MSR and we get a GPF when trying to access it?
>> >
>> Yes. I think that's what you get with DRAM on client for instance.
>
> We have rdmsr_safe for non-existent MSRs, in case touching such is the
> issue.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
