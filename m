Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbaKMTYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:24:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:48832 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933650AbaKMTYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:24:53 -0500
Message-ID: <54650580.5070408@linutronix.de>
Date: Thu, 13 Nov 2014 20:24:48 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
CC: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: FW: [RFC 0/5] perf tools: Add perf data CTF conversion
References: <53F38C74.4030300@voxpopuli.im> <20140820092858.GA1203@krava.brq.redhat.com> <53F4F38C.4080407@voxpopuli.im> <5457C259.8030605@linutronix.de> <545829CA.7040900@voxpopuli.im> <20141105125028.GA30087@linutronix.de> <545AEA37.601@voxpopuli.im>
In-Reply-To: <545AEA37.601@voxpopuli.im>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I try to get through my ctf mailbox and I hoped I can finish it today
but I don't make it completely…

On 11/06/2014 04:25 AM, Alexandre Montplaisir wrote:
> "mvn clean install". It is the Maven equivalent of "./configure && make" ;)
> 
> Or if you want to build a standalone application (RCP):
> mvn clean install -Pbuild-rcp -Dmaven.test.skip=true

thanks.

> Yes, the state dump is something specific to LTTng. It allows us to know
> about processes that exist on the system, even if they are sleeping for
> the whole duration of the trace (and thus, would not show up in the
> trace at all).
> 
> But even if these events are not present, we can still know about active
> processes when they do shed_switch's for example.

good to know.

> IIRC, compat_sys is for instance for 32-bit system calls on a 64-bit
> kernel. Perhaps the "compat" system calls are recorded as standard
> system call events with perf? We could test it once we get the base
> things working.

I booted a x86-64 in a 32bit userland and I expected to see them
somewhere but nothing. However if the task has a compat flag then it
would be the same information, right?

>> - static final String SYS_CLONE = "sys_clone";
>>    here we have
>>      syscalls:sys_enter_clone
>>      syscalls:sys_exit_clone
>>    I guess the enter is what you are looking for.
>>
>> For the fields, this is one event with alle the members we have. Please
>> note that lttng saves the members with the _ prefix and I haven't seen
>> that prefix in that .java file.
> 
> As Mathieu explained in his reply, in LTTng-CTF they have a _ before
> field names. In our parser, we take out the first character if it is an
> underscore. So it should still work with underscore-less fields.

I see. I think it started working once I added the underline prefix but
I might be wrong. Let me see what Mathieu says if I may leave that
prefix out.

> Cheers,
> Alexandre
Sebastian
