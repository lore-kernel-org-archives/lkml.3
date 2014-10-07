Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbaJGTLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:11:30 -0400
Received: from 216-12-86-13.cv.mvl.ntelos.net ([216.12.86.13]:59760 "EHLO
	brightrain.aerifal.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbaJGTL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:11:29 -0400
Date: Tue, 7 Oct 2014 15:09:43 -0400
From: Rich Felker <dalias@libc.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Matthew Fortune <Matthew.Fortune@imgtec.com>,
        David Daney <david.s.daney@gmail.com>,
        David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
Message-ID: <20141007190943.GM23797@brightrain.aerifal.cx>
References: <20141006215813.GB23797@brightrain.aerifal.cx>
 <543327E7.4020608@amacapital.net>
 <54332A64.5020605@caviumnetworks.com>
 <20141007000514.GD23797@brightrain.aerifal.cx>
 <543334CE.8060305@caviumnetworks.com>
 <20141007004915.GF23797@brightrain.aerifal.cx>
 <54337127.40806@gmail.com>
 <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org>
 <543431DA.4090809@imgtec.com>
 <CALCETrUQEbb=DotSzsneN7Hano_eC-EoTMko6uKcyZXvEcktkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUQEbb=DotSzsneN7Hano_eC-EoTMko6uKcyZXvEcktkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 11:44:35AM -0700, Andy Lutomirski wrote:
> > 4)  The voice for doing any instruction emulation in kernel - it is not a
> > MIPS business model to force customer to put details of all Coprocessor 2
> > instructions public. We provide an interface and the rest is a customer
> > business. Besides that it is really painful to make a differentiation
> > between Cavium Octeon and some another CPU instructions with the same
> > opcode. On other side, leaving emulation of their instructions to them is
> > not a wise after having some good way doing that multiple years.
> 
> IMO this is all backwards.  If MIPS customers put proprietary
> instructions into their ISA, they leave out the FPU, and they put a
> proprietary insn in a branch delay slot, then I think that they
> deserve a fatal signal.

I agree completely here. We should not break things (or, as it seems,
leave them broken) for common usage cases that affect everyone just to
coddle proprietary vendor-specific instructions. The latter just
should not be used in delay slots unless the chip vendor also promises
to provide fpu branch in hardware.

Rich
