Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3JCNfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:35:23 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:55050 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3JCNfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:35:22 -0400
Message-ID: <524D7296.3090407@gmail.com>
Date: Thu, 03 Oct 2013 07:35:18 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf tool: report user-friendly error from timechart
References: <1380791146-7465-1-git-send-email-artagnon@gmail.com> <20131003123820.GA12004@gmail.com>
In-Reply-To: <20131003123820.GA12004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/13 6:38 AM, Ingo Molnar wrote:
>
> * Ramkumar Ramachandra <artagnon@gmail.com> wrote:
>
>> +	/* Perform a quick sanity check */
>> +	if (!is_valid_tracepoint("power:cpu_frequency")) {
>> +		fprintf(stderr, "Error:\tNo permissions to read $debugfs/tracing/events/power/cpu_frequency\n");
>> +		fprintf(stderr, "Hint:\tChange the permissions of debugfs: /sys/kernel/debug\n");
>> +		fprintf(stderr, "\tThe directory will be present if your kernel was compiled with debugfs support.\n");
>
> Is missing permissions the only way how is_valid_tracepoint() can fail?
>
> What if debugfs has the right permissions but CONFIG_TRACEPOINTS is
> disabled in the kernel?

There are a number of reasons that function can fail. The complete 
solution is to plumb various error numbers and on failure request a 
string for that failure. Take a look at util/target.[ch] as an example.

The comment applies to the perf-trace patch as well, but it gets more 
complicated to handle the error paths from perf_evsel__newtp when they 
dip into the tracepoint code

David

