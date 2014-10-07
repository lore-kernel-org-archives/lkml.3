Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbaJGXUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:20:36 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:36236 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbaJGXU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:29 -0400
Date: Wed, 8 Oct 2014 01:20:20 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Rich Felker <dalias@libc.org>, David Daney <ddaney.cavm@gmail.com>,
        libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Message-ID: <20141007232019.GA30470@linux-mips.org>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <20141006205459.GZ23797@brightrain.aerifal.cx>
 <5433071B.4050606@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5433071B.4050606@caviumnetworks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 02:18:19PM -0700, David Daney wrote:

> >As an alternative, if the space of possible instruction with a delay
> >slot is sufficiently small, all such instructions could be mapped as
> >immutable code in a shared mapping, each at a fixed offset in the
> >mapping. I suspect this would be borderline-impractical (multiple
> >megabytes?), but it is the cleanest solution otherwise.
> >
> 
> Yes, there are 2^32 possible instructions.  Each one is 4 bytes, plus you
> need a way to exit after the instruction has executed, which would require
> another instruction.  So you would need 32GB of memory to hold all those
> instructions, larger than the 32-bit virtual address space.

Plus errata support for some older CPUs requires no other instructions
that might cause an exception to be present in the same cache line inflating
the size to 32 bytes per instruction.

I've contemplated a full emulation - but that would require an emulator that
is capable of most of the instruction set.  With all the random ASEs around
that would be hard to implement while the FPU emulator trampoline as currently
used has the advantage of automatically supporting ASEs, known and unknown.
So it's a huge bonus for maintenance.

  Ralf
