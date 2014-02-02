Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbaBBBru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 20:47:50 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:57132 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaBBBrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 20:47:48 -0500
MIME-Version: 1.0
In-Reply-To: <802bb1f1-1b0c-43d7-bd0e-3eb7ce93a0c2@email.android.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	<CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
	<52ED9EA9.7080009@zytor.com>
	<CALmL7E_ijZStgyxj4Gnn69sEF-kv+eBE64+J7OBfn-K4cbBmJg@mail.gmail.com>
	<802bb1f1-1b0c-43d7-bd0e-3eb7ce93a0c2@email.android.com>
Date: Sat, 1 Feb 2014 17:47:48 -0800
X-Google-Sender-Auth: kMI4nhQm4Qly-SiyUAxnVrgcVwI
Message-ID: <CA+55aFzFTUJjRCT_Ajw4xRmo3HH3+zYyhwwjMm53y=fOAR=bog@mail.gmail.com>
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

On Sat, Feb 1, 2014 at 5:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> What does the inner if clause do? It looks like it returns either way...

Suresh broke it with his suggested version.

The inner if-statement is supposed to avoid the stts *if* we had used
math *and* the FPU restore worked.

But with the extra "else" that Suresh added, it now always avoids the
stts for the eager-fpu case, which breaks the whole logic for "hey, if
the process hadn't used math, we don't waste time restoring data that
doesn't exist". And, as you say, making the inner if clause pointless.

         Linus
