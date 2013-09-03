Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab3ICGdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:33:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:49251 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab3ICGdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:33:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1012,1367996400"; 
   d="scan'208";a="397349203"
Message-ID: <5225844E.3090700@intel.com>
Date: Tue, 03 Sep 2013 09:40:14 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: latest perf code fails to parse existing data file
References: <5225051C.3030608@gmail.com>
In-Reply-To: <5225051C.3030608@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/13 00:37, David Ahern wrote:
> Arnaldo/Adrian:
> 
> Latest acme core tree fails to parse an existing data file:
> 
> $ perf trace -i perf.data
> 0x16b8 [0x40]: failed to process type: 1
> Failed to process events, error -22

I can't reproduce this.  The following works:

	$ perf --version
	perf version 3.9.10-100.fc17.x86_64
	$ sudo perf record -e raw_syscalls:* ls
	...
	$ tools/perf/perf --version
	perf version 3.11.rc4.g31cd38
	$ sudo tools/perf/perf script
	...
	$ sudo tools/perf/perf trace -i perf.data
	...

> 
> git bisect traced it to:
> $ git bisect bad
> 75562573bab35b129cfd342fc2bcf89da84a6644 is the first bad commit
> commit 75562573bab35b129cfd342fc2bcf89da84a6644
> Author: Adrian Hunter <adrian.hunter@intel.com>
> Date:   Tue Aug 27 11:23:09 2013 +0300
> 
>     perf tools: Add support for PERF_SAMPLE_IDENTIFIER
> 
>     Enable parsing of samples with sample format bit PERF_SAMPLE_IDENTIFIER.
>     In addition, if the kernel supports it, prefer it to selecting
>     PERF_SAMPLE_ID thereby allowing non-matching sample types.
> 
>     Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>     Cc: David Ahern <dsahern@gmail.com>
>     Cc: Frederic Weisbecker <fweisbec@gmail.com>
>     Cc: Ingo Molnar <mingo@kernel.org>
>     Cc: Jiri Olsa <jolsa@redhat.com>
>     Cc: Mike Galbraith <efault@gmx.de>
>     Cc: Namhyung Kim <namhyung@gmail.com>
>     Cc: Paul Mackerras <paulus@samba.org>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Cc: Stephane Eranian <eranian@google.com>
>     Link:
> http://lkml.kernel.org/r/1377591794-30553-8-git-send-email-adrian.hunter@intel.com
> 
>     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> :040000 040000 7df758341904d77c391b90ab6b6bac97324d144a
> 93839bad8ab2e6d88d3037f3dc8fd721be5e8870 M    tools
> 
> 
> If I revert the patch (and handle the missing __perf_evsel__sample_size in
> the tests code to get it to compile) it works -- file is parsed correctly.
> 
> David
> 
> 

