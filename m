Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbaLBMO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:14:26 -0500
Received: from imap.thunk.org ([74.207.234.97]:34164 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556AbaLBMOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:14:21 -0500
Date: Tue, 2 Dec 2014 07:14:16 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Checking to see if a bit is _not_ set in a ftrace event filter
Message-ID: <20141202121415.GA20127@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Alexei Starovoitov <ast@plumgrid.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20141202021912.GA29096@thunk.org>
 <20141201214104.32d3f10d@gandalf.local.home>
 <CAMEtUuzEg39N9ZALuq-u4X+oaNJGqL6G05UABSHYpejQ78Cp3Q@mail.gmail.com>
 <20141202050406.GC953@thunk.org>
 <CAMEtUuyyrUToWgczxdpj+SUEdr16NknQa_ZmWoGr8f261kyqmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuyyrUToWgczxdpj+SUEdr16NknQa_ZmWoGr8f261kyqmg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 09:58:32PM -0800, Alexei Starovoitov wrote:
> well, dwarf is only needed if you have > 6 function
> arguments in x64, since x64 ABI promotes scalars
> to 64-bit and passes first six args in registers, so it's
> trivial to know where arguments are even without debug info.

Well, if eBPF can get more information without DWARF, that's great.
I'll use whatever I can get, so long as I can do it without DWARF.  :-)

So if eBPF can do a better job without the presence of debug info, and
even a better job with debug info (i.e., distro kernels where it's
worth the time to spend over an hour compiling a distro release rpm or
deb package), that would clearly be the best of both worlds.  I
suspect that developers like me will want to continue to add
tracepoints so we can do what we need to get done w/o debug info,
though.

(To me that was always the reason why I ignored systemtap; it focused
too much on the need of the release customer --- which makes sense,
since nearly all of the stap developers worked for Red Hat --- but it
ignored the needs of kernel developers.  So they shouldn't have been
surprised that most kernel developers returned the favor.  :-)

> Similar situation is on most 64-bit risc archs.
> dwarf is needed when one wants to see a value of
> local C variable somewhere in the middle of the function,
> but it's not common and rarely works in practice, since
> var-tracking is not easy for compilers.

Yes; fortunately, we can make that available via adding new
tracepoints --- which in general is why I'm in favor of not relying on
the ability to grab information via pure kprobe and kretprobe.  If we
can get the first six arguments on x86_64, then if I didn't think to
add a tracepoint, I can do some emergency debugging w/o needing to
recompile, which is a win.  (But since I also do a lot of debug runs
using 32-bit kernels, it would be nice to have things that worked
there as well, which is why in general I'll add tracepoints once I
find that it might be useful to trace a particular function.)

Cheers,

						- Ted
