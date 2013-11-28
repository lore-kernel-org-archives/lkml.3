Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab3K1MfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:35:23 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:40021 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3K1MfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:35:21 -0500
MIME-Version: 1.0
In-Reply-To: <20131128122619.GA6561@gmail.com>
References: <1384275531-10892-1-git-send-email-eranian@google.com>
	<1384275531-10892-4-git-send-email-eranian@google.com>
	<alpine.DEB.2.02.1311271328590.22932@pianoman.cluster.toy>
	<CABPqkBScotKO03hTA6YNcD4sDVj_Gx1fjicmWOJh_MBYTF+rfQ@mail.gmail.com>
	<alpine.DEB.2.02.1311271653280.24499@pianoman.cluster.toy>
	<20131128122619.GA6561@gmail.com>
Date: Thu, 28 Nov 2013 13:35:20 +0100
Message-ID: <CABPqkBSiLkDCcLFz5oxs2KS02LbiMNoAucrcx36aYqodiVpCpg@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Vince Weaver <vince@deater.net>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 1:26 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Vince Weaver <vince@deater.net> wrote:
>
>> On Wed, 27 Nov 2013, Stephane Eranian wrote:
>>
>> > On Wed, Nov 27, 2013 at 7:35 PM, Vince Weaver <vince@deater.net> wrote:
>>
>> > > So I notice PP1 (which is the GPU power on non-server chips)
>> > > is not supported.
>> > >
>> > > Is that just for simplicity?
>> > >
>> > Does it work on specific models only? I bet so. How to detect those?
>>
>> In general it is on the machines that don't support the DRAM measurements
>> (so the non-EP machines) but I don't know if there's a nice list anywhere.
>>
>> Intel manuals say:
>>    For a client platform, PP1 domain refers to the power plane of a
>>    specific device in the uncore. For server platforms, PP1 domain is not
>>    supported,
>>
>> usually PP1 I think maps to the embedded GPU.
>
> It would indeed be nice to expose PP1 too via the same facility -
> Haswell and later spends some 40% of the CPU die on the integrated GPU
> and people end up using it.
>
My worry is to determine if the GPU is actually enabled or even present.
Using the x86_model may not be enough for that.
