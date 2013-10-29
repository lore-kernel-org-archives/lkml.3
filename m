Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3J2Owm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:52:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3J2Owl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:52:41 -0400
Subject: Re: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
From: Mark Wielaard <mjw@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Pekka Enberg <penberg@iki.fi>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com
In-Reply-To: <526F2949.5000208@hitachi.com>
References: <20131023044511.1886.82571.stgit@hemant-fedora>
	 <20131023050502.1886.15779.stgit@hemant-fedora>
	 <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
	 <526E4940.8000608@hitachi.com> <526E5BA5.7050103@iki.fi>
	 <20131028141152.GA1040@linux.vnet.ibm.com> <526E72EC.9060400@iki.fi>
	 <20131028173152.GB1040@linux.vnet.ibm.com> <526EA366.4020204@iki.fi>
	 <526F2949.5000208@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Oct 2013 15:51:55 +0100
Message-ID: <1383058315.6521.3158.camel@bordewijk.wildebeest.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-29 at 12:19 +0900, Masami Hiramatsu wrote:
> (2013/10/29 2:48), Pekka Enberg wrote:
> > For the 32-bit and 64-bit libc case, why cannot 'perf list'
> > by default print out something like:
> > 
> > $ perf list
> > 
> >    libc:setjmp [SDT marker group]
> > 
> > and provide a '--fully-qualified' command line option that:
> > 
> > $ perf list --fully-qualified
> > 
> > libc:setjmp => libc32:setjmp, libc64:setjmp      [SDT marker group]
> > libc32:setjmp => libc:setjmp@/lib/libc.so.6      [SDT marker]
> > libc64:setjmp => libc:setjmp@/lib64/libc.so.6  [SDT marker]
> > 
> > and then teach 'perf trace' to deal with SDT marker groups
> > where you trace two events, not one?
> 
> Ah, that's a good idea. :)
> And it also is needed for another probe event because
> sometimes inlined functions have multiple instances.
> I'd like to fold them as one event group.

A nice user case to think about when designing this interface might be
the java hotspot jvm (libjvm.so). It has SDT markers with the same name
that might occur at multiple addresses depending on code path taken or
compiler optimization. And there are multiple libjvm.so variants
depending on whether the user uses the client or server VM. And users
often have multiple major versions installed (both 1.6 and 1.7 are
currently being shipped by some distros and can be installed in
parallel).

Normally a user that wants to monitor say the hotspot:gc__begin SDT
probe wants to see that probe in whatever code path it happens and in
whatever libjvm.so happens to be running (client or server and 1.6 or
1.7 version). But might still want to be able to specify a specific
variant.

Cheers,

Mark

