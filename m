Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaGBNAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:00:55 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:64895 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaGBNAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:00:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140702122757.GB19379@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
	<1404118253-19532-11-git-send-email-zheng.z.yan@intel.com>
	<20140702105737.GC6758@twins.programming.kicks-ass.net>
	<CABPqkBT2ZTC4Q3L9KwNfAs05qQvRFUZYvQ4QXJmiFeL-jwWSSw@mail.gmail.com>
	<20140702122757.GB19379@twins.programming.kicks-ass.net>
Date: Wed, 2 Jul 2014 15:00:52 +0200
Message-ID: <CABPqkBRUSjwfMbdapcq0hMJgVMfAqe9fFcCuvdPWV4iqZBbpTw@mail.gmail.com>
Subject: Re: [PATCH V4 10/16] perf, core: simplify need branch stack check
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 2:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jul 02, 2014 at 01:08:30PM +0200, Stephane Eranian wrote:
>> On Wed, Jul 2, 2014 at 12:57 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, Jun 30, 2014 at 04:50:47PM +0800, Yan, Zheng wrote:
>> >> event->attr.branch_sample_type is non-zero no matter branch stack
>> >> is enabled explicitly or is enabled implicitly. we can use it to
>> >> replace intel_pmu_needs_lbr_smpl(). This avoids duplicating code
>> >> that implicitly enables the LBR.
>> >
>> > How so? I grep'ed for a minute but could not find what you're referring
>> > to.
>>
>> If !(attr->sample_type & PERF_SAMPLE_BRANCH_STACK), then
>> event->attr.branch_type = 0. If the sample_type is set, then branch_type
>> is necessarily non-zero.
>
> Does not compute.. and that appears to contradict whatever Yan Zheng
> tries to say. He says that we have branch_type != 0 for PEBS events, and
> I couldn't find where that lived.

He is probably talking about precise=2 for non HSW PMU.
But it is true,  you need to look at x86_pmu_hw_config()
 *br_type = PERF_SAMPLE_BRANCH_ANY;
