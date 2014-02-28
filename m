Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbaB1TJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 14:09:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:37096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbaB1TJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 14:09:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,563,1389772800"; 
   d="scan'208";a="483797946"
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
	<1393609388-40489-9-git-send-email-dzickus@redhat.com>
Date: Fri, 28 Feb 2014 11:08:59 -0800
In-Reply-To: <1393609388-40489-9-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Fri, 28 Feb 2014 12:42:57 -0500")
Message-ID: <87lhwvawc4.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:
> +
> +static const struct perf_evsel_str_handler handlers[] = {
> +	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load, },
> +	{ "cpu/mem-stores/pp",	       perf_c2c__process_store, },

The 30 magic number should probably be configurable.

Using load-latency here rules out Atom, so at some point
you would need to get rid of that.

I suspect on most systems you should rather use p 
instead of pp to get the overhead down (before Haswell pp
is expensive)

> +static int perf_c2c__record(int argc, const char **argv)
> +{
> +	unsigned int rec_argc, i, j;
> +	const char **rec_argv;
> +	const char * const record_args[] = {
> +		"record",
> +		/* "--phys-addr", */

So is that needed or not?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
