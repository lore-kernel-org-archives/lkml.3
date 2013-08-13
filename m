Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3HMHNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:13:00 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:47939 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3HMHM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:12:58 -0400
Message-ID: <5209DC73.8000408@huawei.com>
Date: Tue, 13 Aug 2013 15:12:51 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Karim Yaghmour <karim.yaghmour@opersys.com>
CC: <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        <mingo@elte.hu>
Subject: Re: Reading perf counters at ftrace trace boundaries
References: <5208263D.2080205@opersys.com> <52084774.7010009@huawei.com> <5208FEC1.7010206@opersys.com>
In-Reply-To: <5208FEC1.7010206@opersys.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/12 23:26, Karim Yaghmour wrote:
> 
> On 13-08-11 11:24 PM, zhangwei(Jovi) wrote:
>> If you want to base on ftrace, below two approach maybe take into use:
>>
>> - register_ftrace_function/unregister_ftrace_function
>>
>> - perf_event_create_kernel_counter (function event id is 1)
>>
>> the first one is simplest, IMO.
> 
> Thx for the pointers.
> 
>> You need to write your own kernel module to use these approach.
> 
> As a proof-of-concept, sure. For something more permanent it would make
> more sense to adapt the various perf/ftrace tools to make this available
> on the command line with other options. But we're far away from that for
> the moment.
> 
If you want to embed pmu reading into ftrace/perf permanently, perhaps
make pmu reading as clock source would be a nice way to go, actually the
question you raised is very common for all of us in practical, sometimes
we want to read cpu cycles both in kvm host and kvm guest, then in that
kvm case, pmu reading for each event is very valuable.

(one issue need to handle specially for making pmu as tracing clock, is
the pmu number overflow, because it relate with ftrace per-cpu ring
buffer sync)

Thanks.

jovi



