Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbaBFUxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:53:39 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44728 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaBFUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:53:37 -0500
MIME-Version: 1.0
In-Reply-To: <20140206125058.8b5d884cca468b9850d5b538@linux-foundation.org>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
	<1389776784-30825-2-git-send-email-geert@linux-m68k.org>
	<1389783998.14001.22.camel@joe-AO722>
	<CAMuHMdUv_xP-1A950i0U=Petaey-_VosSxh5sk44Gqti-ikY6w@mail.gmail.com>
	<CAMuHMdVDdGBG0b2BY4PZRGWn-2ts-qz9_OdUdnAE9gMp_zP3jw@mail.gmail.com>
	<1391677607.15777.2.camel@joe-AO722>
	<20140206123824.ab35615f4561340d91255cf2@linux-foundation.org>
	<CAMuHMdVJ8N7UHWz6aMdurwpKwafb_V0AS7MyUQWftiH9C-8b5A@mail.gmail.com>
	<20140206125058.8b5d884cca468b9850d5b538@linux-foundation.org>
Date: Thu, 6 Feb 2014 21:53:34 +0100
X-Google-Sender-Auth: oYcieSjeEP41IUrRQdjDK9Eglq8
Message-ID: <CAMuHMdUY=499rdpKVmyOCC89cKg5J_nj8Si3bjhiVmo7r4E8Jw@mail.gmail.com>
Subject: Re: [PATCH -next 2/2] bcache: Use max_t() when comparing different types
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Kent Overstreet <kmo@daterainc.com>,
        Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 9:50 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 6 Feb 2014 21:45:36 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> > --- a/drivers/md/bcache/btree.c~bcache-drop-l-suffix-when-comparing-ssize_t-with-0-fix
>> > +++ a/drivers/md/bcache/btree.c
>> > @@ -1805,7 +1805,7 @@ static bool btree_insert_key(struct btre
>> >
>> >  static size_t insert_u64s_remaining(struct btree *b)
>> >  {
>> > -       ssize_t ret = bch_btree_keys_u64s_remaining(&b->keys);
>> > +       size_t ret = bch_btree_keys_u64s_remaining(&b->keys);
>> >
>> >         /*
>> >          * Might land in the middle of an existing extent and have to split it
>> > @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(stru
>> >         if (b->keys.ops->is_extents)
>> >                 ret -= KEY_MAX_U64S;
>>
>> I think the reason is the line above: with size_t, ret may become a big
>> positive number when the subtraction wraps below zero.
>
> Well, I assumed that case would be a bug - otherwise the programmer
> would have commented such a subtlety.  Wouldn't he?
>
>> >
>> > -       return max(ret, 0);
>> > +       return max_t(size_t, ret, 0);
>>
>> That part is OK, cfr. my v1 (which I had planned to send out as v3 again).
>
> It needs to be ssize_t.

Yes, of course. CET sleep time...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
