Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbaJHKb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:31:59 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:38158 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaJHKb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:31:57 -0400
Date: Wed, 8 Oct 2014 11:31:49 +0100
From: Paul Burton <paul.burton@imgtec.com>
To: David Daney <ddaney@caviumnetworks.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Rich Felker <dalias@libc.org>,
        "David Daney" <ddaney.cavm@gmail.com>, <libc-alpha@sourceware.org>,
        <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Message-ID: <20141008103149.GO4704@pburton-laptop>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <20141006205459.GZ23797@brightrain.aerifal.cx>
 <5433071B.4050606@caviumnetworks.com>
 <20141007232019.GA30470@linux-mips.org>
 <54347E47.1080809@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <54347E47.1080809@caviumnetworks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.159.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 04:59:03PM -0700, David Daney wrote:
> On 10/07/2014 04:20 PM, Ralf Baechle wrote:
> >On Mon, Oct 06, 2014 at 02:18:19PM -0700, David Daney wrote:
> >
> >>>As an alternative, if the space of possible instruction with a delay
> >>>slot is sufficiently small, all such instructions could be mapped as
> >>>immutable code in a shared mapping, each at a fixed offset in the
> >>>mapping. I suspect this would be borderline-impractical (multiple
> >>>megabytes?), but it is the cleanest solution otherwise.
> >>>
> >>
> >>Yes, there are 2^32 possible instructions.  Each one is 4 bytes, plus you
> >>need a way to exit after the instruction has executed, which would require
> >>another instruction.  So you would need 32GB of memory to hold all those
> >>instructions, larger than the 32-bit virtual address space.
> >
> >Plus errata support for some older CPUs requires no other instructions
> >that might cause an exception to be present in the same cache line inflating
> >the size to 32 bytes per instruction.
> >
> >I've contemplated a full emulation - but that would require an emulator that
> >is capable of most of the instruction set.  With all the random ASEs around
> >that would be hard to implement while the FPU emulator trampoline as currently
> >used has the advantage of automatically supporting ASEs, known and unknown.
> >So it's a huge bonus for maintenance.
> >
> 
> Unfortunatly it breaks when our friends at Imgtec introduce their PC
> relative instructions in mipsr6, so an emulator may be unavoidable.
> 
> David Daney

Just to note, this was also discussed when I submitted my much older
patch with a similar goal:

  http://patchwork.linux-mips.org/patch/6125/

...and the conclusion there also began converging towards full ISA
emulation (or at least, the subset of the ISA which userland can
execute):

  http://www.linux-mips.org/archives/linux-mips/2014-07/msg00034.html

For the record my preference is for emulation. It is in some ways more
work, but it's also much cleaner. Given that more instructions will need
to be emulated to run pre-R6 binaries on R6 systems anyway, the emulator
would only become increasingly useful.

Paul
