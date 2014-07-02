Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaGBLIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:08:32 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:46022 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaGBLIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:08:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140702105737.GC6758@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
	<1404118253-19532-11-git-send-email-zheng.z.yan@intel.com>
	<20140702105737.GC6758@twins.programming.kicks-ass.net>
Date: Wed, 2 Jul 2014 13:08:30 +0200
Message-ID: <CABPqkBT2ZTC4Q3L9KwNfAs05qQvRFUZYvQ4QXJmiFeL-jwWSSw@mail.gmail.com>
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

On Wed, Jul 2, 2014 at 12:57 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jun 30, 2014 at 04:50:47PM +0800, Yan, Zheng wrote:
>> event->attr.branch_sample_type is non-zero no matter branch stack
>> is enabled explicitly or is enabled implicitly. we can use it to
>> replace intel_pmu_needs_lbr_smpl(). This avoids duplicating code
>> that implicitly enables the LBR.
>
> How so? I grep'ed for a minute but could not find what you're referring
> to.

If !(attr->sample_type & PERF_SAMPLE_BRANCH_STACK), then
event->attr.branch_type = 0. If the sample_type is set, then branch_type
is necessarily non-zero.
