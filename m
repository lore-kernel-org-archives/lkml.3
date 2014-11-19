Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbaKSXm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:42:27 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:41557 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaKSXm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:42:26 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411200025440.3909@nanos>
References: <cover.1416352397.git.luto@amacapital.net>
	<c25e1a64e5b718fa156e141fd9ecbf31011c6059.1416352397.git.luto@amacapital.net>
	<CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com>
	<20141119192928.GL12538@two.firstfloor.org>
	<CA+55aFwykb6aZYgyZXbU1DQ3OL0umpv8gkHYWykBEC2B7UdMbw@mail.gmail.com>
	<CALCETrXi7vdNAk4RziNDtqX4asPqXxi1VsLzL7pP0zivkjTH4Q@mail.gmail.com>
	<CA+55aFx4-WzNQ0e-ZTcCig3b7U7xmt1WB1jzO3TLk9zHD006ng@mail.gmail.com>
	<alpine.DEB.2.11.1411200025440.3909@nanos>
Date: Wed, 19 Nov 2014 15:42:25 -0800
X-Google-Sender-Auth: QVLcZw09c4xojOsmOBwL0yQXCeA
Message-ID: <CA+55aFwa6+kt0rGeQ1YX2qkwTMyAsEgWAtkN86Nap1ROJyjmog@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] sched, x86: Check that we're on the right stack in
 schedule and __might_sleep
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 3:32 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> preempt_count is a per cpu variable at least on x86 since:

Oh, goodie. I hadn't tracked that it went in, I just remembered the
discussion. I should have looked.

And apparently we do it in nmi_enter too, so NMI is already ok. Don't
know about the others.

                Linus
