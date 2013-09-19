Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3ISIzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:55:36 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:45284 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3ISIzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:55:35 -0400
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20130919084349.GM9326@twins.programming.kicks-ass.net>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
	<tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
	<alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
	<20130918085722.GL12926@twins.programming.kicks-ass.net>
	<alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy>
	<20130918154224.GK9326@twins.programming.kicks-ass.net>
	<CAMsRxfKRp5DRzCL54fzxLf02pNbBsA_61-LUBFTmbuL=L8QqzQ@mail.gmail.com>
	<20130919084349.GM9326@twins.programming.kicks-ass.net>
Date: Thu, 19 Sep 2013 10:55:34 +0200
Message-ID: <CAMsRxf+uBbCfn0XNgKya-m_sxLAh28jRASwnx_BNMjYqh77-QA@mail.gmail.com>
Subject: Re: [tip:perf/core] perf: Fix broken union in ' struct perf_event_mmap_page'
From: Stephane Eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vince@deater.net>, Ingo Molnar <mingo@kernel.org>,
        Peter Anvin <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        adrian.hunter@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 10:43 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Sep 18, 2013 at 08:33:53PM +0200, Stephane Eranian wrote:
>> On Wed, Sep 18, 2013 at 5:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, Sep 18, 2013 at 10:19:32AM -0400, Vince Weaver wrote:
>> >> Can you point to any code that is fixed by the commit?
>> >
>> > I have some, but I don't think a lot of people use it.
>> >
>> > Would you be ok with something like the below? It should preserve
>> > functionality for code that only cares about cap_usr_rdpmc (PAPI).
>> >
>> > Stephane, does libpfm use any of these?
>> >
>> Yes, there is an example using this. Need to verify it is not broken
>> currently (self_count.c).
>
> So if that only uses cap_usr_rdpmc, you have the same issue as Vince and
> the proposed solutions would work for you too.
>
> If you also use cap_usr_time we've a bit of a problem.

I need to look at this program again, was written a long time ago.
It does not use cap_usr_rdpmc nor cap_use_time for sure.
So which one(s) are okay to use?
