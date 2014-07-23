Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbaGWG0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:26:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:8440 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177AbaGWG0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:26:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,715,1400050800"; 
   d="scan'208";a="565881049"
Message-ID: <53CF5559.8050908@intel.com>
Date: Wed, 23 Jul 2014 09:25:29 +0300
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
Subject: Re: [PATCH 17/52] perf evlist: Add perf_evlist__set_tracking_event()
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com> <1406035081-14301-18-git-send-email-adrian.hunter@intel.com> <20140722192206.GD29750@krava.redhat.com>
In-Reply-To: <20140722192206.GD29750@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 10:22 PM, Jiri Olsa wrote:
> On Tue, Jul 22, 2014 at 04:17:26PM +0300, Adrian Hunter wrote:
> 
> SNIP
> 
>>  }
>> +
>> +int perf_evlist__set_tracking_event(struct perf_evlist *evlist,
>> +				    struct perf_evsel *tracking_evsel)
>> +{
>> +	struct perf_evsel *evsel;
>> +
>> +	if (tracking_evsel->idx == 0)
>> +		return 0;
>> +
>> +	if (tracking_evsel->leader->nr_members > 1)
>> +		return -EINVAL;
>> +
>> +	list_for_each_entry(evsel, &evlist->entries, node) {
>> +		if (evsel->idx < tracking_evsel->idx)
>> +			evsel->idx += 1;
>> +	}
>> +	tracking_evsel->idx = 0;
>> +
>> +	return 0;
>> +}
> 
> wouldnt it be better to add evsel->is_tracking bool for this?

Yes, I will look at doing that instead.

