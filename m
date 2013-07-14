Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3GNT3H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:29:07 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:58056 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3GNT3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:29:06 -0400
MIME-Version: 1.0
In-Reply-To: <51E2FACA.3050801@goop.org>
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com>
	<CA+55aFwKQQtTrgm7O8MLkqGgno-CsLSTM8tjrjuGmmqPEAZghw@mail.gmail.com>
	<51E2FACA.3050801@goop.org>
Date: Sun, 14 Jul 2013 12:29:04 -0700
X-Google-Sender-Auth: f8DlpoWZ7c_isD1tQJiAKu2WroI
Message-ID: <CA+55aFxsAcfRxcgQqEPPShKObqp=hqVz7HbLAHAzk1kcWA30Pg@mail.gmail.com>
Subject: Re: [PATCH] x86/asm: avoid mnemonics without type suffix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eli Friedman <eli.friedman@gmail.com>,
        Jim Grosbach <grosbach@apple.com>, Stephen Checkoway <s@pahtak.org>,
        LLVMdev <llvmdev@cs.uiuc.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 12:23 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> It looks like that if the base address isn't aligned then neither is the
> generated access, so you could get a protection fault if it overlaps a
> page boundary, which is a semantic rather than purely operational
> difference.

You could also get AC fault for the btq if the thing is only long-aligned.

But yes, I checked the Intel manuals too, and the access size is
actually not well-specified (even the 16-bit case says "may", I
think), so both the page-fault and the alignment fault are purely
theoretical. And i'm too lazy to bother trying the (easily testable)
alignment fault case in practice, since (a) nobody cares and (b)
nobody cares.

In the (unlikely) situation that somebody actually cares, that
somebody should obviously then have to specify "btl" vs "btq".
Assuming the hardware cares, which is testable but might be
micro-architecture dependent.

                         Linus
