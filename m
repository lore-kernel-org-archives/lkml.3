Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3JHNa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:30:57 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:40021 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3JHNax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:30:53 -0400
Message-ID: <52540902.6040500@linux.vnet.ibm.com>
Date: Tue, 08 Oct 2013 19:00:42 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v2 2/3] Support for perf to probe into SDT markers:
References: <20131007063911.11693.33624.stgit@hemant-fedora> <20131007064806.11693.23845.stgit@hemant-fedora> <5253F0E4.4080105@hitachi.com>
In-Reply-To: <5253F0E4.4080105@hitachi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100813-7014-0000-0000-000003BB1BE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 05:17 PM, Masami Hiramatsu wrote:
> (2013/10/07 15:48), Hemant Kumar wrote:
>> [...]
>> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
>> index cbd2383..6f09723 100644
>> --- a/tools/perf/builtin-probe.c
>> +++ b/tools/perf/builtin-probe.c
>> @@ -370,6 +370,17 @@ int cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>>   			pr_err("Error: Don't use --markers with --funcs.\n");
>>   			usage_with_options(probe_usage, options);
>>   		}
>> +		if (params.mod_events) {
>> +			ret = add_perf_probe_events(params.events,
>> +						    params.nevents,
>> +						    params.max_probe_points,
>> +						    params.target,
>> +						    params.force_add);
>> +			if (ret < 0) {
>> +				pr_err(" Error: Failed to add events. "
>> +				       " (%d)\n", ret);
>> +			}
>> +		}
> What is this code for? params.sdt is true only if "--markers" is set, and that
> should not be used with --add and --del, because it's an action "query markers".
> We should give an error and abort here.

Yeah, I see your point. We should not add an event in this case. Instead 
an error should be displayed. Thanks for pointing that. And we already 
have add_perf_probe_events() call. That should be called instead.

>
> Other points are covered by Namhyung's review(thanks!).
>
> Thank you!
>
Yeah, will make the required changes and post the next iteration ASAP.

-- 
Thanks
Hemant

