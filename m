Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3ILVSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:18:51 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:52929 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab3ILVSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:18:50 -0400
Date: Thu, 12 Sep 2013 23:18:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912211846.GA7890@gmail.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912201855.GC32644@gmail.com>
 <20130912203831.GD11400@ghostprotocols.net>
 <20130912204618.GA3262@gmail.com>
 <52322D81.5090708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52322D81.5090708@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 9/12/13 1:46 PM, Ingo Molnar wrote:
> >>>Mind outlining the approach you are thinking about?
> >>>
> >>>Firstly, please don't even think about autotools. (Just forget it exists.)
> >>
> >>hehe, no, that wasn't considered.
> >
> >/phew! :-)
> 
> kconf approach of course:
>   https://lkml.org/lkml/2013/4/1/600
> (minus the manual steps in that RFC).

I'm not sure what the end stage is where you'd like to arrive, but I don't 
think that forcing a separate configuration pass is an improvement :-/

By default a simple 'make' should build perf to the maximum extent 
possible, with no other input required from the user - with warnings 
displayed as package install suggestions.

This:

 Enable newt-based TUI (NEWT) [N/y] (NEW) y
 Enable GTK-based UI (GTK2) [N/y] (NEW) n
 Enable support for Bionic (e.g., Android platform) (BIONIC) [N/y] (NEW)
 Development support for libc is available - glibc or bionic (LIBC) [N/y] 
 (NEW) y
   Enable support for libelf (LIBELF) [N/y] (NEW) y
     Enable support for libunwind (LIBUNWIND) [N/y] (NEW) y
     Enable support for dwarf (DWARF) [N/y] (NEW) y
     Enable support for demangle (DEMANGLE) [N/y] (NEW) y
 Enable support for perl scripting engine (LIBPERL) [N/y] (NEW) y
 Enable support for python scripting engine (LIBPYTHON) [N/y] (NEW) y
 Enable support for libaudit (LIBAUDIT) [N/y/?] (NEW) y
 Enable support for libnuma (LIBNUMA) [N/y/?] (NEW) y
 Enable support for stack backtrace debugging (BACKTRACE) [N/y] (NEW) y

would be useful only as long as each listed option is actually 
_buildable_. I.e. it should not be possible for the user to configure perf 
in a way that makes the build fail.

I.e. this should go on top of a feature detection logic, allowing further 
customization, for features that the user might want to turn off.

Thanks,

	Ingo
