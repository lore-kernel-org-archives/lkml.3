Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3JUJC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:02:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:59478 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302Ab3JUJC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 05:02:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="310472180"
Message-ID: <5264ED95.2020101@intel.com>
Date: Mon, 21 Oct 2013 12:02:13 +0300
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
Subject: Re: [PATCH 09/19] perf tools: Fix 32-bit cross build
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com> <1382099356-4918-10-git-send-email-adrian.hunter@intel.com> <20131020204251.GA12044@krava> <5264C140.1020903@intel.com> <20131021084658.GA2958@krava.brq.redhat.com>
In-Reply-To: <20131021084658.GA2958@krava.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/13 11:46, Jiri Olsa wrote:
> On Mon, Oct 21, 2013 at 08:53:04AM +0300, Adrian Hunter wrote:
>> On 20/10/13 23:42, Jiri Olsa wrote:
>>> On Fri, Oct 18, 2013 at 03:29:06PM +0300, Adrian Hunter wrote:
>>>> Setting EXTRA_CFLAGS=-m32 did not work because CFLAGS
>>>> was not passed around.
>>>
>>> this breaks feature detection for me on x86_64,
>>> I've got following errors misdetection with this patch:
>>>
>>> ...                       libperl: [ OFF ]
> 
> how about this one?

I will check it out.

> 
>>> ...                       on-exit: [ OFF ]
>>>
>>> and the build fails as well:
>>>
>>>   CC       builtin-stat.o
>>> builtin-record.c:42:12: error: static declaration of ‘on_exit’ follows non-static declaration
>>> In file included from util/util.h:51:0,
>>>                  from builtin.h:4,
>>>                  from builtin-record.c:8:
>>> /usr/include/stdlib.h:536:12: note: previous declaration of ‘on_exit’ was here
>>> make[1]: *** [builtin-record.o] Error 1
>>> make[1]: *** Waiting for unfinished jobs....
>>> make: *** [all] Error 2
>>
>> That is fixed in patch 11: perf tools: Fix test_on_exit for 32-bit build
> 
> hum, could we apply those patches in reverse order?
> I think the notion is not to break build deliberatelly
> for the bisection sake.

Oh, I had thought it was a 32-bit only problem.
Yes, I will re-order the patches.

