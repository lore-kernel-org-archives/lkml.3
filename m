Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaIECaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 22:30:24 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:58016 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaIECaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 22:30:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAM9d7ch9JscoJjrSRYpO3i7WzPtD2qDnJnwyEYHHLGdypDqW=Q@mail.gmail.com>
References: <1409035119-24357-1-git-send-email-namhyung@kernel.org>
 <20140904141845.GD2997@kernel.org> <87a96f9bci.fsf@sejong.aot.lge.com>
 <20140905011804.GC30520@kernel.org> <CAM9d7ch9JscoJjrSRYpO3i7WzPtD2qDnJnwyEYHHLGdypDqW=Q@mail.gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 5 Sep 2014 11:30:01 +0900
X-Google-Sender-Auth: DRLiQpcNu3EwMNST2JKJERVSBDI
Message-ID: <CAM9d7cgKrcAh0RkpU_3C_UAeO5=RU5UAwCJa8kMyV7aGcoGVRw@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Fix build-id matching on vmlinux
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 10:42 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> On Fri, Sep 5, 2014 at 10:18 AM, Arnaldo Carvalho de Melo
> <acme@kernel.org> wrote:
>> Em Fri, Sep 05, 2014 at 09:09:49AM +0900, Namhyung Kim escreveu:
>>> The perf report rebuilds machine states from the event records only.  In
>>> this case, the kernel map was recorded in the name of [kernel.kallsyms]
>>> so it couldn't find the build-id from the table.
>>
>> Ok, but then we can special case this one, no?
>>
>> Somehow mark in the buildid table that that entry is the one for the
>> kernel and hook it up to the synthesized event that has the
>> [kernel.kallsyms].ref_reloc_sym entry.
>
> Maybe we can search vmlinux in machine->kernel_dsos first when
> processing kernel mmap event.  And in this case do you want replace
> the name of mapping to a fullname of vmlinux?

Ah.. the name of mapping is not used at all after finding a matching
dso.  Ok then, I'll post a new patch to search vmlinux before
kallsyms.

Thanks
Namhyung
