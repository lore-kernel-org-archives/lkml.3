Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbaGUSg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:36:56 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:32809 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404AbaGUSgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:36:54 -0400
Message-ID: <53CD5DC6.3030605@gmail.com>
Date: Mon, 21 Jul 2014 12:36:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>, Andi Kleen <andi@firstfloor.org>
CC: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 00/19] perf tools: Factor ordered samples queue
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>	<53CCB6AE.6020505@intel.com> <20140721080219.GA4183@krava.redhat.com>	<53CCD3A7.5070002@intel.com> <20140721095415.GB8865@krava.redhat.com> <87d2cy3c7m.fsf@tassilo.jf.intel.com> <53CD5AB5.3000307@intel.com>
In-Reply-To: <53CD5AB5.3000307@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/14, 12:23 PM, Adrian Hunter wrote:
> On 21/07/2014 7:31 p.m., Andi Kleen wrote:
>> Jiri Olsa <jolsa@redhat.com> writes:
>>>
>>> [jolsa@ibm-x3650m4-01 perf]$ sudo ./perf report --stdio
>>> Timestamp below last timeslice flush
>>> 0x2276f58 [0x68]: failed to process type: 9
>>
>> FWIW we're seeing this frequently too.
>
> Jiri's example didn't work for me.  Do you have one?

$ perf sched record  -m 8192 -- perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

      Total time: 0.087 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

      Total time: 12.043 [sec]

       12.043779 usecs/op
           83030 ops/sec

[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 289.549 MB perf.data (~12650569 samples) ]
0x54b4828 [0]: failed to process type: 0

No overload condition, no dropped chunks message - yet can't process events.

David
