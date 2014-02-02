Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaBBCFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 21:05:09 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:33104 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBBCFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 21:05:06 -0500
MIME-Version: 1.0
In-Reply-To: <52EDA60A.50906@zytor.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	<CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
	<52ED9EA9.7080009@zytor.com>
	<CALmL7E_ijZStgyxj4Gnn69sEF-kv+eBE64+J7OBfn-K4cbBmJg@mail.gmail.com>
	<CA+55aFw-im55F=6PJ1T-=dtmb4+NcnRpZ9nxx=+khUe+sLNxxw@mail.gmail.com>
	<CALmL7E_D=aK-PZQe43wZueWqJ_YNXhaFagTSr=K1Xk-xwLLh+w@mail.gmail.com>
	<CA+55aFxzYMCXop7KSUi9EuaTF-m4qpbM4ahrELW8gKHDZVwkZA@mail.gmail.com>
	<52EDA60A.50906@zytor.com>
Date: Sat, 1 Feb 2014 18:05:05 -0800
X-Google-Sender-Auth: dpexmMSgjdXYJQeNaqFcsNKbDtY
Message-ID: <CA+55aFyYyRb5L=cUvciyv39EXwioG8-u_usnyy_WyZOQDG2VBg@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <sbsiddha@gmail.com>,
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

On Sat, Feb 1, 2014 at 5:57 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Twiddling CR0.TS is pretty slow if we're not taking advantage of it.

Immaterial.

We *already* avoid twiddling TS if it's not needed.

It is true that we used to twiddle it at every context switch (and
then twiddle it *again* if we decided that we'd want to pre-load the
FPU state anyway, and avoid the extra fault).

But that was fixed, and if we switch from a task that had math state
to another task that has math state, we leave TS alone.

But Suresh apparently hits on the real issue:

> not all the state under xsave adhers to cr0.TS/DNA rules

which if so is sad but yes, makes CR0.TS no longer sufficient.

             Linus
