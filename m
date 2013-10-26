Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab3JZJu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 05:50:28 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:45163 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3JZJu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 05:50:27 -0400
Date: Sat, 26 Oct 2013 11:50:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
Message-ID: <20131026095023.GF14237@gmail.com>
References: <20131023044511.1886.82571.stgit@hemant-fedora>
 <20131023050502.1886.15779.stgit@hemant-fedora>
 <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
 <20131025125921.GA29424@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025125921.GA29424@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> Hi Pekka,
> 
> > >
> > > You can now use it in all perf tools, such as:
> > >
> > >     perf record -e libc:my_event -aR sleep 1
> > 
> > Is there a technical reason why 'perf list' could not show all the
> > available SDT markers on a system and that the 'market to event'
> > mapping cannot happen automatically?
> > 
> 
> Technically feasible. But then we would have to parse each of the 
> libraries and executables to list them. Right? I am not sure if 
> such a delay is acceptable.

I'd say lets try Pekka's suggestion and make it more palatable if 
there's complaints about the delay. (SSD systems are becoming 
dominant and there the search should be reasonably fast.)

We could also make 'perf list' more sophisticated, if invoked 
naively as 'perf list' then maybe it should first display the 
various event categories, with a (rough) count:

$ perf list
   34 hardware events       # use 'perf list --hw'    to list them
   40 hw-cache events       # use 'perf list --cache' to list them
   20 software events       # use 'perf list --sw'    to list them
    2 raw events            # use 'perf list --raw'   to list them
  120 tracepoints           # use 'perf list --tp'    to list them
  >10 SDT tracepoints       # use 'perf list --sdt'   to list them

 # use 'perf list -a' to list all events
 # use 'perf list ./binary' to list events in a given binary

I.e. bring a bit more structure into it.

> Also if a binary exists in a path thats is not covered in the 
> default search, an user might believe that his binary may not have 
> markers. I know the above reason is more of a user folly than a 
> tooling issue.

I think in 99% of the usecases people will either use pre-built 
markers that come with their distro, or will be intimately aware of 
the markers because they are in the very app they are developing.

So I wouldn't worry about 'user has a weird binary' case too much.

I agree with Pekka that making them easily discoverable and visible 
as a coherent whole is really important.

Thanks,

	Ingo
