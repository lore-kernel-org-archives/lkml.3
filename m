Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaJVRZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:25:43 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:53932 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaJVRZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:25:41 -0400
MIME-Version: 1.0
In-Reply-To: <20141022150712.GD15126@krava.brq.redhat.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
	<1412872486-2930-6-git-send-email-eranian@google.com>
	<20141022150712.GD15126@krava.brq.redhat.com>
Date: Wed, 22 Oct 2014 19:25:40 +0200
Message-ID: <CABPqkBTim1nHhF2zEm0FGLBVStuD1TvdH_gifP+f3GCxdMp4Ag@mail.gmail.com>
Subject: Re: [PATCH v2 05/12] perf/x86: add cross-HT counter exclusion infrastructure
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Liang, Kan" <kan.liang@intel.com>, Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 5:07 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Oct 09, 2014 at 06:34:39PM +0200, Stephane Eranian wrote:
>> From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
>>
>
> SNIP
>
>> +struct intel_excl_cntrs *allocate_excl_cntrs(int cpu)
>> +{
>> +     struct intel_excl_cntrs *c;
>> +     int i;
>> +
>> +     c = kzalloc_node(sizeof(struct intel_excl_cntrs),
>> +                      GFP_KERNEL, cpu_to_node(cpu));
>> +     if (c) {
>> +             spin_lock_init(&c->lock);
>> +             for (i = 0; i < X86_PMC_IDX_MAX; i++) {
>> +                     c->states[0].state[i] = INTEL_EXCL_UNUSED;
>> +                     c->states[0].init_state[i] = INTEL_EXCL_UNUSED;
>> +
>> +                     c->states[1].state[i] = INTEL_EXCL_UNUSED;
>> +                     c->states[1].init_state[i] = INTEL_EXCL_UNUSED;
>
> 'c' is allocated with kzalloc_node, seems there's no need
> to re-initialize states it to zero again with INTEL_EXCL_UNUSED
>
You are assuming that INTEL_EXCL_UNUSED=0 always.
That means it needs to be clear there is a dependency here.

I am happy removing that if someone confirms the assumption is common
in the kernel
for this kind of fields.


> jirka
