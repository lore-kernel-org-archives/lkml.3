Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaCCVQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:16:37 -0500
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:36278
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbaCCVQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:16:35 -0500
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=Rs1LLUWK c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=M1kyBYkWWGkA:10 a=IVxCAUdSCW8A:10
 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=A_vnTMG_VKNsp4RD3M8A:9
 a=QEXdDO2ut3YA:10
Date: Mon, 3 Mar 2014 21:16:33 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.13.5 : rm -rf running forever, one cpu at approx 100%
Message-ID: <20140303211633.GA7702@milliways>
References: <20140227005246.GB10367@milliways>
 <1393471595.5519.22.camel@marge.simpson.net>
 <20140227034535.GC14346@milliways>
 <1393476762.5519.35.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393476762.5519.35.camel@marge.simpson.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 05:52:42AM +0100, Mike Galbraith wrote:
> On Thu, 2014-02-27 at 03:45 +0000, Ken Moffat wrote: 
> > On Thu, Feb 27, 2014 at 04:26:35AM +0100, Mike Galbraith wrote:
> > > 
> > > I would start with strace to see if a task is looping in userspace, then
> > > move on to perf top -g -p <pid> (or perf record/report) to peek at what
> > > it's up to in the kernel.  Once you have the where, trace_printk() is
> > > the best thing since sliced bread (which ranks just below printk()).
> > > 
> > > -Mike
> >  Thanks.  I'll need to build perf.
> 
> You may want to build the kernel with frame-pointers too, for easy gdb
> list *0x(hexnum) of *func()+0x(hexoffset) use.  Crash is also pretty
> handy both for rummaging live via crash vmlinux /proc/kcore, and for
> leisurely postmortem analysis if you set the box up to crashdump in
> advance, and force a dump (poke sysrq-c or echo c > /proc/sysrq-trigger)
> when you see the bad thing happen.  Crash has all kinds of goodies,
> including invocation of gdb.
> 
> -Mike

 In fact, it seems I had already enabled perf, but not built the
userspace part.  However, I was motivated to build crash, and a
kernel with frame pointers plus a _lot_ of debug options.
Unsurprisingly, that ran like a dog, and many things seemed to use a
lot of CPU according to top (e.g. 'X', at least for the first
several minutes after it started), but I couldn't replicate the
problem.  Also proved that my OpenJDK script doesn't normally trash
/etc/passwd- :)

 Then, I went back to the original 3.13.5, proved that perf was
working, and built a new LFS system in chroot, again with 3.13.5, in
chroot.  Booted it as soon as I'd built xorg, then went on through
glib/gtk, firefox, print/photo programs, libreoffice.  No problems at
all, apart from the common "needed to use -j3 for gcc, because it's
a phonon".  NB I forgot to mention that this is all 64-bit, and the
box has 8GB.

 If something does happen here in the next few days (I've still got
to sort out my kde scripts and build that) then I'll reply to this.
But otherwise, I guess it must be cosmic rays, or maybe Gaffer forgot
to feed and muck-out the imps.

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce
