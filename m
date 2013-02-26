Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab3BZOpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 09:45:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179Ab3BZOpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 09:45:34 -0500
Date: Tue, 26 Feb 2013 15:38:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 1/5] perf tools: Fix -C option for record command
Message-ID: <20130226143838.GA31165@redhat.com>
References: <1361785972-7431-1-git-send-email-jolsa@redhat.com> <1361785972-7431-2-git-send-email-jolsa@redhat.com> <20130225183932.GA7352@redhat.com> <512BB3E6.6000904@gmail.com> <20130225193851.GD17149@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225193851.GD17149@krava.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Jiri Olsa wrote:
>
> On Mon, Feb 25, 2013 at 11:56:38AM -0700, David Ahern wrote:
>
> > If a target is given (-a, -C, -p or -t) that is what the data is
> > collected for -- all cpus, a cpu, or one or more task ids. The
> > workload in that case becomes a means for bounding the data
> > collection (start and end points).

OK, so I misunderstood the intent and misread the code. Thanks
David.

> yes, that's what actually this patch fixies.. now you can run:
>
>   perf record -C 0 ls
>
> and that will attach to cpu 0 only (same as '-a -C 0' before)

Yes, and thus this is consistent with -a and correct. Thanks and
sorry for noise.


But,

> maybe we could consider having:
>
>   perf record -C 0 ls
>     - attaching to CPU 0 and ls workload pid
>
>   perf record -a -C 0 ls
>     - attaching to CPU 0 globaly

Can't really comment since I am not a perf user, but imho looks good.

And useful. And least this behaviour was useful to me when I tried
to test the perf/uprobe changes.

Oleg.

