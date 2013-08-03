Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3HCNpM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 09:45:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:15792 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab3HCNpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 09:45:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,807,1367996400"; 
   d="scan'208";a="277215272"
Message-ID: <51FD095F.8060208@intel.com>
Date: Sat, 03 Aug 2013 16:45:03 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V2 1/9] perf tools: add test for reading object code
References: <1375218838-31042-1-git-send-email-adrian.hunter@intel.com> <1375218838-31042-2-git-send-email-adrian.hunter@intel.com> <20130731141732.GD3614@ghostprotocols.net>
In-Reply-To: <20130731141732.GD3614@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/2013 5:17 p.m., Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 31, 2013 at 12:13:50AM +0300, Adrian Hunter escreveu:
>> Using the information in mmap events, perf tools can read object
>> code associated with sampled addresses.  A test is added that
>> compares bytes read by perf with the same bytes read using
>> objdump.
>
> So this parses objdump output, and we also already have the annotation
> logic that does that too, have you thought about having common routines
> for these two cases?

The annotation logic strips out the bytes (--no-show-raw) whereas the 
test extracts only the bytes, so they are not currently compatible.

>
> I mean the disasm_line, ins, ins_ops, ins_operands classes, that now
> lives in util/annotate.h but could be moved somewhere else,
> disconnecting it as much as possible from annotation, because probably
> there are more cool things we could do with that... :-)
>
> We could certainly do it incrementally, merging your current patch
> series and then working on sharing code on these two use cases, but
> perhaps you can do it now?
>
> What do you think?

I expect replacing objdump with library calls will end up being the way 
forward.
