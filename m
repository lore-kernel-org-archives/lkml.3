Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaBBBr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 20:47:57 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56921 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaBBBry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 20:47:54 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw-im55F=6PJ1T-=dtmb4+NcnRpZ9nxx=+khUe+sLNxxw@mail.gmail.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	<CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
	<52ED9EA9.7080009@zytor.com>
	<CALmL7E_ijZStgyxj4Gnn69sEF-kv+eBE64+J7OBfn-K4cbBmJg@mail.gmail.com>
	<CA+55aFw-im55F=6PJ1T-=dtmb4+NcnRpZ9nxx=+khUe+sLNxxw@mail.gmail.com>
Date: Sat, 1 Feb 2014 17:47:51 -0800
Message-ID: <CALmL7E_D=aK-PZQe43wZueWqJ_YNXhaFagTSr=K1Xk-xwLLh+w@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Suresh Siddha <sbsiddha@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
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

On Sat, Feb 1, 2014 at 5:38 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> It definitely does not want an else, I think.
>
> If tsk_used_math() is false, or if the FPU restore failed, we
> *definitely* need that stts(). Otherwise we'd return to user mode with
> random contents in the FP state, and let user mode muck around with
> it.
>
> No?

So if the restore failed, we should do something like drop_init_fpu(),
which will restore init-state to the registers.

for eager-fpu()  paths we don't use clts() stts() etc.

thanks,
suresh
