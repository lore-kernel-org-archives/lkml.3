Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaFFNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:16:58 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:38703 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaFFNQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:16:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140604223114.GC16855@tassilo.jf.intel.com>
References: <1401918378-3842-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140604222047.GA16855@tassilo.jf.intel.com>
	<CAFo99gY_GZg7TY=H_UZBDL3dP2vL6NW-TCvtCDx+voY0uH80AA@mail.gmail.com>
	<20140604223114.GC16855@tassilo.jf.intel.com>
Date: Fri, 6 Jun 2014 15:16:56 +0200
Message-ID: <CAFo99gb4+_nn-5PonfgNfXfyB9PdqsiWX=VqgSxRUtP3oOhD9Q@mail.gmail.com>
Subject: Re: [PATCH] tools: perf: util: parse-events.c: Cleaning up missing
 null-terminate after strncpy call
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I really do not want to complicate things here, both work course here.
But sptlcpy is definitely faster. But this is hardly time-critical
code, so maybe it looks better to use snprintf in both cases.

I vote for sptlcpy, but who decides?
Someone decides and I submit another patch :-)

Best regards
Rickard Strandqvist


2014-06-05 0:31 GMT+02:00 Andi Kleen <ak@linux.intel.com>:
> On Thu, Jun 05, 2014 at 12:23:55AM +0200, Rickard Strandqvist wrote:
>> Hi
>>
>> A little embarrassing, but I actually did not know that there was a
>> better replacement for strncpy.
>
> This works for perf, but not in general because standard glibc
> does not have strlcpy. snprintf works always.
>
> In practice if you could tolerate strncpy always zeroing
> the complete string before you can also tolerate snprintf.
>
> -Andi
