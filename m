Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaDWCs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:48:56 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:62587 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaDWCsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:48:54 -0400
MIME-Version: 1.0
In-Reply-To: <5356FCC1.6060807@zytor.com>
References: <5356FCC1.6060807@zytor.com>
Date: Tue, 22 Apr 2014 19:48:54 -0700
X-Google-Sender-Auth: TTYZ8E_PIg3ZnTZlmyXmoFFy2oY
Message-ID: <CA+55aFwsPs12_57YEBHdb4ti1BXSuDX_RPSf6S4JSRLGK_2X7Q@mail.gmail.com>
Subject: Re: Why do we set _PAGE_DIRTY for page tables?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 4:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I just noticed this:
>
> #define _PAGE_TABLE     (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |       \
>                          _PAGE_ACCESSED | _PAGE_DIRTY)
> #define _KERNPG_TABLE   (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |   \
>                          _PAGE_DIRTY)
>
> Is there a reason we set _PAGE_DIRTY for page tables?  It has no
> function, but doesn't do any harm either (the dirty bit is ignored for
> page tables)... it just looks funny to me.

I think it just got copied, and at least the A bit does matter even in
page tables (well, it gets updated, I don't know how much that
"matters"). So the fact that D is ignored is actually the odd man out.

               Linus
