Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab3KEHRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:17:55 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61531 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3KEHRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:17:54 -0500
X-AuditID: 9c930179-b7c44ae000000c83-4f-52789ba03ebd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH 03/14] perf hists: Convert hist entry functions to use struct he_stat
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
	<1383202576-28141-4-git-send-email-namhyung@kernel.org>
	<20131104234551.GC7478@ghostprotocols.net>
Date: Tue, 05 Nov 2013 16:17:52 +0900
In-Reply-To: <20131104234551.GC7478@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 4 Nov 2013 20:45:51 -0300")
Message-ID: <87fvrbz59b.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Mon, 4 Nov 2013 20:45:51 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Oct 31, 2013 at 03:56:05PM +0900, Namhyung Kim escreveu:
>
>> -static void hist_entry__add_cpumode_period(struct hist_entry *he,
>> +static void hist_entry__add_cpumode_period(struct he_stat *he_stat,
>>  					   unsigned int cpumode, u64 period)
>
> So it is not anymore a 'struct hist_entry' method, but a 'struct
> he_stat' one, thus these functions need to be renamed accordingly, in
> the above case it should be:
>
> -static void hist_entry__add_cpumode_period(struct hist_entry *he,
> +static void he_stat__add_cpumode_period(struct he_stat *he_stat,
> +				 	 unsigned int cpumode, u64 period)

I see your point.  Will change the both.

Thanks,
Namhyung

>
>>  {
>>  	switch (cpumode) {
>>  	case PERF_RECORD_MISC_KERNEL:
>> -		he->stat.period_sys += period;
>> +		he_stat->period_sys += period;
>>  		break;
>>  	case PERF_RECORD_MISC_USER:
>> -		he->stat.period_us += period;
>> +		he_stat->period_us += period;
>>  		break;
>>  	case PERF_RECORD_MISC_GUEST_KERNEL:
>> -		he->stat.period_guest_sys += period;
>> +		he_stat->period_guest_sys += period;
>>  		break;
>>  	case PERF_RECORD_MISC_GUEST_USER:
>> -		he->stat.period_guest_us += period;
>> +		he_stat->period_guest_us += period;
>>  		break;
>>  	default:
>>  		break;
>> @@ -223,10 +223,10 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
>>  	dest->weight		+= src->weight;
>>  }
>>  
>> -static void hist_entry__decay(struct hist_entry *he)
>> +static void hist_entry__decay(struct he_stat *he_stat)
>
> Ditto
>
>>  {
>> -	he->stat.period = (he->stat.period * 7) / 8;
>> -	he->stat.nr_events = (he->stat.nr_events * 7) / 8;
>> +	he_stat->period = (he_stat->period * 7) / 8;
