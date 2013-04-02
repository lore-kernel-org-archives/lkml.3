Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766Ab3DBB4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 21:56:41 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51339 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758981Ab3DBB4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 21:56:40 -0400
X-AuditID: 9c930197-b7c9dae000006959-95-515a3ad356fd
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 5/9] perf sort: Separate out memory-specific sort keys
References: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
	<1364816125-12212-6-git-send-email-namhyung@kernel.org>
	<20130401202937.GA1022@krava.redhat.com>
Date: Tue, 02 Apr 2013 10:56:35 +0900
In-Reply-To: <20130401202937.GA1022@krava.redhat.com> (Jiri Olsa's message of
	"Mon, 1 Apr 2013 22:29:37 +0200")
Message-ID: <871uathezw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Apr 2013 22:29:37 +0200, Jiri Olsa wrote:
> On Mon, Apr 01, 2013 at 08:35:21PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>> +
>>  int sort_dimension__add(const char *tok)
>>  {
>>  	unsigned int i;
>> @@ -964,6 +971,33 @@ int sort_dimension__add(const char *tok)
>>  		return 0;
>>  	}
>>  
>> +	for (i = 0; i < ARRAY_SIZE(memory_sort_dimensions); i++) {
>> +		struct sort_dimension *sd = &memory_sort_dimensions[i];
>> +
>> +		if (strncasecmp(tok, sd->name, strlen(tok)))
>> +			continue;
>> +
>> +		if (sort__mode != SORT_MODE__MEMORY)
>> +			return -EINVAL;
>> +
>> +		if (sd->entry == &sort_mem_daddr_sym)
>> +			sort__has_sym = 1;
>> +
>> +		if (sd->taken)
>> +			return 0;
>> +
>> +		if (sd->entry->se_collapse)
>> +			sort__need_collapse = 1;
>> +
>> +		if (list_empty(&hist_entry__sort_list))
>> +			sort__first_dimension = i + __SORT_MEMORY_MODE;
>> +
>> +		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
>> +		sd->taken = 1;
>> +
>> +		return 0;
>
> nice idea, I wonder some of the above code be put into function
> and used also in previous loop, no big deal though

Hmm.. okay.  I'll try. :)

Thanks,
Namhyung
