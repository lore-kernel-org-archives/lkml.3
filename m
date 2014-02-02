Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbaBBBvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 20:51:11 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:41086 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaBBBvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 20:51:08 -0500
MIME-Version: 1.0
In-Reply-To: <CALmL7E_D=aK-PZQe43wZueWqJ_YNXhaFagTSr=K1Xk-xwLLh+w@mail.gmail.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	<CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
	<52ED9EA9.7080009@zytor.com>
	<CALmL7E_ijZStgyxj4Gnn69sEF-kv+eBE64+J7OBfn-K4cbBmJg@mail.gmail.com>
	<CA+55aFw-im55F=6PJ1T-=dtmb4+NcnRpZ9nxx=+khUe+sLNxxw@mail.gmail.com>
	<CALmL7E_D=aK-PZQe43wZueWqJ_YNXhaFagTSr=K1Xk-xwLLh+w@mail.gmail.com>
Date: Sat, 1 Feb 2014 17:51:07 -0800
X-Google-Sender-Auth: QBKWUDUZMyXX_04bIwWgEFe_yGc
Message-ID: <CA+55aFxzYMCXop7KSUi9EuaTF-m4qpbM4ahrELW8gKHDZVwkZA@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Suresh Siddha <sbsiddha@gmail.com>
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

On Sat, Feb 1, 2014 at 5:47 PM, Suresh Siddha <sbsiddha@gmail.com> wrote:
>
> So if the restore failed, we should do something like drop_init_fpu(),
> which will restore init-state to the registers.
>
> for eager-fpu()  paths we don't use clts() stts() etc.

Uhhuh. Ok.

Why do we do that, btw? I think it would make much more sense to just
do what I *thought* we did, and just make it a context-switch-time
optimization ("let's always switch FP state"), not make it a huge
semantic difference.

                Linus
