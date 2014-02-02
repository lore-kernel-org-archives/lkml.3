Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaBBBG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 20:06:57 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:52155 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaBBBGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 20:06:55 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
Date: Sat, 1 Feb 2014 17:06:53 -0800
Message-ID: <CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Suresh Siddha <sbsiddha@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 11:27 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> That said, regardless of the allocation issue, I do think that it's
> stupid for kernel_fpu_{begin,end} to save the math state if
> "used_math" was not set.  So I do think__kernel_fpu_end() as-s is
> buggy and stupid.

For eager_fpu case, assumption was every task should always have
'used_math' set. But i think there is a race,  where we drop the fpu
explicitly by doing drop_fpu() and meanwhile if we get an interrupt
etc that ends up using fpu?

so I will Ack for option "b", as option "a" breaks the features which
don't take into account cr0.TS.

Meanwhile I have the patch removing the delayed dynamic allocation for
non-eager fpu. will post it after some testing.

thanks,
suresh
