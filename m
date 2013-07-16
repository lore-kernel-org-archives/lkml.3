Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab3GPFQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 01:16:27 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:39964 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3GPFQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 01:16:26 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwTSXAt=GV=7WuX0yrJpHsFK=WbbDaRJbvvdejsWA0aOg@mail.gmail.com>
References: <1373361330-3946-1-git-send-email-realmz6@kernel.org>
	<CAMuHMdWR12v9vHYZM1RJC3zJA0JCdr5K8VY3Gn2+HaR+5iNfzw@mail.gmail.com>
	<CA+55aFwTSXAt=GV=7WuX0yrJpHsFK=WbbDaRJbvvdejsWA0aOg@mail.gmail.com>
Date: Tue, 16 Jul 2013 13:16:25 +0800
Message-ID: <CAMk6uBmvMsLEkRoVjoLUD4WUpchxGp2ZhQx8gN2a=NbC4hnUMw@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.11
From: Steven Miao <realmz6@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Steven Miao <realmz6@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 1:49 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jul 15, 2013 at 10:28 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>>
>> but the first one is non-trivial: using xchg() on atomic_t is a bit gross...
>
> It's also broken. There's no guarantee that an "atomic_t" is just a
> value. Now, the old sparc32 stuff (which hid lock bits in atomic_t)
> may be gone, but it's still the case that atomic_t may not actually
> work with xchg.
>
> (In *practice* it works on normal architectures, so I'm not saying
> that we don't have it, but it's a bug if we do).
>
> There are "atomic_xchg()" and "atomic_xchg64()" functions that are supported.
I'll send a patch to fix it.
>
>              Linus
