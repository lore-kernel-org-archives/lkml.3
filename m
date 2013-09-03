Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860Ab3ICNSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:18:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:19801 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782Ab3ICNSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:18:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1014,1367996400"; 
   d="scan'208";a="355241859"
Message-ID: <5225E320.8090307@intel.com>
Date: Tue, 03 Sep 2013 16:24:48 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: latest perf code fails to parse existing data file
References: <5225051C.3030608@gmail.com> <5225844E.3090700@intel.com> <5225DAFB.1070406@gmail.com>
In-Reply-To: <5225DAFB.1070406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/13 15:50, David Ahern wrote:
> On 9/3/13 12:40 AM, Adrian Hunter wrote:
>> On 03/09/13 00:37, David Ahern wrote:
>>> Arnaldo/Adrian:
>>>
>>> Latest acme core tree fails to parse an existing data file:
>>>
>>> $ perf trace -i perf.data
>>> 0x16b8 [0x40]: failed to process type: 1
>>> Failed to process events, error -22
>>
>> I can't reproduce this.  The following works:
>>
>>     $ perf --version
>>     perf version 3.9.10-100.fc17.x86_64
>>     $ sudo perf record -e raw_syscalls:* ls
>>     ...
>>     $ tools/perf/perf --version
>>     perf version 3.11.rc4.g31cd38
>>     $ sudo tools/perf/perf script
>>     ...
>>     $ sudo tools/perf/perf trace -i perf.data
>>     ...
> 
> Kernel version? Is your kernel side support there?

The kernel version is the same as the perf version i.e. 3.9

> 
> For me data was collected on 2.6.34 about a week ago. Processed fine up to
> the point of this patch getting added.

Is it only "perf trace" that fails or does "perf script" fail too?

