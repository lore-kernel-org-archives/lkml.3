Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433AbaFSPgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:36:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:48201 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933128AbaFSPg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:36:29 -0400
Date: Thu, 19 Jun 2014 12:36:25 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC/PATCH] perf tools: Fix segfault in cumulative.callchain
 report
Message-ID: <20140619153625.GC20252@kernel.org>
References: <1402821332-12419-1-git-send-email-jolsa@kernel.org>
 <1402836391.1684.9.camel@leonhard>
 <20140615163404.GA1159@krava.brq.redhat.com>
 <1402924462.1647.26.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402924462.1647.26.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 16, 2014 at 10:14:22PM +0900, Namhyung Kim escreveu:
> 2014-06-15 (일), 18:34 +0200, Jiri Olsa:
> > On Sun, Jun 15, 2014 at 09:46:31PM +0900, Namhyung Kim wrote:
> > > 2014-06-15 (일), 10:35 +0200, Jiri Olsa:
> > > > not completely sure this is what we want to do, but have no
> > > > streght to dive into annotation code ;-)

> > > Currently, cumulative entries do not accounts annotation info so
> > > annotation only works for normal entries.  I'm not sure we should
> > > support it or not, but anyway it also needs some updates on the
> > > annotation code IMHO.

> > > So I'm okay with disabling annotation on pure cumulative entries.

> > is that an ack? ;-)

> Yep,
 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

>From a quick look, this looks sane, i.e. only offering annotation for
symbols where samples were taken.

Otherwise we would have to figure out which samples came thru the
specific point in the callchain selected, which, as Namhyung mentioned,
requires more thinking and coding.

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
