Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3AaOcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 09:32:17 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:34829 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab3AaOcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 09:32:14 -0500
MIME-Version: 1.0
In-Reply-To: <20130131142102.GA7339@gmail.com>
References: <1359640479-5289-1-git-send-email-eranian@google.com>
	<20130131142102.GA7339@gmail.com>
Date: Thu, 31 Jan 2013 15:32:14 +0100
Message-ID: <CABPqkBQEbpss=SGiFw+Aj7+MvO9nWcrtkawj4-e=cw+mJiUk4g@mail.gmail.com>
Subject: Re: [PATCH 0/2] perf: add new uncore command
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 3:21 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> This patchset adds a new command to perf: perf uncore.
>> It is used to measure processor socket-level metrics
>> on a system-wide basis and at all priv levels.
>>
>> The command comes with a set of predefined key metrics
>> which are useful to measure multi-socket system imbalance
>> and various bandwidths.
>>
>> The following metrics are currently defined:
>>   - memory bandwidth (Nehalem, Westmere, SandyBridge-EP)
>>   - PCIe bandwidth (SandyBridge-EP)
>>   - QPI bandwidth (SandyBridge-EP)
>>   - C-state residency (SandyBridge-EP)
>>
>> Others can be added in the future.
>>
>> The command provides options to modify the unit of the metrics
>> (default: MB/s for bandwidth).
>>
>> Example on Nehalem:
>>
>>  # perf uncore
>>  #------------------------------
>>  #           Socket0           |
>>  #------------------------------
>>  #        RAM Bandwidth        |
>>  #            Wr             Rd|
>>  #          MB/s           MB/s|
>>  #------------------------------
>>          4954.99       14897.29
>>          4953.97       14894.56
>>          4947.52       14874.97
>>
>> To make plotting easier, the output can be augmented with a timestamp:
>>
>>  # perf uncore -T
>>  #----------------------------------------
>>  #         |           Socket0           |
>>  #         |------------------------------
>>  #   Time  |        RAM Bandwidth        |
>>  #    in   |            Wr             Rd|
>>  #   secs  |          MB/s           MB/s|
>>  #----------------------------------------
>>           1        4952.50       14890.49
>>           2        4955.55       14900.19
>>           3        4949.13       14879.60
>>           4        4954.66       14896.26
>
> Looks really useful - how about naming it in a bit more generic
> way, because I'm quite sure this command will become popular and
> 'perf uncore' is a bit un-intutive.
>
> A couple of possibilities:
>
>   perf system
>   perf hw
>   perf hw-stat
>
I am fine with that.  I prefer hw or systems for the command name.

> and also adding subcommands instead of options for the various
> views/metrics, such as:
>
>   perf hw ram
>   perf hw pci
>   perf hw qpi
>   perf hw cstate

Yes, could do that. Even though having all of them measure at once
is also useful (this is how it currently works by default).

>   etc.
>
> A plain 'perf hw' command would then list the available
> sub-commands and inform the user about the (current) set of
> hw subsystems that provide metrics.
>
Yes. this is what perf uncore -L already does.

For instance on SNB-EP:
$ perf uncore -L
mem_bw : SNB-EP MEM Bandwidth
qpi_bw : SNB-EP QPI Bandwidth
pcie_bw : SNB-EP PCIe Bandwidth
cstate : SNB-EP C-state residency
