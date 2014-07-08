Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaGHIGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:06:08 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:38184 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaGHIGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:06:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140707182316.GA7252@kernel.org>
References: <1404423780-24026-1-git-send-email-acme@kernel.org>
 <20140703214811.GC11267@kernel.org> <878uo94ia9.fsf@sejong.aot.lge.com> <20140707182316.GA7252@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 8 Jul 2014 17:05:44 +0900
X-Google-Sender-Auth: tAe9fQwv6SeDsBv3n3gTfy_EfHo
Message-ID: <CAM9d7cjDNFDarYFLRXbO0o_HLJjU2FzPLc4vwuvOdyJoxB6jrQ@mail.gmail.com>
Subject: Re: [RFC PATCHES 0/7] Add support for showing headers in the hist browser.
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 3:23 AM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
> Em Fri, Jul 04, 2014 at 05:53:02PM +0900, Namhyung Kim escreveu:
>> you ;-) ).  But I also think it needs to fix column/header alignment
>> first, hmm...
>
> This one liner should do the trick, i.e. left justify it.

Yes, but it needs some more tweaks.  I'll try to fix it soon..

Thanks,
Namhyung


>
> - Arnaldo
>
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 1ec57dd82284..14e5a039bc45 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -1215,7 +1215,7 @@ static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
>         hse = container_of(fmt, struct hpp_sort_entry, hpp);
>         len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
>
> -       return scnprintf(hpp->buf, hpp->size, "%*s", len, hse->se->se_header);
> +       return scnprintf(hpp->buf, hpp->size, "%-*s", len, hse->se->se_header);
>  }
>
>  static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
