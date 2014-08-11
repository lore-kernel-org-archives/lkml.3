Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaHKMr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:47:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:7678 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaHKMr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:47:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,841,1400050800"; 
   d="scan'208";a="574959836"
Message-ID: <53E8BB34.1050700@intel.com>
Date: Mon, 11 Aug 2014 15:46:44 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 13/41] perf tools: Add machine__kernel_ip()
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-14-git-send-email-adrian.hunter@intel.com> <20140716141519.GC9441@krava.redhat.com> <53C68A9E.6060302@intel.com> <20140811122321.GB26811@krava.brq.redhat.com> <53E8B8D8.4040809@intel.com> <20140811124330.GA31858@krava.brq.redhat.com>
In-Reply-To: <20140811124330.GA31858@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 03:43 PM, Jiri Olsa wrote:
> On Mon, Aug 11, 2014 at 03:36:40PM +0300, Adrian Hunter wrote:
>> On 08/11/2014 03:23 PM, Jiri Olsa wrote:
>>> On Wed, Jul 16, 2014 at 05:22:22PM +0300, Adrian Hunter wrote:
>>>> On 16/07/2014 5:15 p.m., Jiri Olsa wrote:
>>>>> On Mon, Jul 14, 2014 at 01:02:37PM +0300, Adrian Hunter wrote:
>>>>>
>>>>> SNIP
>>>>>
>>>>>> +
>>>>>> +int machine__get_kernel_start(struct machine *machine)
>>>>>> +{
>>>>>> +	struct map *map = machine__kernel_map(machine, MAP__FUNCTION);
>>>>>> +	int err = 0;
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * The only addresses above 2^63 are kernel addresses of a 64-bit
>>>>>> +	 * kernel.  Note that addresses are unsigned so that on a 32-bit system
>>>>>> +	 * all addresses including kernel addresses are less than 2^32.  In
>>>>>> +	 * that case (32-bit system), if the kernel mapping is unknown, all
>>>>>> +	 * addresses will be assumed to be in user space - see
>>>>>> +	 * machine__kernel_ip().
>>>>>> +	 */
>>>>>> +	machine->kernel_start = 1ULL << 63;
>>>>>> +	if (map) {
>>>>>> +		err = map__load(map, machine->symbol_filter);
>>>>>> +		if (map->start)
>>>>>> +			machine->kernel_start = map->start;
>>>>>> +	}
>>>>>> +	return err;
>>>>>> +}
>>>>>
>>>>> we just recently got machine__get_kernel_start_addr function,
>>>>> I think we want just one function for this
>>>>
>>>> They do quite different things.
>>>>
>>>
>>> so one of those two should have different name
>>
>> Such as?
> 
> dont know ;-) but if they do 'quite different things' as u said,
> I expect to see that at least in the function name

How about:

	machine__get_kernel_start_addr -> machine__get_running_kernel_start


