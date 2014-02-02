Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaBBAR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 19:17:29 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:45685 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbaBBAR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 19:17:27 -0500
MIME-Version: 1.0
In-Reply-To: <52ED85DD.6020402@zytor.com>
References: <20140201211710.20281.qmail@science.horizon.com>
	<52ED85DD.6020402@zytor.com>
Date: Sat, 1 Feb 2014 16:17:26 -0800
X-Google-Sender-Auth: TWK9up_AwuJrnv8KTxltbxwIIvA
Message-ID: <CA+55aFyk=M2XeZd2rBR0hM3NQ5h8r26TgoEOtw4syaOjm3q75A@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: George Spelvin <linux@horizon.com>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Nate Eldredge <nate@thatsmathematics.com>,
        Pekka Riikonen <priikone@iki.fi>, Suresh Siddha <sbsiddha@gmail.com>,
        stable <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 3:40 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> OK, let's circle back for a bit.  We have an active bug, and we clearly
> have a lot of restructuring that could/should be done.  We need to fix
> the bug first; if we're going to a bunch of restructuring then that
> ought to be separate.  The first bit is how we fix the immediate bug.

So either of my suggested changes to __kernel_fpu_end() _should_ fix
the bug, with the caveat that if we do take the "check tsk-used-math"
version, we had better verify that yes, we allocate the save storage
before we set that flag. One of the reasons I tended to prefer simpler
the "just do stts()" version is that it seemed safer. I am a bit
worried about the whole interaction with synchronous task state and
interrupts.

Suresh's notion of just always allocating the FP state save area at
process creation would fix it too.

So many ways to fix it, so little knowledge about the actual usage
patterns and performance issues..

              Linus
