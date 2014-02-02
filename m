Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbaBBBfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 20:35:18 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:47461 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBBBfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 20:35:15 -0500
MIME-Version: 1.0
In-Reply-To: <52ED9EA9.7080009@zytor.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	<CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
	<52ED9EA9.7080009@zytor.com>
Date: Sat, 1 Feb 2014 17:35:13 -0800
Message-ID: <CALmL7E_ijZStgyxj4Gnn69sEF-kv+eBE64+J7OBfn-K4cbBmJg@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Suresh Siddha <sbsiddha@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 5:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Even "b" does that, no?

oh right. It needs an else. only for non-eager fpu case we should do stts()

  void __kernel_fpu_end(void)
  {
          if (use_eager_fpu()) {
                  struct task_struct *me = current;

                  if (tsk_used_math(me) && likely(!restore_fpu_checking(
me)))
                          return;
          } else
                  stts();
  }

thanks,
suresh

> "a" should be fine as long as we don't ever use
> those features in the kernel, even under kernel_fpu_begin/end().
