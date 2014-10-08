Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaJHCis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 22:38:48 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:59778 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaJHCir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 22:38:47 -0400
Date: Tue, 7 Oct 2014 22:37:33 -0400
From: Rich Felker <dalias@libc.org>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: David Daney <ddaney@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney.cavm@gmail.com>, libc-alpha@sourceware.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Message-ID: <20141008023733.GO23797@brightrain.aerifal.cx>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <20141006205459.GZ23797@brightrain.aerifal.cx>
 <5433071B.4050606@caviumnetworks.com>
 <20141007232019.GA30470@linux-mips.org>
 <54347E47.1080809@caviumnetworks.com>
 <20141007191833.4d625472@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007191833.4d625472@as>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 07:18:33PM -0500, Chuck Ebbert wrote:
> On Tue, 7 Oct 2014 16:59:03 -0700
> David Daney <ddaney@caviumnetworks.com> wrote:
> 
> > On 10/07/2014 04:20 PM, Ralf Baechle wrote:
> > > On Mon, Oct 06, 2014 at 02:18:19PM -0700, David Daney wrote:
> > >
> > >>> As an alternative, if the space of possible instruction with a delay
> > >>> slot is sufficiently small, all such instructions could be mapped as
> > >>> immutable code in a shared mapping, each at a fixed offset in the
> > >>> mapping. I suspect this would be borderline-impractical (multiple
> > >>> megabytes?), but it is the cleanest solution otherwise.
> > >>>
> > >>
> > >> Yes, there are 2^32 possible instructions.  Each one is 4 bytes, plus you
> > >> need a way to exit after the instruction has executed, which would require
> > >> another instruction.  So you would need 32GB of memory to hold all those
> > >> instructions, larger than the 32-bit virtual address space.
> > >
> > > Plus errata support for some older CPUs requires no other instructions
> > > that might cause an exception to be present in the same cache line inflating
> > > the size to 32 bytes per instruction.
> > >
> > > I've contemplated a full emulation - but that would require an emulator that
> > > is capable of most of the instruction set.  With all the random ASEs around
> > > that would be hard to implement while the FPU emulator trampoline as currently
> > > used has the advantage of automatically supporting ASEs, known and unknown.
> > > So it's a huge bonus for maintenance.
> > >
> > 
> > Unfortunatly it breaks when our friends at Imgtec introduce their PC 
> > relative instructions in mipsr6, so an emulator may be unavoidable.
> > 
> 
> The x86 kprobes code deals with executing relocated insns with
> PC-relative offsets by adjusting the offset in a relocated instruction
> before executing it.
> 
> See arch/x86/kernel/kprobes/core.c::__copy_instruction()

This only works if you have an ISA that can represent the full range
of possible relative addresses. It does not work for MIPS where the
range is quite restricted by the fixed instruction size.

Rich
