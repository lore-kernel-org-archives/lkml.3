Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaJGHiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 03:38:23 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50839 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaJGHiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 03:38:21 -0400
Message-ID: <5433985B.6060800@gmail.com>
Date: Tue, 07 Oct 2014 16:38:03 +0900
From: taeung <treeze.taeung@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-perf-users@vger.kernel.org, acme@kernel.org,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf top: Add a visual cue for toggle zeroing of samples
References: <1412491774-2971-1-git-send-email-treeze.taeung@gmail.com> <87a958h2mc.fsf@sejong.aot.lge.com>
In-Reply-To: <87a958h2mc.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for answering.

I resend a patch according to your advices.

And I also added the stdio output to the patch as below.

If you have time and check the patch I resend,
I'd appreciate it.

Thanks,
Taeung

On 10/07/2014 02:26 PM, Namhyung Kim wrote:
> Hi Taeung,
>
> On Sun,  5 Oct 2014 15:49:34 +0900, Taeung Song wrote:
>> When 'perf top' is run, one can't easily find a difference
>> between -z option and normal output.
>> So I added a visual cue to know whether it is the zeroing or not.
>
> [SNIP]
>> +static int hists__browser_title(struct hists *hists,
>> +				struct hist_browser_timer *hbt,
>> +				char *bf,
>> +				size_t size)
> You don't need to align arguments like this.
>
>
>>   {
>>   	char unit;
>>   	int printed;
>> @@ -1256,6 +1268,14 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size)
>>   	if (dso)
>>   		printed += scnprintf(bf + printed, size - printed,
>>   				    ", DSO: %s", dso->short_name);
>> +	if (!is_report_browser(hbt)) {
>> +		struct perf_top *top = hbt->arg;
>> +
>> +		if (top->zero)
>> +			printed += scnprintf(bf + printed, size - printed,
>> +					     ", [z]", "");
> It seems the final empty string can go away.  And personally I'd like to
> get rid of "," before "[z]" also.
>
> Otherwise looks good to me.  Could you please take a look at the stdio
> output too?
>
> Thanks,
> Namhyung
>
>
>> +	}
>> +
>>   	return printed;
>>   }
>>   
>> @@ -1267,12 +1287,6 @@ static inline void free_popup_options(char **options, int n)
>>   		zfree(&options[i]);
>>   }
>>   
>> -/* Check whether the browser is for 'top' or 'report' */
>> -static inline bool is_report_browser(void *timer)
>> -{
>> -	return timer == NULL;
>> -}
>> -
>>   /*
>>    * Only runtime switching of perf data file will make "input_name" point
>>    * to a malloced buffer. So add "is_input_name_malloced" flag to decide

