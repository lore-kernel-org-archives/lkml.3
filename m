Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbbAOTlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:41:32 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61382 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbbAOTlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:41:31 -0500
Date: Thu, 15 Jan 2015 19:41:27 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: EFI mixed mode + perf = rampant triple faults
Message-ID: <20150115194127.GB12079@codeblueprint.co.uk>
References: <5491B4A8.905@amacapital.net>
 <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
 <20141231183739.GA28946@console-pimps.org>
 <20150114165151.GA3479@codeblueprint.co.uk>
 <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan, at 10:27:47AM, Andy Lutomirski wrote:
> 
> How are you manually triggering an MCE?  I've been playing with some
> MCE stuff recently, but the only reasonably reliable way I know of to
> trigger an MCE is using WHEA, and I don't have a box with WHEA, and I
> assume your ASUS T100 doesn't either.
 
As Borislav mentions, I used 'int $18', solely to trigger the 64-bit
exception handler code paths in the middle of the EFI mixed mode code.

> > Where this won't work so well is at boot time before we jump to the
> > kernel proper. There, we still need to restore the firmware's GDT so
> > that interrupts are serviced correctly before ExitBootServices() (in
> > particular, ia32 Tianocore assumes __KERNEL_CS is a 32-bit CS).
> 
> Tianocore makes assumptions about the kernel's GDT layout?  Yuck.

No, but 32-bit Tianocore does rely on the second GDT entry being a
32-bit CS.

It has no knowledge of Linux's GDT layout.

-- 
Matt Fleming, Intel Open Source Technology Center
