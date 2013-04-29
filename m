Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab3D2S2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:28:42 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:41348 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507Ab3D2S2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:28:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130429162115.GA6893@kroah.com>
References: <20130429162115.GA6893@kroah.com>
Date: Mon, 29 Apr 2013 11:28:40 -0700
X-Google-Sender-Auth: lrUdlEbji3lLH-9d_iafXQTxgbE
Message-ID: <CA+55aFz7bESS-T2_5vndVEzbk7ocmfEanBO+sviTSNekOLKRcg@mail.gmail.com>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 9:21 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Here's the big char / misc driver update for 3.10-rc1

Ugh. What the f*ck is up with stuff like this:

>  drivers/ssbi/Kconfig                               |  16 +
>  drivers/ssbi/Makefile                              |   1 +
>  drivers/ssbi/ssbi.c                                | 379 ++++++++++++++

Seriously? "ssbi" is such a major driver subsystem that it needs its
own subdirectory at the top level?

We can't just go adding random single drivers at the top level. Now,
giving it a subdirectory of its own is certainly fine (there should be
more drivers that decide "I'll put my files away from others", but it
should be under drivers/misc/ or something. There's no way this is at
the same level as "networking" or "pci".

                    Linus
