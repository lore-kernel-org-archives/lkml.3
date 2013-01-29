Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3A2IDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:03:12 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:34435 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab3A2IDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:03:10 -0500
Date: Tue, 29 Jan 2013 09:03:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf tools: Add '.' as part of the event 'name' token
Message-ID: <20130129080305.GB594@gmail.com>
References: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
 <1359230650-10415-2-git-send-email-jolsa@redhat.com>
 <CABPqkBSH=67hG8VRwHPU3byEancpVqsyetHkSjb4nOScPvcnFA@mail.gmail.com>
 <CABPqkBTPHKf+XTmeyA8PrWReG8Ak6ow9gSwfh4ozK+gvJMze1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTPHKf+XTmeyA8PrWReG8Ak6ow9gSwfh4ozK+gvJMze1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Mon, Jan 28, 2013 at 9:52 PM, Stephane Eranian <eranian@google.com> wrote:
> > Jiri,
> >
> > I don't see part 0/8 of this series. Did you send it to me too?
> >
> > I have some comments about it. I don't see why create something from scratch
> > when I have been developing a library (libpfm4) that takes care of that and that
> > is already used by many tool developers. That library can be linked with perf
> > and provide full symbolic events + all the modifiers. The library is portable
> > and supports all existing archs. It can also be used by self-monitoring apps.
> >
> >
> > You're introducing yet another event table to maintain. And believe me this is
> > a lot of work to maintain this.
> >
> > I don't understand why not use this existing library.
> >
>
> I meant to add that I think it would be more productive if we 
> (you and I) were to work on the library to extend it with 
> external text-based event tables that could be used by perf 
> either directly or thru the libpfm4 interface.

perf is intentionally external file free and does not 
(fundamentally) depend on external libraries either,
other than core system libraries.

There are several advantages to that:

 - there is no version skew and no design/maintenance friction

 - 'upgrading' perf between similar boxes is as simple as
   copying the perf binary

 - it's self-sufficient

 - there's no real advantage of external text files versus
   internal text files (i.e. text tables within the source 
   code), while there are several disadvantages

So as long as Jiri is happy to maintain these tables I think 
it's a superior solution (even if the tables start out 
incomplete), from the perf project's perspective.

Thanks,

	Ingo
