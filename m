Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaGWG0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:26:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:20398 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaGWG0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:26:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,715,1400050800"; 
   d="scan'208";a="565880828"
Message-ID: <53CF5531.90709@intel.com>
Date: Wed, 23 Jul 2014 09:24:49 +0300
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
Subject: Re: [PATCH 13/52] perf tools: Add perf_pmu__scan_file()
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com> <1406035081-14301-14-git-send-email-adrian.hunter@intel.com> <20140722190901.GC29750@krava.redhat.com>
In-Reply-To: <20140722190901.GC29750@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 10:09 PM, Jiri Olsa wrote:
> On Tue, Jul 22, 2014 at 04:17:22PM +0300, Adrian Hunter wrote:
> 
> SNIP
> 
>> +
>> +static FILE *perf_pmu__open_file(struct perf_pmu *pmu, const char *name)
>> +{
>> +	struct stat st;
>> +	char path[PATH_MAX];
>> +	const char *sysfs;
>> +
>> +	sysfs = sysfs__mountpoint();
>> +	if (!sysfs)
>> +		return NULL;
>> +
>> +	snprintf(path, PATH_MAX,
>> +		 "%s" EVENT_SOURCE_DEVICE_PATH "%s/%s", sysfs, pmu->name, name);
>> +
>> +	if (stat(path, &st) < 0)
>> +		return NULL;
>> +
>> +	return fopen(path, "r");
>> +}
> 
> looks like this function could be used in pmu_cpumask and pmu_type
> and maybe others

There is existing code duplication between them.  Given the large number of
patches I would say it is easier to deal with that separately.

