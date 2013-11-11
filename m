Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab3KKUu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:50:56 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:63605 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3KKUut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:50:49 -0500
Date: Mon, 11 Nov 2013 21:50:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/10] perf machine: Introduce synthesize_threads method
 out of open coded equivalent
Message-ID: <20131111205045.GE18886@gmail.com>
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
 <1384201353-23863-5-git-send-email-acme@infradead.org>
 <528140DB.90301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528140DB.90301@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 11/11/13, 1:22 PM, Arnaldo Carvalho de Melo wrote:
> >+	if (perf_target__has_task(target))
> >+		return perf_event__synthesize_thread_map(tool, threads, process, machine, data_mmap);
> >+	else if (perf_target__has_cpu(target))
> >+		return perf_event__synthesize_threads(tool, process, machine, data_mmap);
> 
> 
> Getting kind of long on the line lengths...

Maybe we could start losing most of the perf_ prefixes - it's all about 
perf here, so it does not really add much information, does it?

that would turn it into:

	if (target__has_task(target))
		return event__synthesize_thread_map(tool, threads, process, machine, data_mmap);
	else if (target__has_cpu(target))
		return event__synthesize_threads(tool, process, machine, data_mmap);

Another trick would be to combine (tool, machine) into a single helper 
struct (struct context *ctx?), if that is mostly a constant combination 
describing tool environment, which gets passed deep inside the guts of 
functions.

Thanks,

	Ingo
