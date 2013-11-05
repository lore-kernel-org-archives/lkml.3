Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3KEI3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 03:29:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:3748 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab3KEI3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 03:29:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="403767957"
Message-ID: <5278AC36.1020702@intel.com>
Date: Tue, 05 Nov 2013 10:28:38 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 06/11] perf record: Add an option to force per-cpu
 mmaps
References: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com> <1383313899-15987-7-git-send-email-adrian.hunter@intel.com> <20131104152942.GA4004@krava.brq.redhat.com>
In-Reply-To: <20131104152942.GA4004@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/13 17:29, Jiri Olsa wrote:
> On Fri, Nov 01, 2013 at 03:51:34PM +0200, Adrian Hunter wrote:
>> By default, when tasks are specified (i.e. -p, -t
>> or -u options) per-thread mmaps are created.  Add
>> an option to override that and force per-cpu mmaps.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/Documentation/perf-record.txt | 6 ++++++
>>  tools/perf/builtin-record.c              | 2 ++
>>  tools/perf/util/evlist.c                 | 4 +++-
>>  tools/perf/util/evsel.c                  | 4 ++--
>>  tools/perf/util/target.h                 | 1 +
>>  5 files changed, 14 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
>> index f10ab63..2ea6685 100644
>> --- a/tools/perf/Documentation/perf-record.txt
>> +++ b/tools/perf/Documentation/perf-record.txt
>> @@ -189,6 +189,12 @@ abort events and some memory events in precise mode on modern Intel CPUs.
>>  --transaction::
>>  Record transaction flags for transaction related events.
>>  
>> +--force-per-cpu::
>> +Force the use of per-cpu mmaps.  By default, when tasks are specified (i.e. -p,
>> +-t or -u options) per-thread mmaps are created.  This option overrides that and
>> +forces per-cpu mmaps.  A side-effect of that is that inheritance is
>> +automatically enabled.  Add the -i option also to disable inheritance.
> 
> I recently sent out patch that actually force perf cpu mmaps for -p,-t,-u
> http://marc.info/?l=linux-kernel&m=138332119912433&w=2
> 
> Is there a reason why would you want to keep single
> mmap (in record command) and cut yourself from inherited
> events?

Not sure I understand the question.

perf supports having a single context for a thread.  That is a
feature.  You seem to be removing perf tools support for it.

I image a case where the user has hundreds of CPUs but just
wants to record one thread.  Currently -t does that. i.e.
one file descriptor and one mmap saving megabytes of memory.

Another advantage of per-thread mmaps is that you do not
need to sample time (nor cpu), because the events are recorded
in order.

I was adding a feature.  Users can choose per-cpu mmaps if
they want.

