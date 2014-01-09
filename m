Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaAIBzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:55:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53137 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbaAIBzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:55:42 -0500
X-IronPort-AV: E=Sophos;i="4.95,627,1384272000"; 
   d="scan'208";a="9393124"
Message-ID: <52CEB7ED.9000502@cn.fujitsu.com>
Date: Thu, 09 Jan 2014 09:53:33 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, dsahern@gmail.com,
        artagnon@gmail.com
Subject: Re: [PATCH 3/8] perf tools: free aliases[j] in pmu.c if name_only
 is true.
References: <cover.1388416837.git.yangds.fnst@cn.fujitsu.com> <f4427175be649aa6cdf477980051688c525b46ab.1388416837.git.yangds.fnst@cn.fujitsu.com> <20140108151233.GB2626@infradead.org>
In-Reply-To: <20140108151233.GB2626@infradead.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 09:54:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/09 09:54:37,
	Serialize complete at 2014/01/09 09:54:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 10:12 AM, Arnaldo Carvalho de Melo wrote:
> What for? Please be clear in the changelogs, it helps with review.
>
> Now I'll have to follow the logic to figure this out, i.e. _why_ we
> should free aliases[j] if name_only is true? Is it safe?

Sorry for my lazy on the changelogs here :(.

As aliases is a 2-D array malloced in function print_pmu_events(), we 
should free it after printf. But we just did it when (!name_only).

This patch fix the leak error in print_pmu_events() when name_only is true.

I will update the commit message in next version.

- Yang
>
> - Arnaldo
>
> Em Mon, Dec 30, 2013 at 10:26:38AM -0500, Dongsheng Yang escreveu:
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>>   tools/perf/util/pmu.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
>> index 331dc2c..169c480 100644
>> --- a/tools/perf/util/pmu.c
>> +++ b/tools/perf/util/pmu.c
>> @@ -752,6 +752,7 @@ unsigned int print_pmu_events(const char *event_glob, bool name_only)
>>   	for (j = 0; j < len; j++) {
>>   		if (name_only) {
>>   			printf("%s ", aliases[j]);
>> +			zfree(&aliases[j]);
>>   			count++;
>>   			continue;
>>   		}
>> -- 
>> 1.8.2.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

