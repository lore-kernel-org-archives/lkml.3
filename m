Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422665Ab3CVRgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:36:42 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:34698 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161038Ab3CVRgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:36:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130322173326.GN19692@tassilo.jf.intel.com>
References: <1363949499-3728-1-git-send-email-eranian@google.com>
	<20130322173326.GN19692@tassilo.jf.intel.com>
Date: Fri, 22 Mar 2013 18:36:40 +0100
Message-ID: <CABPqkBQnM7M0JPHvKVe2C1r2tPAmLMUMRKu-6w2G9xy2Og9pgw@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] perf: use hrtimer for event multiplexing
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 6:33 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
> On Fri, Mar 22, 2013 at 11:51:37AM +0100, Stephane Eranian wrote:
> > The current scheme of using the timer tick was fine
> > for per-thread events. However, it was causing
> > bias issues in system-wide mode (including for
> > uncore PMUs). Event groups would not get their
> > fair share of runtime on the PMU. With tickless
> > kernels, if a core is idle there is no timer tick,
> > and thus no event rotation (multiplexing). However,
> > there are events (especially uncore events) which do
> > count even though cores are asleep.
>
> Would it be possible to only do this when uncore events
> are active? Otherwise it may have a large power cost
> and actually change results, as the core counters
> will tick more.
>
the hrtimer is activated only when multiplexing is needed
and that's for any PMU.
