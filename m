Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967516AbaFTNVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:21:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:35031 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966749AbaFTNVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:21:12 -0400
Date: Fri, 20 Jun 2014 10:21:05 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf trace pagefaults
Message-ID: <20140620132105.GE31524@kernel.org>
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 20, 2014 at 02:49:42PM +0400, Stanislav Fomichev escreveu:
> This patch series adds support for pagefaults tracing to 'perf trace' command.
> It seems this feature was planned by Namhyung Kim (http://events.linuxfoundation.org/images/stories/pdf/klf2012_n_kim.pdf page 17/28)
> but I couldn't find any prior patches/discussion and started from scratch.

Just to clarify here, those slides came from slides I made and in turn
the whole idea about pagefaults tracing I got from the trace prototype
that Thomas Gleixner implemented in his 'trace'  utility, described
here:

  Announcing a new utility: 'trace'
  http://lwn.net/Articles/415728/

The comments section has lots of interesting ideas, some you may find
interesting to implement :-)

There is a branch in my tree with the branch tglx did his work on:

https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=tmp.perf/trace2

There you can take a look and compare what you're doing to what he did.

Now I'll go thru your current patches and will cherry pick whatever I
think its OK already, and will try and provide comments for whatever I
think needs more work.

- Arnaldo
 
> First three patches add the feature and options to enable faults and disable
> syscalls.
> Two last patches add events caching (like it's done in the perf kvm), so that
> we don't get fault events prior to mmap/comm events (makes sense only
> for live mode).
> 
> This is just a proof-of-concept, and I'd like to get some comments about
> where and what I got wrong and what additional useful information I can
> expose in the trace.
> 
> v2:
>   - added more info to the changelogs
>   - reworked options (-f -> -F, --pgfaults -> --pf=[all|min|maj])
>   - separated tracepoint_handler changes into additional patch
>   - separated record/replay into additional patch
>   - other fixes pointed out by Arnaldo Carvalho de Melo
> 
> Stanislav Fomichev (7):
>   perf trace: add perf_event parameter to tracepoint_handler
>   perf trace: add support for pagefault tracing
>   perf trace: add pagefaults record and replay support
>   perf trace: add pagefault statistics
>   perf trace: add possibility to switch off syscall events
>   perf kvm: move perf_kvm__mmap_read into session utils
>   perf trace: add events cache
> 
>  tools/perf/Documentation/perf-trace.txt |  19 ++
>  tools/perf/builtin-kvm.c                |  88 +-------
>  tools/perf/builtin-trace.c              | 350 ++++++++++++++++++++++----------
>  tools/perf/util/session.c               |  85 ++++++++
>  tools/perf/util/session.h               |   5 +
>  5 files changed, 357 insertions(+), 190 deletions(-)
> 
> -- 
> 1.8.3.2
