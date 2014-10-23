Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaJWHPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 03:15:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaJWHPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 03:15:43 -0400
Date: Thu, 23 Oct 2014 09:14:49 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Liang, Kan" <kan.liang@intel.com>, Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v2 05/12] perf/x86: add cross-HT counter exclusion
 infrastructure
Message-ID: <20141023071448.GB3356@krava.brq.redhat.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
 <1412872486-2930-6-git-send-email-eranian@google.com>
 <20141022150712.GD15126@krava.brq.redhat.com>
 <CABPqkBTim1nHhF2zEm0FGLBVStuD1TvdH_gifP+f3GCxdMp4Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTim1nHhF2zEm0FGLBVStuD1TvdH_gifP+f3GCxdMp4Ag@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 07:25:40PM +0200, Stephane Eranian wrote:
> On Wed, Oct 22, 2014 at 5:07 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Thu, Oct 09, 2014 at 06:34:39PM +0200, Stephane Eranian wrote:
> >> From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
> >>
> >
> > SNIP
> >
> >> +struct intel_excl_cntrs *allocate_excl_cntrs(int cpu)
> >> +{
> >> +     struct intel_excl_cntrs *c;
> >> +     int i;
> >> +
> >> +     c = kzalloc_node(sizeof(struct intel_excl_cntrs),
> >> +                      GFP_KERNEL, cpu_to_node(cpu));
> >> +     if (c) {
> >> +             spin_lock_init(&c->lock);
> >> +             for (i = 0; i < X86_PMC_IDX_MAX; i++) {
> >> +                     c->states[0].state[i] = INTEL_EXCL_UNUSED;
> >> +                     c->states[0].init_state[i] = INTEL_EXCL_UNUSED;
> >> +
> >> +                     c->states[1].state[i] = INTEL_EXCL_UNUSED;
> >> +                     c->states[1].init_state[i] = INTEL_EXCL_UNUSED;
> >
> > 'c' is allocated with kzalloc_node, seems there's no need
> > to re-initialize states it to zero again with INTEL_EXCL_UNUSED
> >
> You are assuming that INTEL_EXCL_UNUSED=0 always.
> That means it needs to be clear there is a dependency here.

it's 0 explicitly:

enum intel_excl_state_type {
        INTEL_EXCL_UNUSED    = 0, /* counter is unused */

but it's not big issue for me.. just curious ;-)

jirka
