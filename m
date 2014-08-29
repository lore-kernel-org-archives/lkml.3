Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaH2Ss4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:48:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:27973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbaH2Ssz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:48:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,425,1406617200"; 
   d="scan'208";a="565515956"
Message-ID: <5400CB13.4040004@intel.com>
Date: Fri, 29 Aug 2014 21:48:51 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 20/41] perf tools: Let a user specify a PMU event without
 any config terms
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-21-git-send-email-adrian.hunter@intel.com> <20140716142510.GE9441@krava.redhat.com> <53C6948C.2080103@intel.com> <20140716182214.GB32716@krava.redhat.com>
In-Reply-To: <20140716182214.GB32716@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/2014 9:22 p.m., Jiri Olsa wrote:
> On Wed, Jul 16, 2014 at 06:04:44PM +0300, Adrian Hunter wrote:
>> On 16/07/2014 5:25 p.m., Jiri Olsa wrote:
>>> On Mon, Jul 14, 2014 at 01:02:44PM +0300, Adrian Hunter wrote:
>>>> This enables a PMU event to be specified in the form:
>>>>
>>>> 	pmu//
>>>>
>>>> which is effectively the same as:
>>>>
>>>> 	pmu/config=0/
>>>>
>>>> This patch is a precursor to defining
>>>> default config for a PMU.
>>>
>>> I understand the need for default config, but could you please elaborate
>>> why do we want to parse 'pmu//' as an event string string?
>>
>> Currently the parser requires the slashes to identify a PMU event
>> as opposed to a hardware or other kind of event.
>
> right, so why do we want to parse 'pmu//' as an event string? ;-)

I am not sure what you mean.  Here I am using 'pmu' as a placeholder
for a real PMU name.  So actual event strings are 'intel_bts//' or
'intel_pt//' or 'intel_pt/tsc=0,noretcomp=1/'

The parser uses various tricks to decide what kind of event the event
name actually is e.g. colons indicate a tracepoint.

If you are asking why the parser isn't smart enough to know the event
name is a PMU name, I guess it is either to keep the namespaces separate,
or because it was easier to program it that way.
