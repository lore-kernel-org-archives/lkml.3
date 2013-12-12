Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab3LLMfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:35:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:13187 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab3LLMfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:35:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,878,1378882800"; 
   d="scan'208";a="451148711"
Message-ID: <52A9ADA1.6070104@intel.com>
Date: Thu, 12 Dec 2013 14:35:45 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 54/71] perf script: Always allow fields 'addr' and
 'cpu' for itrace
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-55-git-send-email-alexander.shishkin@linux.intel.com> <52A8BFDC.1090205@gmail.com>
In-Reply-To: <52A8BFDC.1090205@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 21:41, David Ahern wrote:
> On 12/11/13, 5:37 AM, Alexander Shishkin wrote:
>> From: Adrian Hunter <adrian.hunter@intel.com>
>>
>> If a file contains Instruction Tracing data then always allow
>> fields 'addr' and 'cpu' to be selected as options for perf
>> script.  This is necessary because Instruction Trace decoding
>> may synthesize events with that information.
> 
> Why hardcode it? If it is present and the user opts for it then it will be
> printed. Why is the itrace check needed?

itrace synthesizes events, so the events do not exist until the decoding
starts, thus the validation prevents you from having 'addr' or 'cpu' even
though they will show up in events later.

