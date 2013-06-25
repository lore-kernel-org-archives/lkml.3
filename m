Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab3FYQDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:03:12 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:55066 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab3FYQDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:03:08 -0400
MIME-Version: 1.0
In-Reply-To: <51C9BDB2.7060905@gmail.com>
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
	<1372079772-20803-13-git-send-email-adrian.hunter@intel.com>
	<51C9BDB2.7060905@gmail.com>
Date: Tue, 25 Jun 2013 18:03:08 +0200
Message-ID: <CABPqkBQK5PdcULwtAefsVKvV+Ne6kaaH2_jeoba8kz3Ui_EqAw@mail.gmail.com>
Subject: Re: [PATCH 12/15] perf tools: allow non-matching sample types
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 5:56 PM, David Ahern <dsahern@gmail.com> wrote:
> On 6/24/13 7:16 AM, Adrian Hunter wrote:
>>
>> Sample types need not be identical to determine
>> the sample id from the event.  Only the position
>> of the sample id needs to be the same.
>>
>> Compatible sample types are ones in which the bits
>> defined by PERF_COMPAT_MASK are the same.
>> 'perf_evlist__config()' forces sample types to be
>> compatible on that basis.
>
>
> Something is still missing to support different sample_types for events.
> Consider the case (S/W event + tracepoint):
>   perf record -e cs -c1 -e sched:sched_switch -a -- sleep 1
>   perf script
>
> This patch addresses the sample_type mismatch error message, but I get no
> event samples in the output. Besides the usual header I get:
>
>   No trace sample to read. Did you call 'perf record -R'?
>
> It's a 16-cpu box with 5 VMs running. I know there should be at least a few
> samples in 1 second.
>
> Stephane: are you looking at allowing sample_types per event?
>
Yes, this is what I need. I have a kernel patch to do this. I don't
know how to update perf to handle it correctly. So maybe you can
help. My patch is useful to drastically reduce the size of the perf.data
file in case we use the branch-stack with lots of events which is
what our Gooda tool would like to do.
