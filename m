Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbaDVVYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:24:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbaDVVYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:24:01 -0400
Date: Tue, 22 Apr 2014 17:23:24 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        William Cohen <wcohen@redhat.com>
Subject: Re: mapping instructions to dynamic languages like java, python, ruby
Message-ID: <20140422212323.GP8488@redhat.com>
References: <20140422180305.GK8488@redhat.com>
 <CABPqkBTJ4==4FF2KLVGzvpGSX_RhHVZWUH5h9Vvi+XG_xJSUEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTJ4==4FF2KLVGzvpGSX_RhHVZWUH5h9Vvi+XG_xJSUEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 09:05:11PM +0200, Stephane Eranian wrote:
> Hi Don,
> 
> I have been working on the JIT code support for a while now.
> I have something working well for more than Java now. It reuses
> some of the same principles as the OProfile support but extend
> them to support more advanced JIT features such as address
> recycling and code movements.
> 
> I intend to contribute that code for perf once it is finalized.
> Note that it uses a module developed by Sonny Rao to
> export the perf timestamp time source via a posix-clock.
> This clock discussion has been going on for a while and
> never reached a conclusion. So I decided to go with the
> simple posix-clock module for the time being.

Nice!  I am in no rush for it, just didn't want to waste time
investigating it if someone else was already doing some work.  Any
thoughts on a timeframe until it is finalized?  A couple of months or so?

Cheers,
Don

> 
> 
> Thanks.
> 
> 
> On Tue, Apr 22, 2014 at 8:03 PM, Don Zickus <dzickus@redhat.com> wrote:
> > Hi,
> >
> > I was discussing recently with Will Cohen about how to get perf to
> > understand dynamic languages (java, python, ruby) better.  Currently, perf
> > samples and address, stores it in a mmap region (from the kernel side),
> > the mmap region is read (from user side async) and stored in a file.
> >
> > During 'perf report' those instruction addresses are looked up in the
> > dwarf table?? of the binary they were mapped to, to resolve their symbols.
> >
> > This works great for statically compiled binaries (like C), where the
> > addresses stay the same during each run of the binary.
> >
> > However, for dynamic languages like java, python, ruby not only do those
> > addresses change each run of the binary, those address can change
> > _during_ the execution of the binary.  As a result the normal perf
> > collection method fails.
> >
> > Oprofile has a mechanism to work around this, by creating a debug library
> > for java that records class information.  This library is linked?? during
> > the initial execution of the java program and all its symbol info is
> > recorded in a temp file.  During post-processing this temp file is read
> > back in and symbol info is obtained.
> >
> > However, this approach is java specific and only works for programs that
> > initially start with it (can not attach to running programs).
> >
> > Thoughts have come up about using a SIGPROF from the kernel to signal the
> > userspace interpreters to dump information to a temp file that can be used
> > later during post-processing.
> >
> > Does anyone have any thoughts or experience on this?
> >
> > Cheers,
> > Don
> >
