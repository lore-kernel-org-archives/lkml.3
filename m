Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229AbaHYOwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:52:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673AbaHYOwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:52:11 -0400
Date: Mon, 25 Aug 2014 16:51:34 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFCv2 0/9] perf: Allow leader sampling on inherited events
Message-ID: <20140825145134.GC24926@krava.brq.redhat.com>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 04:45:34PM +0200, Jiri Olsa wrote:
> hi,
> Jen-Cheng(Tommy) Huang reported the leader sampling not working
> on children processes:
>   http://www.mail-archive.com/linux-perf-users@vger.kernel.org/msg01644.html
> 
> The leader sampling (example below) lets the group leader event (cycles)
> do the sampling and reads the rest of the group (cache-misses) via
> PERF_FORMAT_GROUP format.
> 
> Example:
>   $ perf record -e '{cycles,cache-misses}:S' <workload>
>   $ perf report --group
> 
>   The perf report --group allows to see all events group
>   data in single view.
> 
> The reason for leader sampling being switched off for inherited
> events, is that the kernel does no allow PERF_FORMAT_GROUP format
> on inherited events (which is used by leader sampling).
> 
> I switched on the PERF_FORMAT_GROUP format for inherited events
> with few other fixies in patches:
>   perf: Deny optimized switch for events read by PERF_SAMPLE_READ
>   perf: Allow PERF_FORMAT_GROUP format on inherited events
> 
> And I fixed perf tool code to be able to process data from
> children processes.
> 
> Anyway, I might have missed some other reason why this was
> never switched on in kernel, so sending this as RFC.
> 
> v2 changes:
>    - detection of the kernel support
>    - added perf script support for period column
>    - separate kernel change for context_equiv change

and as usuall I forgot.. also reachable in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_format_group

jirka
