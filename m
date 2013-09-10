Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3IJT13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:27:29 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:57552 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab3IJT11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:27:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130910191319.GZ13318@ZenIV.linux.org.uk>
References: <CA+5PVA4k9tTPs9vtTbMuG7pzw4kb3KFK-CLaqDDG4dm=0twyCQ@mail.gmail.com>
	<CA+55aFzg_r2c09TkGwmsMV3HbNAkSFJLGAFWweLNzofqs4o4Ug@mail.gmail.com>
	<CA+5PVA6EDV3zuDEyCvcGNvEAPtgY_Oy9xVbaM03ggRBPtq5Mmg@mail.gmail.com>
	<CA+55aFympAk-hnekaew8po5wLJdiY+DC_b4h=pa-y5i9=s303Q@mail.gmail.com>
	<CA+55aFygRtwwknO4Jb+nna046VhdNCXh2S0ybRBPf=b1GH9FPg@mail.gmail.com>
	<20130910184324.GY13318@ZenIV.linux.org.uk>
	<CA+55aFwFQei-j47xZU06MZZ+S2ki2-dyi=7b7+U+QX_3FAYevQ@mail.gmail.com>
	<20130910191319.GZ13318@ZenIV.linux.org.uk>
Date: Tue, 10 Sep 2013 12:27:27 -0700
X-Google-Sender-Auth: qtbefDBHBi02lM_Vjm0JnM7QCek
Message-ID: <CA+55aFym_7gE5mpaWYkyLWuP-rAB3LnYgb4zmOw4M4bPjFoN1Q@mail.gmail.com>
Subject: Re: kernel BUG at fs/dcache.c:648! with v3.11-7890-ge5c832d
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Josh Boyer <jwboyer@gmail.com>, Waiman Long <Waiman.Long@hp.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Mace Moneta <moneta.mace@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 12:13 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Ugh...  I really don't like that - your patch introduces the situations
> when race with chroot can lead to two absolute symlinks in the same path
> being interpreted wrt different roots.  And yes, sure, anybody who gets
> in that kind of races isn't going to get particulary sane results, but
> still, I'd rather have simpler semantics here...

Well, that "root is whatever it happens to be when we encounter the
slash" semantics is actually what we used to have before nameidata
anyway, so I don't actually believe it's anything new.

But I'll commit the simple patch that doesn't clean things up. I guess
we can always revisit this later (although I fear that once it all
works, we'll just leave it in the ugly state).

> Another thing: could you merge vfs.git#for-linus?  It's getting really
> messy to keep track of changes both in mainline and in vfs.git, especially
> since there's a pile of pending stuff (lru_list work) that needs to be
> resolved wrt both...

Will do. I was hoping to get this sorted out first.

              Linus
