Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaANIYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:24:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaANIYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:24:32 -0500
Message-ID: <1389687856.5951.14.camel@marge.simpson.net>
Subject: Re: Idle power fix regresses ebizzy performance (was 3.12-stable
 backport of NUMA balancing patches)
From: Mike Galbraith <bitbucket@online.de>
To: Len Brown <lenb@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, Len Brown <len.brown@intel.com>,
        athorlton@sgi.com, Rik van Riel <riel@redhat.com>, chegu_vinod@hp.com,
        Greg KH <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Date: Tue, 14 Jan 2014 09:24:16 +0100
In-Reply-To: <1389686473.5951.11.camel@marge.simpson.net>
References: <1389103248-17617-1-git-send-email-mgorman@suse.de>
	 <20140107141715.GA32491@kroah.com> <20140107185440.GA7844@kroah.com>
	 <20140107203012.GA27046@suse.de> <20140108104340.GC27046@suse.de>
	 <20140108134858.GF27046@suse.de> <20140113192406.GL27046@suse.de>
	 <CAJvTdKniGkxxzvPvEDSU9BgtubR-5Fn3YsepjSNAwn5XkL3nVA@mail.gmail.com>
	 <1389686473.5951.11.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:bdnlWhG7y5o9Hz1XmDPuTuEnvTu97Ox6qe6cIeh2lVo
 3lTeKhbKYYIo3JTH+L/D0/lTqoPjLUqpwIwpu88XUGp7fTZnba
 9zoxAP16UOzI2vsMP43Myit6HGr909/EF2xfvckj3pcrriZG7i
 xeaOopCQu5Ordpf6c8u+2szqn7M81xKaNbXeZGWAsjcZnDLJAO
 ussH/zevxpFx8gW1PS2RiUAVvjfahVG5OW5AzxOe6rYGRXkIXn
 4lWVdJ1SlNzp5Jx5zOPhdRpMQJziWRLfAzchuCvRbizlTnkSgS
 udR1EwNQvwtW4xoVBnu32oaCj7rouEdkwTU783RjNRYvRX7o0V
 RV4NVEuAvKIMr3s9fHJTX6blhQOLRZfx/VWBu7OlGIb2p5eyNo
 YbW+cY0wSYDnw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 09:01 +0100, Mike Galbraith wrote: 
> On Tue, 2014-01-14 at 02:31 -0500, Len Brown wrote: 
> > > This is a false alarm.
> > 
> > Thanks for the follow-up, Mel.
> > 
> > Agreed, it makes no sense for ebizzy measure 'throughput', when a
> > library debug bottleneck
> > prevents it from scaling past 3% CPU utilization.
> > 
> > Still, the broken configuration did find a difference due to the
> > addition of CLFLUSH on this box.
> > It makes me wonder if we will find issues on workloads that may depend
> > on the latency
> > of idle entry/exit, or perhaps sensitivity to the state of the cache
> > line containing thread_info->flags.
> > 
> > If somebody runs into such a workload, please try changing this 1 line
> > of intel_idle.c to limit
> > the CLFLUSH to C-states deeper than C1E, and let me know what you see.
> > 
> > - if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
> > + if ((eax > 1) && this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
> >           clflush((void *)&current_thread_info()->flags);
> 
> Hm, seems any high frequency switcher scheduling cross-core (pipe-test,
> or maybe a tbench pair) should show the cost to an affected box.

Oh yeah.. :) unless of course it's a Q6600 (poke poke).

