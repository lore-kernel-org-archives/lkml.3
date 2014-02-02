Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbaBBBoy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 20:44:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37490 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaBBBow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 20:44:52 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CALmL7E_ijZStgyxj4Gnn69sEF-kv+eBE64+J7OBfn-K4cbBmJg@mail.gmail.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan> <CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com> <CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com> <CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com> <CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com> <52ED9EA9.7080009@zytor.com> <CALmL7E_ijZStgyxj4Gnn69sEF-kv+eBE64+J7OBfn-K4cbBmJg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 01 Feb 2014 17:43:57 -0800
To: Suresh Siddha <sbsiddha@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Message-ID: <802bb1f1-1b0c-43d7-bd0e-3eb7ce93a0c2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What does the inner if clause do? It looks like it returns either way...

On February 1, 2014 5:35:13 PM PST, Suresh Siddha <sbsiddha@gmail.com> wrote:
>On Sat, Feb 1, 2014 at 5:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Even "b" does that, no?
>
>oh right. It needs an else. only for non-eager fpu case we should do
>stts()
>
>  void __kernel_fpu_end(void)
>  {
>          if (use_eager_fpu()) {
>                  struct task_struct *me = current;
>
>                 if (tsk_used_math(me) && likely(!restore_fpu_checking(
>me)))
>                          return;
>          } else
>                  stts();
>  }
>
>thanks,
>suresh
>
>> "a" should be fine as long as we don't ever use
>> those features in the kernel, even under kernel_fpu_begin/end().

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
