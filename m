Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaFJQVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:21:19 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:57407 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752945AbaFJQVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:21:16 -0400
Message-ID: <53973078.6040907@semaphore.gr>
Date: Tue, 10 Jun 2014 19:21:12 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] cpufreq: intel_pstate: Add debugfs file stats
References: <53962072.6010702@semaphore.gr> <53972883.7070707@gmail.com>
In-Reply-To: <53972883.7070707@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 06:47 μμ, Dirk Brandewie wrote:
> On 06/09/2014 02:00 PM, Stratos Karafotis wrote:
>> Add stats file in debugfs under driver's parent directory
>> (pstate_snb) which counts the time in nsecs per requested
>> P state and the number of times the specific state
>> was requested.
>>
>> The file presents the statistics per logical CPU in the
>> following format. The time is displayed in msecs:
>>
> 
> NAK
> 
> This adds significantly to the memory footprint to gather information
> that is available by post processing the perf tracepoint information.
> The increase isn't horrible on single socket desktop processor machines
> but gets big with server class machines.  One vendor I have talked to considers
> a machine with 1024 cpus to be a SMALL machine.
> 

If I am not wrong the sizeof pstate_stat is 20B. On my CPU with 20 P states, we
need 400B per logical CPU (3200B total in my desktop) plus 64B for stats pointers.

In your example this would need about 400KB - 500KB?
Is it too much for 1024 a CPUs system?

I think it's a useful piece of info that we can have it directly without
post processing tracepoint.
Is it acceptable to conditionally compile it with a new CONFIG option?


Thanks,
Stratos

