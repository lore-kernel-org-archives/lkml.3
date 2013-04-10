Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935044Ab3DJLiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:38:24 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:59801 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3DJLiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:38:23 -0400
MIME-Version: 1.0
In-Reply-To: <1365586878.30071.33.camel@laptop>
References: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
	<1365586878.30071.33.camel@laptop>
Date: Wed, 10 Apr 2013 13:38:22 +0200
Message-ID: <CABPqkBRTaMV9FNmX6qRJAHaO8yTyiqF=EzmeC7Gp7=e-7Bo-gA@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/3] perf, amd: Support for Family 16h L2I
 Performance Counters
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86 <x86@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 11:41 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Tue, 2013-04-09 at 10:23 -0500, Jacob Shin wrote:
> > Upcoming AMD Family 16h Processors provide 4 new performance counters
> > to count L2 related events. Similar to northbridge counters, these new
> > counters are shared across multiple CPUs that share the same L2 cache.
> > This patchset adds support for these new counters and enforces sharing
> > by leveraging the existing sharing logic used for the northbridge
> > counters.
>
> If they're separate counters -- not shared with the regular cpu
> counters like the 10h NB counters are, then they should have their own
> PMU driver.
>
> Similar to the 15h NB counters; which are a separate set of counters
> and no longer overlay the normal counters.
>
Well, that's how this was suggested but that's not how it's
implemented currently
and committed if I recall.
