Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaLENt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:49:29 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45275 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaLENt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:49:28 -0500
Date: Fri, 5 Dec 2014 13:49:33 +0000
From: Will Deacon <will.deacon@arm.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, Tejun Heo <tj@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141205134933.GM1630@arm.com>
References: <20141120152509.GA5412@redhat.com>
 <20141125122217.GA15280@arm.com>
 <20141201114854.GB18466@arm.com>
 <CA+55aFyhB5LBVadA5TfuX8+TrZZWTHwT-2NCYRLat8Fp6eBjgw@mail.gmail.com>
 <20141201171036.GH18466@arm.com>
 <CA+55aFwooh31=GMVUoriev+t92=roye_ck+czqr48M1sQ3UOMg@mail.gmail.com>
 <20141201182519.GA16749@node.dhcp.inet.fi>
 <CA+55aFz+ODi34J2n0kzXm+v++B7KW1e9NSFU=f-jgonPA1bNxg@mail.gmail.com>
 <20141204105103.GD14519@arm.com>
 <20141204145631.GA22794@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204145631.GA22794@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 02:56:31PM +0000, Dave Jones wrote:
> On Thu, Dec 04, 2014 at 10:51:03AM +0000, Will Deacon wrote:
> 
>  > and, as before, it has a weird child process that I can't backtrace:
>  > 
>  > trinity-c1      R  running task        0   861    811 0x00000000
>  > Call trace:
> 
> When I get these, ftrace is a godsend.
> 
> cd /sys/kernel/debug/tracing/
> echo 861 >> set_ftrace_pid
> echo function_graph >> current_tracer
> echo 1 >> tracing_on
> wait a little while
> cat trace > trace.txt
> 
> repeat last two steps if necessary
> 
> (assuming it's stuck in kernel space, which /proc/861/stack should
>  be able to confirm. Usually when I see this problem, that just shows
>  0xffffffffffffffff)

That would be great if I had a working shell :)

I tried enabling the thing before starting trinity, in the hope of dumping
the buffer using sysrq, but now I seem to have hit an unrelated panic in
the ftrace code.

Will
