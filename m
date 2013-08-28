Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3H1Nia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:38:30 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:36890 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3H1Ni2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:38:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130828132703.GD3825@infradead.org>
References: <20130826131121.GA26224@quad>
	<521BD4F8.5050504@gmail.com>
	<20130828132703.GD3825@infradead.org>
Date: Wed, 28 Aug 2013 15:38:28 +0200
Message-ID: <CABPqkBTf8Ruoq1RZhLcBLkhJY1mzJLpnLsM0J_7Bz=9Eakeajg@mail.gmail.com>
Subject: Re: [PATCH] perf mem: add priv level filtering support
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 3:27 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Mon, Aug 26, 2013 at 04:21:44PM -0600, David Ahern escreveu:
>> On 8/26/13 7:11 AM, Stephane Eranian wrote:
>
>> >This patch adds the -u -and -k options to perf to allow
>> >filtering of load/store sampling based on priv levels.
>> >This may not be supported by all HW platforms.
>
>
>> >+++ b/tools/perf/Documentation/perf-mem.txt
>> >+-k::
>> >+    Only sample loads/stores at the user level (default: user + kernel)
>> >+-u::
>> >+    Only sample loads/stores at the kernel level (default: user + kernel)
>
>> Are the descriptions backwards? In the commit message yuo have -u
>> means user level and -k means kernel level; the help message here
>> seems backwards.
>
> Looks like it is reversed, yes.
>
>> >+    OPT_BOOLEAN('u', "user-level", &mem.user, "include user-level accesses"),
>> >+    OPT_BOOLEAN('k', "kernel-level", &mem.kernel, "include kernel-level accesses"),
>
> And its not clear to say that using -u will _exclude_ kernel samples,
> just that it includes user samples, perf top has:
>
>     -K, --hide_kernel_symbols   hide kernel symbols
>     -U, --hide_user_symbols     hide user symbols
>
> So perhaps we should change both to (and add this to 'report' as well):
>
>     -U, --hide_kernel_symbols   hide kernel symbols
>     -K, --hide_user_symbols     hide user symbols
>

Well, I don't know what perf top does here but I don't want to hide
the samples. I simply don't want to collect them (do not appear
in the perf.data file). If that's what is happening in perf top, then
I'll be glad to use the same options.


> To state that:
>
>         perf top -K
> and
>         perf top --hide_user_symbols
>
> Are equivalent and asks for 'kernel only' samples, like it seems its the
> intent (filtering) of Stephane here, and seems to clarify things?
>
> - Arnaldo
