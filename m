Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110AbaEFG1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:27:01 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:62852 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934032AbaEFG06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:26:58 -0400
X-IronPort-AV: E=Sophos;i="4.97,994,1389715200"; 
   d="scan'208";a="30122283"
Message-ID: <536872AB.8010406@cn.fujitsu.com>
Date: Tue, 6 May 2014 14:27:07 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: <jolsa@redhat.com>, <a.p.zijlstra@chello.nl>, <paulus@samba.org>,
        <acme@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] perf tools: Clarify the output of perf sched map.
References: <20140505183736.GA15038@gmail.com> <1399336807-10698-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20140506062350.GA25208@gmail.com>
In-Reply-To: <20140506062350.GA25208@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 03:23 PM, Ingo Molnar wrote:
> * Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:
>
>> Example:
>>                *A0       228836.978985 secs A0 => perf:23032
>>            * .  A0       228836.979016 secs . => swapper:0
>>              . *B0       228836.979099 secs B0 => migration/3:22
>>    *A0       .  B0       228836.979115 secs
>>     A0       . * .       228836.979115 secs
>>     A0     *C0   .       228836.979225 secs C0 => ksoftirqd/2:18
>>     A0     *D0   .       228836.979236 secs D0 => rcu_sched:7
> One final thing I noticed, please keep vertical alignment intact, i.e.
> print:
>
>>                *A0       228836.978985 secs A0 => perf:23032
>>            * .  A0       228836.979016 secs .  => swapper:0
>>              . *B0       228836.979099 secs B0 => migration/3:22
> (note the extra space and how the arrows now align vertically.)
>
> In the code this could be done via:

Oh, yes. Easy to fix. Thanx Ingo and I will update it now.
>
>> +			sched_in->shortname[0] = ' ';
>> +			sched_in->shortname[1] = '.';
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

