Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3J2NXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:23:11 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53097 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3J2NXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:23:09 -0400
Date: Tue, 29 Oct 2013 14:23:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        Runzhen Wang <icycoder@gmail.com>
Subject: Re: [PATCH 14/16] perf kvm: reuse some code of
 perf_kvm__timerfd_create()
Message-ID: <20131029132304.GA22052@gmail.com>
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
 <1369527896-3650-15-git-send-email-dsahern@gmail.com>
 <20130912130849.GA23826@gmail.com>
 <5231C2EF.8080200@gmail.com>
 <20130912134058.GF23826@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130912134058.GF23826@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> * David Ahern <dsahern@gmail.com> wrote:
> 
> > On 9/12/13 6:08 AM, Ingo Molnar wrote:
> > >
> > >btw., I tried to build perf on a really old distro that has no timerfd.h,
> > >and got:
> > 
> > Right. I hit that last week or so with RHEL5 as a build server.
> > 
> > timerfd was introduced before perf so any system with perf capability 
> > will also have timerfd. So the problem is strictly building perf on an 
> > older system. [...]
> 
> I'm booting new kernels on an old system and I'm building it there.
> 
> So it's new kernel, new perf source and binary, old userspace.

Btw., this build failure is still there today:

  CC       builtin-kvm.o
builtin-kvm.c:23:25: error: sys/timerfd.h: No such file or directorycc1: warnings being treated as errors
builtin-kvm.c: In function ‘perf_kvm__timerfd_create’:
builtin-kvm.c:975: warning: implicit declaration of function ‘timerfd_create’
builtin-kvm.c:975: warning: nested extern declaration of ‘timerfd_create’
builtin-kvm.c:975: error: ‘TFD_NONBLOCK’ undeclared (first use in this function)
builtin-kvm.c:975: error: (Each undeclared identifier is reported only once
builtin-kvm.c:975: error: for each function it appears in.)
builtin-kvm.c:986: warning: implicit declaration of function ‘timerfd_settime’
builtin-kvm.c:986: warning: nested extern declaration of ‘timerfd_settime’
make[1]: *** [builtin-kvm.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [all] Error 2

So it would be nice to at least make it build somehow.

Thanks,

	Ingo
