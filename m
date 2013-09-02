Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab3IBHqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:46:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:13231 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289Ab3IBHqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:46:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1005,1367996400"; 
   d="scan'208";a="372125553"
Message-ID: <522443CE.5030703@intel.com>
Date: Mon, 02 Sep 2013 10:52:46 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 24/25] perf tools: Add multi file '-M' option for record
 command
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com> <1378031796-17892-25-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378031796-17892-25-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/13 13:36, Jiri Olsa wrote:
> split event data into multiple files based on the file
> size or time delta specified as an argument to the option.
> 
> Adding multi file '-M' option for record command to store
> output perf.data into multiple files based on the size
> threshold.
> 
> The threshold is specified either as size (B/K/M/G) or time
> (s/m/h) by appending the size with appropriate unit, like:
>   -M 5M for 5 megabytes threshold
>   -M 1h for 1 hour threshold
> The generated name for each data file is appended with sequential
> number (prepended by 5 zeros).For default output file name it
> will be:
>   perf.data-00000
>   perf.data-00001
>   perf.data-00002
>   ...
> 
> Also watermark/wakeup_watermark is set accordingly to get
> wake ups more often so we could get close enough to the
> file size promise.
> 
> Example:
>   $ perf record -M 5M yes > /dev/null
>   ^C[ perf record: Woken up 228 times to write data ]
>   [ perf record: Captured and wrote 20.246 MB perf.data-[0-4](~884542 samples) ]
>   yes: Interrupt
>   $ ls -l perf.data-0*
>   -rw------- 1 jolsa jolsa 5289856 Aug 16 16:07 perf.data-00000
>   -rw------- 1 jolsa jolsa 5296008 Aug 16 16:08 perf.data-00001
>   -rw------- 1 jolsa jolsa 5344968 Aug 16 16:09 perf.data-00002
>   -rw------- 1 jolsa jolsa 5309144 Aug 16 16:09 perf.data-00003
>   -rw------- 1 jolsa jolsa 2358268 Aug 16 16:09 perf.data-00004

Did you consider doing this with "perf inject" instead of "perf record"?
That way you could get the split exactly right, and you could split the same
file different ways.


