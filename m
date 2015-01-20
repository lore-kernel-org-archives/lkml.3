Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbbATTus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:50:48 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:50615 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbbATTur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:50:47 -0500
Date: Tue, 20 Jan 2015 19:50:45 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 3/3] x86: drop support for 1995 era EISA based
 platforms
In-Reply-To: <CA+55aFzN2PvWJ6g1Vbe-_oODyX7EiSeDhw5SD=wJeyENnHX41A@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1501201922110.28301@eddie.linux-mips.org>
References: <1421723901-32303-1-git-send-email-paul.gortmaker@windriver.com>        <1421723901-32303-4-git-send-email-paul.gortmaker@windriver.com>        <alpine.LFD.2.11.1501200350230.28301@eddie.linux-mips.org>
 <CA+55aFzN2PvWJ6g1Vbe-_oODyX7EiSeDhw5SD=wJeyENnHX41A@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Linus Torvalds wrote:

> >  Well, I'd like to keep my x86 box up and alive, to support EISA FDDI
> > equipment I maintain if nothing else -- which in particular means the
> > current head version of Linux, not some ancient branch.
> 
> So if we actually have a user, and it works, then no, we're not
> removing EISA support. It's not like it hurts us or is in some way
> fundamentally broken, like the old i386 code was (i386 kernel page
> fault semantics really were broken, and the lack of some instructions
> made it more painful to maintain than needed - not like EISA at all,
> which is just a pure add-on on the side).

 Thanks.  Last version I tried was 3.18.0-rc1-next-20141023 sometime last 
November.  It worked just fine, booted to the multiuser mode with no 
issue.  I'll have to refresh the build sometime.

 It's a plain EISA box, no PCI.  The EISA FDDI board referred works fine 
(it uses our DMA API for bus mastering) as does an ISA 3c509B Ethernet 
adapter configured for the EISA mode.  The card supports it -- it looks 
like a true EISA board to software then, there's no need to poke at random 
port I/O locations anymore to detect it -- as does our driver.

 I have a small patch outstanding to reserve the BIOS area at 0xffff0000 
(used at reset as per the x86 architecture definition) so that systems 
that do not support the 0xe820 call do not attempt to allocate MMIO in 
that range.  It may matter for some old PCI systems as well, I suppose.  
I just need to verify it does not cause a conflict with systems that do 
support that call.

 Other than that it seems maintenance-free to me.

  Maciej
