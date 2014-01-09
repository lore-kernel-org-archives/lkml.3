Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaAIBjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:39:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:9033 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbaAIBjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:39:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,627,1384272000"; 
   d="scan'208";a="9393005"
Message-ID: <52CEB42E.1020600@cn.fujitsu.com>
Date: Thu, 09 Jan 2014 09:37:34 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, dsahern@gmail.com,
        artagnon@gmail.com
Subject: Re: [PATCH 5/8] perf tools: Add support of name_only for print_events_type()
 function.
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com> <0ad3f31b5c2d27da0a4cbd82129821136f56a581.1388416837.git.yangds.fnst@cn.fujitsu.com> <20140108151928.GD2626@infradead.org>
In-Reply-To: <20140108151928.GD2626@infradead.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 09:38:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 09:38:39,
	Serialize complete at 2014/01/09 09:38:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 10:19 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 30, 2013 at 10:26:40AM -0500, Dongsheng Yang escreveu:
>> The all print_xxx_event() functions are supporting name_only argument except
>> print_event_type().
>>
>> This patch add an argument of name_only for print_events_type() function.
> This one looks ok, as the 'name_only' parameter name together with your
> changeset comments provides enough context to understand the patch at a
> glance.
>
> But it doesn't applies, as the previous one needs changes to address my
> comments,

Okey, Thanx
>
> - Arnaldo
>   
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>>   tools/perf/util/parse-events.c | 14 ++++++++------
>>   tools/perf/util/parse-events.h |  2 +-
>>   2 files changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
>> index e2a2066..d70f362 100644
>> --- a/tools/perf/util/parse-events.c
>> +++ b/tools/perf/util/parse-events.c
>> @@ -1122,7 +1122,7 @@ static bool is_event_supported(u8 type, unsigned config)
>>   }
>>   
>>   static unsigned int __print_events_type(u8 type, struct event_symbol *syms,
>> -					unsigned max)
>> +					unsigned max, bool name_only)
>>   {
>>   	char name[64];
>>   	unsigned i;
>> @@ -1137,20 +1137,22 @@ static unsigned int __print_events_type(u8 type, struct event_symbol *syms,
>>   				 syms->symbol, syms->alias);
>>   		else
>>   			snprintf(name, sizeof(name), "%s", syms->symbol);
>> -
>> -		printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
>> +		if (name_only)
>> +			printf("  %-50s\n", name);
>> +		else
>> +			printf("  %-50s [%s]\n", name, event_type_descriptors[type]);
>>   		count++;
>>   	}
>>   
>>   	return count;
>>   }
>>   
>> -unsigned int print_events_type(u8 type)
>> +unsigned int print_events_type(u8 type, bool name_only)
>>   {
>>   	if (type == PERF_TYPE_SOFTWARE)
>> -		return __print_events_type(type, event_symbols_sw, PERF_COUNT_SW_MAX);
>> +		return __print_events_type(type, event_symbols_sw, PERF_COUNT_SW_MAX, name_only);
>>   	else
>> -		return __print_events_type(type, event_symbols_hw, PERF_COUNT_HW_MAX);
>> +		return __print_events_type(type, event_symbols_hw, PERF_COUNT_HW_MAX, name_only);
>>   }
>>   
>>   unsigned int print_hwcache_events(const char *event_glob, bool name_only)
>> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
>> index bb7d674..148a767 100644
>> --- a/tools/perf/util/parse-events.h
>> +++ b/tools/perf/util/parse-events.h
>> @@ -102,7 +102,7 @@ void parse_events_update_lists(struct list_head *list_event,
>>   void parse_events_error(void *data, void *scanner, char const *msg);
>>   
>>   unsigned int print_events(const char *event_glob, bool name_only);
>> -unsigned int print_events_type(u8 type);
>> +unsigned int print_events_type(u8 type, bool name_only);
>>   unsigned int print_tracepoint_events(const char *subsys_glob, const char *event_glob,
>>   			     bool name_only);
>>   unsigned int print_hwcache_events(const char *event_glob, bool name_only);
>> -- 
>> 1.8.2.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

