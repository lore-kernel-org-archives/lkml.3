Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaBRJB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:01:57 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61879 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbaBRJBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:01:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140217214553.GB11655@kmo>
References: <CAMuHMdUYZLv4X3VBEOgcf+Dr22Pi1xWx-6oMPX7usBk6HJHTMw@mail.gmail.com>
	<530279EC.5010605@infradead.org>
	<CAMuHMdUnCdEoyD+seYXJD+e4bED9=ceUCC7NYsoRa1_vc3g4Hw@mail.gmail.com>
	<20140217214553.GB11655@kmo>
Date: Tue, 18 Feb 2014 10:01:54 +0100
X-Google-Sender-Auth: 2T55Yz3IMNsgh3KzWHfPs-pmTo8
Message-ID: <CAMuHMdVOwWq4AOEjiRSfZ7V_YOSE_LMK9PNJyw8-hJVY9RJekQ@mail.gmail.com>
Subject: Re: New bcache compiler warning (was: Re: bcache: Minor fixes from
 kbuild robot)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 10:45 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> *swears* Actually, I'm just going to cast this to unsigned (that's definitely
> safe here):
>
>
> commit 70bc49d421c793f73a772ae1f50622a39c6136d9
> Author: Kent Overstreet <kmo@daterainc.com>
> Date:   Mon Feb 17 13:44:06 2014 -0800
>
>     bcache: Fix another compiler warning on m68k

JFYI, you also get this warning on other 32-bit platforms (e.g. ARM).

>     Use a bigger hammer this time

Looks like it's big enough, now ;-)

>     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
>
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 3f74b4b074..5454164153 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -23,8 +23,8 @@ void bch_dump_bset(struct btree_keys *b, struct bset *i, unsigned set)
>         for (k = i->start; k < bset_bkey_last(i); k = next) {
>                 next = bkey_next(k);
>
> -               printk(KERN_ERR "block %u key %li/%u: ", set,
> -                      (uint64_t *) k - i->d, i->keys);
> +               printk(KERN_ERR "block %u key %u/%u: ", set,
> +                      (unsigned) ((u64 *) k - i->d), i->keys);
>
>                 if (b->ops->key_dump)
>                         b->ops->key_dump(b, k);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
