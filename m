Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965428AbaKNLvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:51:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965175AbaKNLvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:51:07 -0500
Date: Fri, 14 Nov 2014 12:50:39 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alexandre Montplaisir <alexmonthy@voxpopuli.im>,
        linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Matthew Khouzam <matthew.khouzam@ericsson.com>
Subject: Re: FW: [RFC 0/5] perf tools: Add perf data CTF conversion
Message-ID: <20141114115039.GB13976@krava.redhat.com>
References: <53F38C74.4030300@voxpopuli.im>
 <20140820092858.GA1203@krava.brq.redhat.com>
 <53F4F38C.4080407@voxpopuli.im>
 <5457C259.8030605@linutronix.de>
 <545829CA.7040900@voxpopuli.im>
 <20141105125028.GA30087@linutronix.de>
 <545AEA37.601@voxpopuli.im>
 <54650580.5070408@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54650580.5070408@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding Matthew Khouzam to the loop

jirka

On Thu, Nov 13, 2014 at 08:24:48PM +0100, Sebastian Andrzej Siewior wrote:
> I try to get through my ctf mailbox and I hoped I can finish it today
> but I don't make it completely…
> 
> On 11/06/2014 04:25 AM, Alexandre Montplaisir wrote:
> > "mvn clean install". It is the Maven equivalent of "./configure && make" ;)
> > 
> > Or if you want to build a standalone application (RCP):
> > mvn clean install -Pbuild-rcp -Dmaven.test.skip=true
> 
> thanks.
> 
> > Yes, the state dump is something specific to LTTng. It allows us to know
> > about processes that exist on the system, even if they are sleeping for
> > the whole duration of the trace (and thus, would not show up in the
> > trace at all).
> > 
> > But even if these events are not present, we can still know about active
> > processes when they do shed_switch's for example.
> 
> good to know.
> 
> > IIRC, compat_sys is for instance for 32-bit system calls on a 64-bit
> > kernel. Perhaps the "compat" system calls are recorded as standard
> > system call events with perf? We could test it once we get the base
> > things working.
> 
> I booted a x86-64 in a 32bit userland and I expected to see them
> somewhere but nothing. However if the task has a compat flag then it
> would be the same information, right?
> 
> >> - static final String SYS_CLONE = "sys_clone";
> >>    here we have
> >>      syscalls:sys_enter_clone
> >>      syscalls:sys_exit_clone
> >>    I guess the enter is what you are looking for.
> >>
> >> For the fields, this is one event with alle the members we have. Please
> >> note that lttng saves the members with the _ prefix and I haven't seen
> >> that prefix in that .java file.
> > 
> > As Mathieu explained in his reply, in LTTng-CTF they have a _ before
> > field names. In our parser, we take out the first character if it is an
> > underscore. So it should still work with underscore-less fields.
> 
> I see. I think it started working once I added the underline prefix but
> I might be wrong. Let me see what Mathieu says if I may leave that
> prefix out.
> 
> > Cheers,
> > Alexandre
> Sebastian
