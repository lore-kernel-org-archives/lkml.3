Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab3A1Uww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 15:52:52 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:49298 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3A1Uwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:52:50 -0500
MIME-Version: 1.0
In-Reply-To: <1359230650-10415-2-git-send-email-jolsa@redhat.com>
References: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
	<1359230650-10415-2-git-send-email-jolsa@redhat.com>
Date: Mon, 28 Jan 2013 21:52:49 +0100
Message-ID: <CABPqkBSH=67hG8VRwHPU3byEancpVqsyetHkSjb4nOScPvcnFA@mail.gmail.com>
Subject: Re: [PATCH 1/8] perf tools: Add '.' as part of the event 'name' token
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

I don't see part 0/8 of this series. Did you send it to me too?

I have some comments about it. I don't see why create something from scratch
when I have been developing a library (libpfm4) that takes care of that and that
is already used by many tool developers. That library can be linked with perf
and provide full symbolic events + all the modifiers. The library is portable
and supports all existing archs. It can also be used by self-monitoring apps.


You're introducing yet another event table to maintain. And believe me this is
a lot of work to maintain this.

I don't understand why not use this existing library.


On Sat, Jan 26, 2013 at 9:04 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> Adding '.' to be recognized as valid part of the event 'name'
> token. Upcoming non architectural events use '.' as part
> of the name.
>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/util/parse-events.l | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> index 32a9000..4220093 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/perf/util/parse-events.l
> @@ -80,8 +80,8 @@ event         [^,{}/]+
>  num_dec                [0-9]+
>  num_hex                0x[a-fA-F0-9]+
>  num_raw_hex    [a-fA-F0-9]+
> -name           [a-zA-Z_*?][a-zA-Z0-9_*?]*
> -name_minus     [a-zA-Z_*?][a-zA-Z0-9\-_*?]*
> +name           [a-zA-Z_*?][a-zA-Z0-9_*?\.]*
> +name_minus     [a-zA-Z_*?][a-zA-Z0-9\-_*?\.]*
>  modifier_event [ukhpGH]+
>  modifier_bp    [rwx]{1,3}
>
> --
> 1.7.11.7
>
