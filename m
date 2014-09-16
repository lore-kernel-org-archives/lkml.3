Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaIPHBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:01:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:63898 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbaIPHA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:00:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,533,1406617200"; 
   d="scan'208";a="477794100"
Message-ID: <5417DFD5.2090707@intel.com>
Date: Tue, 16 Sep 2014 09:59:33 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 22/24] perf tools: Build programs to copy 32-bit compatibility
 VDSOs
References: <1408129739-17368-1-git-send-email-adrian.hunter@intel.com> <1408129739-17368-23-git-send-email-adrian.hunter@intel.com> <20140915154752.GC11199@kernel.org> <20140915155049.GD11199@kernel.org>
In-Reply-To: <20140915155049.GD11199@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 06:50 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Sep 15, 2014 at 12:47:52PM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Fri, Aug 15, 2014 at 10:08:57PM +0300, Adrian Hunter escreveu:
>>
>>> perf tools copy VDSO out of memory.  However, on 64-bit machines there
>>> may be 32-bit compatibility VDOs also.  To copy those requires
>>> separate 32-bit executables.  This patch adds to the build additional
>>> programs perf-read-vdso32 and perf-read-vdsox32 for 32-bit and x32
>>> respectively.
>>  
>>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> <SNIP>
>>>  tools/perf/config/feature-checks/test-compile.c |  4 +++
>> <SNIP>
>>>  8 files changed, 149 insertions(+), 37 deletions(-)
>> <SNIP>
>>>  create mode 100644 tools/perf/config/feature-checks/test-compile.c
>> <SNIP>
>>
>>
>> In resolving conflicts that happen because I haven't merged some other
>> files (thread_stack, etC) I noticed that this patch introduces something
>> that is explicitely listed in a .gitignore file:
>>
>> [acme@zoo linux]$ git show d316f16dddd8c7780c727bbd507338e4147c9280
>> commit d316f16dddd8c7780c727bbd507338e4147c9280
>> Author: Alexander Shishkin <alexander.shishkin@linux.intel.com>
>> Date:   Fri Aug 15 22:08:59 2014 +0300
>>
>>     perf tools: Add feature checks to .gitignore
>>
>> <SNIP>
>>
>> +++ b/tools/perf/.gitignore
>> @@ -24,3 +24,4 @@ config.mak.autogen
>>  *-flex.*
>>  *.pyc
>>  *.pyo
>> +config/feature-checks/test-*
>> [acme@zoo linux]$
>>
>>
>> So I think we should use some different name for this test-compile.c
>> file?

The name is ok.

>>
>> I'll leave those two csets out of this pull req, so that you can rebase
>> what is left on top of what is being merged and we can do one more
>> progress step in having all this merged, ok?
> 
> Since we can't ignore all test- prefixed files there, I'm removing the
> patch that added it to .gitignore as well:
> 
> commit d316f16dddd8c7780c727bbd507338e4147c9280
> Author: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Date:   Fri Aug 15 22:08:59 2014 +0300
> 
> Aftewards I'll revisit this, because without this .gitignore patch I
> think your patch will be ok.

The .gitignore patch is wrong.  I picked it up because Alex had it in
his tree but it must be very old because it was superseded by:

commit 56560ec692c142bb9ee404764e3b67999031ad19
Author: Chunwei Chen <tuxoko@gmail.com>
Date:   Sat Dec 21 13:48:11 2013 +0800

    perf config: Ignore generated files in feature-checks
    
    1. Rename the test-* binary files to test-*.bin for easier pattern matching as
       suggested by Ingo.
    2. Ignore *.bin and *.d files.
    
    Signed-off-by: Chunwei Chen <tuxoko@gmail.com>
    Reviewed-by: Ingo Molnar <mingo@kernel.org>
    Acked-by: Jiri Olsa <jolsa@redhat.com>
    Cc: Ingo Molnar <mingo@kernel.org>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Link: http://lkml.kernel.org/r/52B52B9B.50708@gmail.com
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>



> 
> - Arnaldo
>  
>> I mean:
>>
>>>> Up-to-date versions can be found from 15 August:
>>>>
>>>>      patchwork:
>>>>
>>>>              https://patchwork.kernel.org/patch/4729131/
>>>>              https://patchwork.kernel.org/patch/4729111/
>>
>>
>> - Arnaldo
> 
> 

