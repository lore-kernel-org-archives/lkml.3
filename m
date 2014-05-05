Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaEES1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:27:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43463 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaEES1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:27:05 -0400
Message-ID: <5367D7F8.70406@gmail.com>
Date: Mon, 05 May 2014 12:27:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perf tools: Clarify the output of perf sched map.
References: <cover.1399273302.git.yangds.fnst@cn.fujitsu.com> <a72ade72ecf55803471e42f80a3aa6547b1477e5.1399273302.git.yangds.fnst@cn.fujitsu.com> <20140505182433.GA28367@krava.brq.redhat.com>
In-Reply-To: <20140505182433.GA28367@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/14, 12:24 PM, Jiri Olsa wrote:
> On Mon, May 05, 2014 at 04:05:55PM +0900, Dongsheng Yang wrote:
>> From: Dongsheng <yangds.fnst@cn.fujitsu.com>
>>
>> In output of perf sched map, any shortname of thread will be explained
>> at the first time when it appear.
>>
>> Example:
>> 	      *A0       228836.978985 secs A0 => perf:23032
>>            *.   A0       228836.979016 secs B0 => swapper:0
>>             .  *C0       228836.979099 secs C0 => migration/3:22
>>    *A0      .   C0       228836.979115 secs
>>     A0      .  *.        228836.979115 secs
>>
>> But B0, which is explained as swapper:0 did not appear in the
>> left part of output. Instead, we use '.' as the shortname of
>> swapper:0. So the comment of "B0 => swapper:0" is not easy to
>> understand.
>>
>> This patch clarify the output of perf sched map with not allocating
>> one letter-number shortname for swapper:0 and print ". => swapper:0"
>> as the explaination for swapper:0.
>>
>> Example:
>>                *A0       228836.978985 secs A0 => perf:23032
>>            * .  A0       228836.979016 secs . => swapper:0
>>              . *B0       228836.979099 secs B0 => migration/3:22
>>    *A0       .  B0       228836.979115 secs
>>     A0       . * .       228836.979115 secs
>>     A0     *C0   .       228836.979225 secs C0 => ksoftirqd/2:18
>>     A0     *D0   .       228836.979236 secs D0 => rcu_sched:7
>
> I've never used 'perf sched map' before, so I'm not
> sure about this one.. Arnaldo, David, Ingo?  ;-)

Patches 1 and 2 look ok to me.

This one is a preference change -- deferring to Ingo and Arnaldo on it.

David

