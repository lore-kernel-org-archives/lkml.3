Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbaL0FVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 00:21:34 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:43360 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaL0FVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 00:21:33 -0500
MIME-Version: 1.0
In-Reply-To: <20141226135945.GA20929@krava.redhat.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-38-git-send-email-namhyung@kernel.org> <20141226135945.GA20929@krava.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Sat, 27 Dec 2014 14:21:12 +0900
X-Google-Sender-Auth: USZyuJ-xBSBD9NcNSuVS3eB53Xs
Message-ID: <CAM9d7cgE2qPL9wdma5HenezF=DjXu8CHoFq5z9q4BygeVACY_w@mail.gmail.com>
Subject: Re: [PATCH 37/37] perf data: Implement 'split' subcommand
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, Dec 26, 2014 at 10:59 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Dec 24, 2014 at 04:15:33PM +0900, Namhyung Kim wrote:
>> The perf data split command is for splitting a (large) single data
>> file into multiple files under a directory (perf.data.dir by default)
>> so that it can be processed and reported using multiple threads.
>>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/Documentation/perf-data.txt |  28 +++++
>>  tools/perf/builtin-data.c              | 223 +++++++++++++++++++++++++++++++++
>>  2 files changed, 251 insertions(+)
>>
>> diff --git a/tools/perf/Documentation/perf-data.txt b/tools/perf/Documentation/perf-data.txt
>> index b8c83947715c..42708702f10c 100644
>> --- a/tools/perf/Documentation/perf-data.txt
>> +++ b/tools/perf/Documentation/perf-data.txt
>> @@ -13,3 +13,31 @@ SYNOPSIS
>>  DESCRIPTION
>>  -----------
>>  Data file related processing.
>> +
>> +COMMANDS
>> +--------
>> +split::
>> +     Split single data file (perf.data) into multiple files under a directory
>> +     in order to be reported by multiple threads.
>> +
>> +OPTIONS for 'split'
>> +---------------------
>> +-i::
>> +--input::
>> +     Specify input perf data file path.
>> +
>> +-o::
>> +--output::
>> +     Specify output perf data directory path.
>
> should the -o have 'perf.data.dir' as default?
>
> [jolsa@krava perf]$ ./perf record ls > /dev/null
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.000 MB perf.data (~0 samples) ]
> [jolsa@krava perf]$ ./perf data split
> [jolsa@krava perf]$ ll perf.data*
> -rw------- 1 jolsa jolsa 16172 Dec 26 14:58 perf.data

You're right! :)

Thanks,
Namhyung
