Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab3HGT1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:27:35 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:49974 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab3HGT1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:27:34 -0400
Date: Wed, 7 Aug 2013 16:27:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] perf kvm: option to print events that exceed a
 threshold
Message-ID: <20130807192725.GD2665@ghostprotocols.net>
References: <1375753297-69645-1-git-send-email-dsahern@gmail.com>
 <1375753297-69645-5-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375753297-69645-5-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 05, 2013 at 09:41:36PM -0400, David Ahern escreveu:
> This is useful to spot high latency blips. It is normal for HLT
> reasons to have long exit times, so strip those from the threshold
> check.

So 'perf trace' has a similar option:

[acme@zoo linux]$ perf trace --help
<SNIP>
        --duration <float>
                          show only events with duration > N.M ms
<SNIP>

While you used:
 
> +		OPT_U64('T', "threshold", &kvm->threshold,
> +		    "show events other than HALT that take longer than threshold usecs"),

I prefer 'duration', and haven't assigned a single letter to it, they
are scarce and we have shell long option completion, what do you think?

The term was chosen, for 'perf trace' on the original patchset:

http://lwn.net/Articles/415728/

- Arnaldo
