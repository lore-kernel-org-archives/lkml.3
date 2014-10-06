Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaJFO7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:59:02 -0400
Received: from mail.kernel.org ([198.145.19.201]:39429 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbaJFO7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:59:00 -0400
Date: Mon, 6 Oct 2014 11:58:56 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Robert Richter <rric@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fu Wei <fu.wei@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf & rasd integration plan
Message-ID: <20141006145856.GA14113@kernel.org>
References: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
 <20140930132416.GB2799@kernel.org>
 <20141006090726.GQ20170@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006090726.GQ20170@rric.localhost>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 06, 2014 at 11:07:26AM +0200, Robert Richter escreveu:
> On 30.09.14 10:24:16, Arnaldo Carvalho de Melo wrote:
> > Em Tue, Sep 30, 2014 at 11:06:21AM +0200, Jean Pihet escreveu:
> > > The plan is to move the small and generic functions first: util,
> > > xyarray, cpumap, thread_map etc; then evlist, evsel, trace-event,
> > > trace-event-parse; and finally integrate rasd into the tools/ dir.

> > > Any thought? Can evlist, evsel etc. be moved at once?

> > > Patches should come soon, when time allows.

> > Why don't you add it to tools/rasd/ and in tools/rasd/Makefile you just
> > go on and add tools/perf/util/evlist.o et all to be linked directly, as
> > a first step.

> > Then, as a second step, we can create a tools/lib/perf/evlist.c having
> > what is currently used by both tools/perf/ and tools/rasd/, i.e. what is
> > proven to be useful for something other than perf.
 
> It would be good to have tools/lib/perf or so with some base
> implementation to setup and connect to perf buffers. This is useful
> for tools not only in tools/. The rasd would be a good reference for

Agreed, we can use rasd as a reference, I'm now looking for the git repo
url to see what it is using to prototype how I think this should be
done.

- Arnaldo

> this regardless if it is in tools/ or not. I am not sure whether and
> when rasd will be moved there.

- Arnaldo
