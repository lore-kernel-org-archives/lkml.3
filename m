Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaJHPyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:54:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103AbaJHPx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:53:59 -0400
Date: Wed, 8 Oct 2014 12:53:48 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com, peterz@infradead.org,
        mingo@elte.hu, dsahern@gmail.com
Subject: Re: [PATCH v2] perf tools: fix off-by-one error in maps
Message-ID: <20141008155348.GD2256@redhat.com>
References: <20141006083532.GA4850@quad>
 <8761fwh1nc.fsf@sejong.aot.lge.com>
 <20141007140050.GB2256@redhat.com>
 <20141007135838.5e3e364c@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007135838.5e3e364c@as>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 07, 2014 at 01:58:38PM -0500, Chuck Ebbert escreveu:
> On Tue, 7 Oct 2014 11:00:50 -0300
> Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > I keep thinking that this change is making things unclear.
> > 
> > I.e. the _start_ of a map (map->start) is _in_ the map, and the _end_
> > of a map (map->end) is _in_ the map as well.
> > 
> > 	if (addr > m->end)
> > 
> > is shorter than:
> > 
> > 	if (addr >= m->end)
> > 
> > "start" and "end" should have the same rule applied, i.e. if one is in,
> > the other is in as well.
> > 
> > Etc.
> > 
> 
> But the convention used in the memory management code is that "end" is
> the next byte after the memory region. This gives you:
> 
>   size = end - start
>   end = start + size
> 
> Using a different convention here will just confuse people used to the
> way it's done everywhere else.

So we should continue using some confusing convention because that is
the way that things are? :-\

- Arnaldo
