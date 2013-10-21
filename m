Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab3JUIrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:47:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3JUIri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:47:38 -0400
Date: Mon, 21 Oct 2013 10:46:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 09/19] perf tools: Fix 32-bit cross build
Message-ID: <20131021084658.GA2958@krava.brq.redhat.com>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
 <1382099356-4918-10-git-send-email-adrian.hunter@intel.com>
 <20131020204251.GA12044@krava>
 <5264C140.1020903@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5264C140.1020903@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 08:53:04AM +0300, Adrian Hunter wrote:
> On 20/10/13 23:42, Jiri Olsa wrote:
> > On Fri, Oct 18, 2013 at 03:29:06PM +0300, Adrian Hunter wrote:
> >> Setting EXTRA_CFLAGS=-m32 did not work because CFLAGS
> >> was not passed around.
> > 
> > this breaks feature detection for me on x86_64,
> > I've got following errors misdetection with this patch:
> > 
> > ...                       libperl: [ OFF ]

how about this one?

> > ...                       on-exit: [ OFF ]
> > 
> > and the build fails as well:
> > 
> >   CC       builtin-stat.o
> > builtin-record.c:42:12: error: static declaration of ‘on_exit’ follows non-static declaration
> > In file included from util/util.h:51:0,
> >                  from builtin.h:4,
> >                  from builtin-record.c:8:
> > /usr/include/stdlib.h:536:12: note: previous declaration of ‘on_exit’ was here
> > make[1]: *** [builtin-record.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [all] Error 2
> 
> That is fixed in patch 11: perf tools: Fix test_on_exit for 32-bit build

hum, could we apply those patches in reverse order?
I think the notion is not to break build deliberatelly
for the bisection sake.

jirka
