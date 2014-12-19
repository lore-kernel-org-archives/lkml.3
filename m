Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaLSWTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:19:37 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:65311 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaLSWTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:19:35 -0500
Date: Sat, 20 Dec 2014 01:19:32 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Hector Marco <hecmargi@upv.es>, Pavel Emelyanov <xemul@parallels.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Anton Blanchard <anton@samba.org>, Jiri Kosina <jkosina@suse.cz>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arun Chandran <achandran@mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ismael Ripoll <iripoll@disca.upv.es>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hanno =?iso-8859-1?Q?B=F6ck?= <hanno@hboeck.de>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kees Cook <keescook@chromium.org>, Reno Robert <renorobert@gmail.com>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
Message-ID: <20141219221932.GH6810@moon>
References: <5489E6D2.2060200@upv.es>
 <5489FAAD.7000606@upv.es>
 <20141211221158.GS18807@outflux.net>
 <548B18AC.9@upv.es>
 <CALCETrVAaDDvAttVkJ+1ygymE_uEZOCLtGHHN15v_VDf1PVsmA@mail.gmail.com>
 <5494A0DF.10905@upv.es>
 <CALCETrWB_T9ui=_JSQRLrtbNDx=sJ22im1XujhxptfZRtedeeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWB_T9ui=_JSQRLrtbNDx=sJ22im1XujhxptfZRtedeeg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 02:11:37PM -0800, Andy Lutomirski wrote:
...
> >
> > Therefore, I can fix the current implementation (maintaining the
> > randomize_va_space=2) by moving the PIE executable from the mmap base
> > area to another one for x86*, ARM* and MIPS (as s390 and PowerPC do).
> > But we shall agree that this increment in the page table is not a
> > issue. Otherwise, the randomize_va_space=3 shall be considered.
> 
> Wrt the vdso itself, though, there is an extra consideration: CRIU.  I
> *think* that the CRIU vdso proxying scheme will work even if the vdso
> changes sizes and is adjacent to other mappings.  Cyrill and/or Pavel,
> am I right?

At least that was the idea. I've been testing old vdso from rhel5 proxified
to 3.x series where vvar segment is present, worked well.

> I'm not fundamentally opposed to mapping the vdso just like any other
> shared library.  I still think that we should have an extra-strong
> randomization mode in which all the libraries are randomized wrt each
> other, though.  For many applications, the extra page table cost will
> be negligible.
