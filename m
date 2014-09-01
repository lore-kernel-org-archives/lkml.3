Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaIAG2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:28:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:55013 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbaIAG2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:28:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,440,1406617200"; 
   d="scan'208";a="474354427"
Message-ID: <540411C5.8030207@intel.com>
Date: Mon, 01 Sep 2014 09:27:17 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
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
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-21-git-send-email-adrian.hunter@intel.com> <20140716142510.GE9441@krava.redhat.com> <53C6948C.2080103@intel.com> <20140716182214.GB32716@krava.redhat.com> <5400CB13.4040004@intel.com> <20140830085310.GA14358@krava.redhat.com>
In-Reply-To: <20140830085310.GA14358@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2014 11:53 AM, Jiri Olsa wrote:
> On Fri, Aug 29, 2014 at 09:48:51PM +0300, Adrian Hunter wrote:
>> On 16/07/2014 9:22 p.m., Jiri Olsa wrote:
>>> On Wed, Jul 16, 2014 at 06:04:44PM +0300, Adrian Hunter wrote:
>>>> On 16/07/2014 5:25 p.m., Jiri Olsa wrote:
>>>>> On Mon, Jul 14, 2014 at 01:02:44PM +0300, Adrian Hunter wrote:
>>>>>> This enables a PMU event to be specified in the form:
>>>>>>
>>>>>> 	pmu//
>>>>>>
>>>>>> which is effectively the same as:
>>>>>>
>>>>>> 	pmu/config=0/
>>>>>>
>>>>>> This patch is a precursor to defining
>>>>>> default config for a PMU.
>>>>>
>>>>> I understand the need for default config, but could you please elaborate
>>>>> why do we want to parse 'pmu//' as an event string string?
>>>>
>>>> Currently the parser requires the slashes to identify a PMU event
>>>> as opposed to a hardware or other kind of event.
>>>
>>> right, so why do we want to parse 'pmu//' as an event string? ;-)
>>
>> I am not sure what you mean.  Here I am using 'pmu' as a placeholder
>> for a real PMU name.  So actual event strings are 'intel_bts//' or
>> 'intel_pt//' or 'intel_pt/tsc=0,noretcomp=1/'
> 
> so the consequence of default arguments is that you can
> specify event just by the pmu name, like:
>   -e intel_pt//
> 
> which means (with default attributes):
>   -e intel_pt/tsc=1,noretcomp=0/
> 
> I guess I wanted to hear more elaboration why is this better
> than the current way we have by defining an alias, like:
> 
>   krava alias: "tsc=1,noretcomp=0"
> 
>   -e intel_pt/krava/
> 
> which gives the same result

The default value must be provided by perf tools not the kernel e.g.
an older version of perf tools will not be aware of new hardware
features that the kernel may know about.  If the kernel enables
new features by default then the tool may fail.  Thus the default
value has to be under the control of the tools not the kernel, so
a sysfs alias will not work.

