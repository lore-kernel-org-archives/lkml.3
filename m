Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961Ab3IFIw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 04:52:56 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46924 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3IFIwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 04:52:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130906171916.41b5f48d1aaccca594d1e760@canb.auug.org.au>
References: <20130906171916.41b5f48d1aaccca594d1e760@canb.auug.org.au>
Date: Fri, 6 Sep 2013 10:52:52 +0200
X-Google-Sender-Auth: 9vqFXEy5xOJWwbBPd1Yn2pLU-6A
Message-ID: <CAMuHMdXib30o3-70EuYj3to0==b7LfwPbivF9DaBrpHPejsDFg@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the final tree (Linus'
 tree related - vai vfs tree)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 9:19 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the final tree, today's linux-next build (arm defconfig)
> produced this warning:
>
> fs/direct-io.c: In function 'sb_init_dio_done_wq':
> fs/direct-io.c:557:2: warning: value computed is not used [-Wunused-value]
>
> This is:
>
>         cmpxchg(&sb->s_dio_done_wq, NULL, wq);
>
> Introduced by commit 7b7a8665edd8 ("direct-io: Implement generic deferred
> AIO completions").

This happens for include/asm-generic/cmpxchg.h and several other
arch-specific implementations that cast the return value of cmpxchg()
like

#define cmpxchg(ptr, o, n)   ((__typeof__(*(ptr)))__cmpxchg(....

If the caller of cmpxchg() doesn't use the return value, we get a
compiler warning,
at least with some versions of gcc.

Any idea how to fix this once and for good?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
