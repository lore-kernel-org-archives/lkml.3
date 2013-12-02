Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3LBT1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:27:04 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:41536 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab3LBT06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:26:58 -0500
Date: Mon, 2 Dec 2013 16:26:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 06/29] tools lib traceevent: Add jbd2 plugin
Message-ID: <20131202192651.GB17149@ghostprotocols.net>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
 <1385638408-23519-7-git-send-email-jolsa@redhat.com>
 <20131129184235.GA12850@ghostprotocols.net>
 <20131129193113.GA13490@ghostprotocols.net>
 <20131130164921.GC1228@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131130164921.GC1228@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Nov 30, 2013 at 05:49:21PM +0100, Jiri Olsa escreveu:
> On Fri, Nov 29, 2013 at 04:31:13PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Nov 29, 2013 at 03:42:35PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Also I just tried:

> > [acme@ssdandy linux]$ git log --oneline | head -7
> > b0496b02fcea tools lib traceevent: Add hrtimer plugin
> > 1ec7a71e0b2c tools lib traceevent: Add jbd2 plugin
> > c63100c95c6e tools lib traceevent: Add traceevent_host_bigendian function
> > d54b335656b7 tools lib traceevent: Add plugin build support
> > e796a0d73bcc tools lib traceevent: Add plugin support
> > 28c803842250 perf tools: Include test-stackprotector-all.c in test-all
> > 1a69f6ce513d perf timechart: Move wake_events list to 'struct timechart'
> > [acme@ssdandy linux]$ 

> > [acme@ssdandy linux]$ time make O=/tmp/build/perf -C tools/perf/ install
> > <SNIP successful build>

> > [acme@ssdandy linux]$ ls -la ~/.traceevent
> > ls: cannot access /home/acme/.traceevent: No such file or directory
> > [acme@ssdandy linux]$

> > Where did the plugins go? At least two should be there by now, no?
 
> At this stage (patches applied) you'd need to run the make for
> traceevent directory.
 
> The perf installation link is done within this patch:
>     perf tools: Add build and install plugins targets
 
> which I presume you haven't applied yet? 

No I haven't, and I expected that I could test it straight away, so I
suggest you reorder the patches so that, right after the first plugin is
introduced a:

  make -C tools/perf install

in all its variants (in place, with O=, etc) allows one to test it.

- Arnaldo
