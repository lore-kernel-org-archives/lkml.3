Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaAMPtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:49:41 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48265 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaAMPtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:49:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140113154555.GR31570@twins.programming.kicks-ass.net>
References: <1389176153-3128-2-git-send-email-eranian@google.com>
	<tip-f3ae75de98c4bac145a87d830c156c96f9414022@git.kernel.org>
	<20140113154555.GR31570@twins.programming.kicks-ass.net>
Date: Mon, 13 Jan 2014 16:49:01 +0100
Message-ID: <CABPqkBTjzwjB9m_5jAjHV=iNuwt3os44p=SSxs7pT7PwmJ+Khw@mail.gmail.com>
Subject: Re: [tip:perf/core] perf/x86: Fix active_entry initialization
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 4:45 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Sun, Jan 12, 2014 at 10:42:47AM -0800, tip-bot for Stephane Eranian wrote:
> > -     union {
> > -             struct hlist_node       hlist_entry;
> > -             struct list_head        active_entry;
> > -     };
> > +     struct hlist_node               hlist_entry;
> > +     struct list_head                active_entry;
>
> Fwiw, we could probably stick both of those in hw_perf_event.
>
> the software event's hrtimer isn't the biggest entry anymore, so we
> could add the hlist_entry in there, and we can start a new entry for
> RAPL events.

Yeah, that would be possible.
The other thing I noticed too in another uncore patch I am preparing is
that we could also use that active_entry to avoid tracking association
of uncore events to counters to update them in the hrtimer routine.
All we need there is the list of active event on the uncore PMU and
we iterate over them.
