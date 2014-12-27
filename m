Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaL0Fcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 00:32:39 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:61210 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaL0Fcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 00:32:36 -0500
MIME-Version: 1.0
In-Reply-To: <549D922F.3020101@gmail.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-6-git-send-email-namhyung@kernel.org> <549D922F.3020101@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Sat, 27 Dec 2014 14:32:16 +0900
X-Google-Sender-Auth: kbnWlHJUZJgpduKE2v2-sw0SKWc
Message-ID: <CAM9d7cg1d4odzfqgPjsMpeFr1fiKV_0J+u0EOzCdKrGi9EMmxg@mail.gmail.com>
Subject: Re: [PATCH 05/37] perf tools: Create separate mmap for dummy tracking event
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 1:51 AM, David Ahern <dsahern@gmail.com> wrote:
> On 12/24/14 12:15 AM, Namhyung Kim wrote:
>>
>> When multi file support is enabled, a dummy tracking event will be
>> used to track metadata (like task, comm and mmap events) for a session
>> and actual samples will be recorded in separate files.
>>
>> Provide separate mmap to the dummy tracking event.  The size is fixed
>> to 128KiB (+ 1 page) as the event rate will be lower than samples.  I
>
>
> Have you tried stress tests like a kernel compile with -j Ncpus (Ncpus = 16
> or higher)?

Yep, the test results in the cover letter were recorded kernel build
with -j 20 on my development machine.

Thanks,
Namhyung
