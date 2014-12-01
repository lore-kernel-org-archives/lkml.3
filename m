Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbaLAUpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:45:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355AbaLAUpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:45:07 -0500
Date: Mon, 1 Dec 2014 21:44:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: =?iso-8859-1?Q?J=E9r=E9mie?= Galarneau 
	<jeremie.galarneau@efficios.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexandre Montplaisir <alexmonthy@voxpopuli.im>,
        linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Trace Compass Developer Discussions 
	<tracecompass-dev@eclipse.org>,
        Matthew Khouzam <matthew.khouzam@ericsson.com>, andreas@linutronix.de
Subject: Re: Support for Perf CTF traces now in master (was Re: FW: [RFC 0/5]
 perf tools: Add perf data CTF conversion)
Message-ID: <20141201204428.GC13302@krava.brq.redhat.com>
References: <53F4F38C.4080407@voxpopuli.im>
 <5457C259.8030605@linutronix.de>
 <545829CA.7040900@voxpopuli.im>
 <20141105125028.GA30087@linutronix.de>
 <545AEA37.601@voxpopuli.im>
 <5460156E.3050601@voxpopuli.im>
 <5463DBD5.9080303@voxpopuli.im>
 <20141126173721.GA6829@linutronix.de>
 <20141128112650.GD27703@krava.brq.redhat.com>
 <CA+jJMxsM6iX8wGjWw_kR6Db=of8d8pOg0wEFUxAdktCVsMOpXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+jJMxsM6iX8wGjWw_kR6Db=of8d8pOg0wEFUxAdktCVsMOpXA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 12:28:08PM -0500, Jérémie Galarneau wrote:
> On Fri, Nov 28, 2014 at 6:26 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Wed, Nov 26, 2014 at 06:37:21PM +0100, Sebastian Andrzej Siewior wrote:
> >> * Alexandre Montplaisir | 2014-11-12 17:14:45 [-0500]:
> >
> > SNIP
> >
> >>
> >> >This was based on the most recent file format I was aware of, we will
> >> >update it accordingly if required.
> >> >
> >> >Testing welcome!
> >>
> >> I pushed the perf changes I mentioned to
> >>
> >>   git://git.breakpoint.cc/bigeasy/linux.git ctf_convert_7
> >>
> >
> > from perf data convert point of view (and libbabeltrace).. ;-)
> >
> > I tried to convert big perf.data (2GB) and my laptop got stuck
> > for few minutes.. the reason is that perf allocated too much memory
> >
> > I needed to add occasional bt_ctf_stream_flush into the
> > processing (patch attached)
> >
> > What I do now is checking if we processed given amount of events
> > for the stream and once the value is crossed I flush it.
> >
> > My question is if there's a way to find out the allocated memory
> > for the stream?  It'd be nicer to setup maximum allocation size
> > rather than the number of events.
> >
> 
> Not currently, although I agree that this would be a nice feature.
> Perhaps by setting a maximal packet size, CTF Writer could handle the
> automatic flushing.
> 
> Thoughts?

hum, it looks like 2 separated things to me.. the packet size is
result format related size.. I'm more interested in the size of
the 'struct ctf_stream' within the writer during the processing

it seems it wont be trivial to track this AFAICS from sources, but
I guess I can live so far with tracking the the number of events,
until we find something else

thanks,
jirka
