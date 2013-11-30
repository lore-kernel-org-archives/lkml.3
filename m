Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3K3P7B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 10:59:01 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38798 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3K3P67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 10:58:59 -0500
Message-ID: <529A0B40.8030107@gmail.com>
Date: Sat, 30 Nov 2013 08:58:56 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/8] perf symbols: Move idle syms check from top to generic
 function
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>	<1384806771-2945-3-git-send-email-dsahern@gmail.com> <871u20rkgz.fsf@sejong.aot.lge.com>
In-Reply-To: <871u20rkgz.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/13, 1:36 AM, Namhyung Kim wrote:
> Hi David,
>
> Just minor nits below..
>
> On Mon, 18 Nov 2013 13:32:45 -0700, David Ahern wrote:
>> Allows list of idle symbols to be leveraged by other commands,
>> such as the upcoming timehist command.
>
> [SNIP]
>> +bool symbol__is_idle(struct symbol *sym)
>> +{
>> +	const char * const idle_symbols[] = {
>
> Wouldn't it better making it static?  It seems to build a table
> everytime otherwise.

Checked a couple of gcc's (4.3.2 32-bit and 4.6.3 64-bit) and both put 
idle_symbols in read-only data section. e.g.,

0000000000000020 r idle_symbols.13404

So I think it is fine as is.

>
>
>> +		"cpu_idle",
>> +		"intel_idle",
>> +		"default_idle",
>> +		"native_safe_halt",
>> +		"enter_idle",
>> +		"exit_idle",
>> +		"mwait_idle",
>> +		"mwait_idle_with_hints",
>> +		"poll_idle",
>> +		"ppc64_runlatch_off",
>> +		"pseries_dedicated_idle_sleep",
>> +		NULL
>> +	};
>> +
>> +	int i;
>> +
>> +	if (!sym)
>> +		return false;
>> +
>> +	for (i = 0; idle_symbols[i]; i++) {
>
> Also we can use ARRAY_SIZE() here and let the last NULL go IMHO.

I copied what was in builtin-top.c.

David
