Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaJFPHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:07:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:39860 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbaJFPHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:07:46 -0400
Date: Mon, 6 Oct 2014 12:07:41 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf & rasd integration plan
Message-ID: <20141006150741.GB14113@kernel.org>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 30, 2014 at 11:06:21AM +0200, Jean Pihet escreveu:
> The RAS Deamon (rasd) as available at [1] and the development version
> at [2], allows to enable kernel tracepoints and outputs the
> tracepoints fields according to the kernel format.
> 
> [1] https://git.kernel.org/cgit/utils/ras/rasd.git/
> [2] https://git.linaro.org/people/jean.pihet/rasd.git
> 
> rasd currently is a duplicate of the perf tool code, ultimately perf
> and rasd will use the same common code. The goal is to factor out the
> common code from perf and place it in small librairies in tools/lib.
> 
> Here is the code that rasd currently uses and that should be moved to tools/lib:
> 
> - debugfs: already in tools/lib/api/fs
>   . mount and retrieve path
> 
> - evlist: tools/perf/util/evlist.[ch]
>   . create and init new evlist,
>   . set cpu and thread maps,
>   . add events to evlist,
>   . init and use internal event id,
>   . alloc and mmap events buffers, manage file descriptors,
>   . enable events,
>   . read events buffers, parse data,
>   . unmap and free buffers
> 
> - evsel: tools/perf/util/evsel.[ch]
>   . create and init new tracepoints events,
>   . init and use internal event id,
>   . open events, manage fds,
>   . close and free events

So, why have you commented out the perf_missing_features fallbacks? Are
they getting in the way somehow, what can we do upstream, i.e. in
tools/perf/util/ so that it gets closer to what you want to have?

Ditto for all the other ifdef'ed code, can you elaborate on why each is
needed? That will help in moving what is used by rasd from
tools/perf/util/ to tools/perf/lib/ so that we can eliminate the
duplicity.

- Arnaldo
