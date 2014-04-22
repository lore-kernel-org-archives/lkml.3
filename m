Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaDVNd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:33:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaDVNdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:33:25 -0400
Date: Tue, 22 Apr 2014 15:32:43 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, namhyung@kernel.org, dsahern@gmail.com
Subject: Re: [PATCH] perf tools: fix processing of pid/tid for mmap records
Message-ID: <20140422133242.GF1104@krava.brq.redhat.com>
References: <20140421160655.GA4201@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421160655.GA4201@quad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Mon, Apr 21, 2014 at 06:06:55PM +0200, Stephane Eranian wrote:
> perf tools: fix processing of pid/tid for mmap records

extra description line ^^^

>     
> Mmaps are global to a process (always). Processing them
> per-thread was causing some serious issues in case mmaps
> would overlap. The overlap fixups would only occur in the
> context of the thread which generated the overlapping
> mmap. But that was cause issues later on when a sample
> from another thread would fall into that overlapping
> mmap.
> 
> The solution to the problem is to handle ALL mmaps as
> occurring in the master thread (pid = tid) and then to
> lookup for thread map using pid as the tid argument.
> This is how samples are looking up for the thread map
> already (notice pid passed twice):
>     
> int perf_event__preprocess_sample(const union perf_event *event,
>                                   struct machine *machine,
>                                   struct addr_location *al,
>                                   struct perf_sample *sample)
> {
>         struct thread *thread = machine__findnew_thread(machine, sample->pid,
>                                                         sample->pid);
> }
>     
> Without this fix, some samples in overlapping regions
> may not be symbolized.

could you please take a look on following patchset:
http://marc.info/?l=linux-kernel&m=139749074531132&w=2

this makes the map groups shared within the process,
so it should fix above issue as well

thanks,
jirka
