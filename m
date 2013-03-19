Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3CSNCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:02:36 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:55676 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3CSNCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:02:34 -0400
MIME-Version: 1.0
In-Reply-To: <1363697902.22553.43.camel@laptop>
References: <20130318134645.GA3278@quad>
	<1363696984.22553.41.camel@laptop>
	<CABPqkBSmVzk=0nvHiuk-+XSfNX8ODXWKeJ+jUu2482=NvMoghg@mail.gmail.com>
	<1363697902.22553.43.camel@laptop>
Date: Tue, 19 Mar 2013 14:02:34 +0100
Message-ID: <CABPqkBQcD6EBcJuxx0iNMQCw=iFAc0zHZ+5hmZwmCACCsOw0uw@mail.gmail.com>
Subject: Re: [PATCH] perf,x86: fix uninitialized pt_regs in intel_pmu_drain_bts_buffer()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Salman Qazi <sqazi@google.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 1:58 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2013-03-19 at 13:50 +0100, Stephane Eranian wrote:
>> > Should we not replace:
>> >
>> >         regs.ip     = 0;
>> >
>> > with that memset? It avoids the memset work in a few cases and
>> removes
>> > the then superfluous clearing of the IP field.
>> >
>> We could drop it because it's covered by the memset().
>
> Yeah, but also place the memset a little lower than you did, avoids the
> stack writes when not needed.
>
Ok, I get it now. Yes, we can move it after the test and drop reg.val = 0.

>> The issue here was that you eventually end up in code_segment_base()
>> which
>> looks at other uninitialized fields in pt_regs and may cause breakage.
>
> Right, your changelog said so ;-)
>
