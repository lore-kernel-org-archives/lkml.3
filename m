Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3F0HxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:53:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:63427 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab3F0HxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:53:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="336252999"
Message-ID: <51CBF0CC.9040106@intel.com>
Date: Thu, 27 Jun 2013 10:59:08 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 06/15] perf tools: fix parse_events_terms() freeing local
 variable on error path
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-7-git-send-email-adrian.hunter@intel.com> <20130625131359.GC23329@krava.brq.redhat.com>
In-Reply-To: <20130625131359.GC23329@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/13 16:13, Jiri Olsa wrote:
> On Mon, Jun 24, 2013 at 04:16:03PM +0300, Adrian Hunter wrote:
>> The list_head is on the stack, so just free the rest of the list.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/pmu.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
>> index 4c6f9c4..def64d4 100644
>> --- a/tools/perf/util/pmu.c
>> +++ b/tools/perf/util/pmu.c
>> @@ -194,7 +194,8 @@ static int pmu_alias_terms(struct perf_pmu_alias *alias,
>>  	list_for_each_entry(term, &alias->terms, list) {
>>  		ret = parse_events_term__clone(&clone, term);
>>  		if (ret) {
>> -			parse_events__free_terms(&list);
>> +			list_for_each_entry_safe(term, clone, &list, list)
>> +				free(term);
> 
> Could you please add __parse_events__free_terms doing this
> and being called from parse_events__free_terms as you did
> for __perf_evlist__munmap in the other patch.

Thanks for reviewing.  Fixed in V2.

