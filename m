Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964985Ab3DJLt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:49:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52769 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935229Ab3DJLtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:49:25 -0400
Message-ID: <1365594552.30071.63.camel@laptop>
Subject: Re: [PATCH RESEND 0/3] perf, amd: Support for Family 16h L2I
 Performance Counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86 <x86@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 10 Apr 2013 13:49:12 +0200
In-Reply-To: <CABPqkBRTaMV9FNmX6qRJAHaO8yTyiqF=EzmeC7Gp7=e-7Bo-gA@mail.gmail.com>
References: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
	 <1365586878.30071.33.camel@laptop>
	 <CABPqkBRTaMV9FNmX6qRJAHaO8yTyiqF=EzmeC7Gp7=e-7Bo-gA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 13:38 +0200, Stephane Eranian wrote:
> On Wed, Apr 10, 2013 at 11:41 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > On Tue, 2013-04-09 at 10:23 -0500, Jacob Shin wrote:
> > > Upcoming AMD Family 16h Processors provide 4 new performance counters
> > > to count L2 related events. Similar to northbridge counters, these new
> > > counters are shared across multiple CPUs that share the same L2 cache.
> > > This patchset adds support for these new counters and enforces sharing
> > > by leveraging the existing sharing logic used for the northbridge
> > > counters.
> >
> > If they're separate counters -- not shared with the regular cpu
> > counters like the 10h NB counters are, then they should have their own
> > PMU driver.
> >
> > Similar to the 15h NB counters; which are a separate set of counters
> > and no longer overlay the normal counters.
> >
> Well, that's how this was suggested but that's not how it's
> implemented currently
> and committed if I recall.

Hmm.. the 15h old interface bits got merged? I thought I kept telling
that should be done like the intel uncore stuff since the hardware
interface wasn't retarded anymore.

