Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964903AbaFSTx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:53:28 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50645 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaFSTx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:53:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140619180028.GU8178@tassilo.jf.intel.com>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
	<1403193509-22393-2-git-send-email-eranian@google.com>
	<20140619180028.GU8178@tassilo.jf.intel.com>
Date: Thu, 19 Jun 2014 21:53:26 +0200
Message-ID: <CABPqkBTw9wi1LSoqWUYcN2W1fvBYDfsdqkdxDTPQ0rWUEUFLmA@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf/x86: update Haswell PEBS event constraints
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 8:00 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
> On Thu, Jun 19, 2014 at 05:58:28PM +0200, Stephane Eranian wrote:
> > The following events support PEBS for all umasks,
> > thus use INTEL_EVENT_CONSTRAINT() instead of
> > INTEL_UEVENT_CONSTRAINT():
> >
> > 0xd1 MEM_LOAD_UOPS_RETIRED
> > 0xd2 MEM_LOAD_UOPS_LLC_HIT_RETIRED
> > 0xd3 MEM_LOAD_UOPS_LLC_MISS_RETIRED
> >
> > For event 0xd0 (MEM_UOPS_RETIRED), the same is true, except
> > we need to distinguish precise store (umask 0x82) from load
> > latency events, thus we keep the breakdown per umask. But all
> > umasks do support PEBS.
>
> I sent a similar patch some time ago
>
> http://lkml.iu.edu/hypermail/linux/kernel/1404.2/01509.html
>
> However these days I'm actually thinking of just getting
> rid of the detailed table except for PREC_DIST. All the PEBS
> controls should be noops if the event does not support PEBS
>
I don't quite understand that.
You need to know which events support PEBS. You need a table
for that. then I think you could drop the counter mask because
with HT on, no mask is needed. When HT is off you need a mask,
but it can be hardcoded for all events, well at least on HSW.
