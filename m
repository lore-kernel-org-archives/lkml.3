Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaHMFxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:53:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:23608 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaHMFxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:53:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,855,1400050800"; 
   d="scan'208";a="575951857"
Message-ID: <53EAFCED.8030206@intel.com>
Date: Wed, 13 Aug 2014 08:51:41 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/4] perf tools: Fix probing the kernel API with cpu-wide
 events
References: <1407855871-15024-1-git-send-email-adrian.hunter@intel.com>	<1407855871-15024-4-git-send-email-adrian.hunter@intel.com> <87egwldk5m.fsf@sejong.aot.lge.com>
In-Reply-To: <87egwldk5m.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 08:37 AM, Namhyung Kim wrote:
> On Tue, 12 Aug 2014 18:04:30 +0300, Adrian Hunter wrote:
>> Fall back to probing with the current pid if cpu-wide
>> probing fails.  This primarily affects the setting of
>> comm_exec flag when the user is un-privileged and
>> /proc/sys/kernel/perf_event_paranoid > 0.  The change
>> to comm_exec can be observed by using -vv with
>> perf record and a kernel that supports comm_exec.
> 
> Maybe I'm missing something - why not just try process-wide probing in
> the first place?

Same reason as patch 4 i.e. to avoid a jump label change when doing
system-wide tracing.

