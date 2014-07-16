Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187AbaGPOWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:22:30 -0400
Received: from mga14.intel.com ([192.55.52.115]:53594 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934205AbaGPOW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:22:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,672,1400050800"; 
   d="scan'208";a="562677981"
Message-ID: <53C68A9E.6060302@intel.com>
Date: Wed, 16 Jul 2014 17:22:22 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 13/41] perf tools: Add machine__kernel_ip()
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-14-git-send-email-adrian.hunter@intel.com> <20140716141519.GC9441@krava.redhat.com>
In-Reply-To: <20140716141519.GC9441@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/2014 5:15 p.m., Jiri Olsa wrote:
> On Mon, Jul 14, 2014 at 01:02:37PM +0300, Adrian Hunter wrote:
>
> SNIP
>
>> +
>> +int machine__get_kernel_start(struct machine *machine)
>> +{
>> +	struct map *map = machine__kernel_map(machine, MAP__FUNCTION);
>> +	int err = 0;
>> +
>> +	/*
>> +	 * The only addresses above 2^63 are kernel addresses of a 64-bit
>> +	 * kernel.  Note that addresses are unsigned so that on a 32-bit system
>> +	 * all addresses including kernel addresses are less than 2^32.  In
>> +	 * that case (32-bit system), if the kernel mapping is unknown, all
>> +	 * addresses will be assumed to be in user space - see
>> +	 * machine__kernel_ip().
>> +	 */
>> +	machine->kernel_start = 1ULL << 63;
>> +	if (map) {
>> +		err = map__load(map, machine->symbol_filter);
>> +		if (map->start)
>> +			machine->kernel_start = map->start;
>> +	}
>> +	return err;
>> +}
>
> we just recently got machine__get_kernel_start_addr function,
> I think we want just one function for this

They do quite different things.

