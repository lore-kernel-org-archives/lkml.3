Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3GQLWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:22:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:46923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab3GQLWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:22:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,684,1367996400"; 
   d="scan'208";a="371705338"
Message-ID: <51E67FEF.3060200@intel.com>
Date: Wed, 17 Jul 2013 14:28:47 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/5] perf: add two new features
References: <1372425741-1676-1-git-send-email-adrian.hunter@intel.com> <20130628152745.GH6626@twins.programming.kicks-ass.net> <51CDE273.9080209@intel.com> <51E4E688.10405@intel.com> <20130716143429.GK23818@dyad.programming.kicks-ass.net>
In-Reply-To: <20130716143429.GK23818@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/13 17:34, Peter Zijlstra wrote:
> On Tue, Jul 16, 2013 at 09:22:00AM +0300, Adrian Hunter wrote:
>> On 28/06/13 22:22, Adrian Hunter wrote:
>>> On 28/06/2013 6:27 p.m., Peter Zijlstra wrote:
>>>> On Fri, Jun 28, 2013 at 04:22:16PM +0300, Adrian Hunter wrote:
>>>>> Hi
>>>>>
>>>>> Please consider these two new perf features:
>>>>>        x86: add ability to calculate TSC from perf sample timestamps
>>>>>        perf: add 'keep tracking' flag to PERF_EVENT_IOC_DISABLE
>>>>
>>>> Please explain to us why you'd like to do this..
>>>
>>> I will see what information I can dig up.  The short answer is that I need
>>> to disable and re-enable a perf event but still be able to map IPs to their
>>> DSOs and symbols - which means not losing mmap events.
>>
>> Any other comments?
> 
> Ah, thanks for the reminder.. well, I've applied patches 1-3 as those seem
> useful on their own. I'm not entirely convinced about the 'keep tracking' thing
> though.
> 
> It seems to me you could get the same by opening a second event into the same
> buffer and keeping that enabled.

In that case I would like a dummy event to use for that purpose.  A software
event could be set aside e.g.

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 627bbcf..7ea4ccd 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -109,6 +109,7 @@ enum perf_sw_ids {
        PERF_COUNT_SW_PAGE_FAULTS_MAJ           = 6,
        PERF_COUNT_SW_ALIGNMENT_FAULTS          = 7,
        PERF_COUNT_SW_EMULATION_FAULTS          = 8,
+       PERF_COUNT_SW_DUMMY                     = 9,

        PERF_COUNT_SW_MAX,                      /* non-ABI */
 };


