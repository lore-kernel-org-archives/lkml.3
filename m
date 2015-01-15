Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbbAOWVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:21:08 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43169 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbbAOWVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:21:05 -0500
Date: Thu, 15 Jan 2015 22:21:01 +0000
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: EFI mixed mode + perf = rampant triple faults
Message-ID: <20150115222101.GE12079@codeblueprint.co.uk>
References: <5491B4A8.905@amacapital.net>
 <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
 <20141231183739.GA28946@console-pimps.org>
 <20150114165151.GA3479@codeblueprint.co.uk>
 <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
 <20150115194127.GB12079@codeblueprint.co.uk>
 <54B81C2E.2090909@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B81C2E.2090909@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan, at 11:59:42AM, H. Peter Anvin wrote:
> On 01/15/2015 11:41 AM, Matt Fleming wrote:
> >>
> >>Tianocore makes assumptions about the kernel's GDT layout?  Yuck.
> >
> >No, but 32-bit Tianocore does rely on the second GDT entry being a
> >32-bit CS.
> >
> >It has no knowledge of Linux's GDT layout.
> >
> 
> If it assumes that descriptor 16 is a 32-bit CS (and what about
> data? 24?) that *is* making assumptions on the kernel.

Bear in mind that this is before ExitBootServices() is invoked, so where
the firmware still thinks it (not the OS) "owns" the platform.

None of this comes into play at Runtime.

-- 
Matt Fleming, Intel Open Source Technology Center
