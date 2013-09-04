Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817Ab3IDRw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:52:28 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:46175 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762957Ab3IDRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:52:26 -0400
Message-ID: <52277350.6090600@linux.vnet.ibm.com>
Date: Wed, 04 Sep 2013 23:22:16 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 1/2] SDT markers listing by perf
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903073655.4793.20013.stgit@hemant-fedora> <5226DF97.3000704@hitachi.com>
In-Reply-To: <5226DF97.3000704@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090417-7014-0000-0000-00000390055E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 12:51 PM, Masami Hiramatsu wrote:
> (2013/09/03 16:36), Hemant Kumar wrote:
>> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
>> index 5f720dc..f2d17b7 100644
>> --- a/tools/perf/util/symbol.h
>> +++ b/tools/perf/util/symbol.h
>> @@ -197,6 +197,17 @@ struct symsrc {
>>   #endif
>>   };
>>   
>> +/* Note structure */
>> +struct sdt_note {
>> +	const char *name;
>> +	const char *provider;
>> +	union {
>> +		Elf64_Addr a64[3];
>> +		Elf32_Addr a32[3];
>> +	} addr;
>> +	struct sdt_note *next;
>> +};
> Hmm, could you use struct list_head for listing up the data?
>
> Thank you,
>

Yes, it will be better to use struct list_head for fetching the markers 
in a list. Will do that in the next iteration.

Thanks
Hemant

