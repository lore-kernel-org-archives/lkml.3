Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbaKSSkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:40:15 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:33304 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbaKSSkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:40:11 -0500
MIME-Version: 1.0
In-Reply-To: <c25e1a64e5b718fa156e141fd9ecbf31011c6059.1416352397.git.luto@amacapital.net>
References: <cover.1416352397.git.luto@amacapital.net>
	<c25e1a64e5b718fa156e141fd9ecbf31011c6059.1416352397.git.luto@amacapital.net>
Date: Wed, 19 Nov 2014 10:40:10 -0800
X-Google-Sender-Auth: 0cOBFDCuHFUmMq7fURcvEaUgW1M
Message-ID: <CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] sched, x86: Check that we're on the right stack in
 schedule and __might_sleep
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 3:15 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On x86, sleeping while on an IST or irq stack has a surprisingly
> good chance of working, but it can also fail dramatically.  Add an
> arch hook to allow schedule and __might_sleep to catch sleeping on
> the wrong stack.

Why doesn't the normal in_interrupt() test catch this?

          Linus
