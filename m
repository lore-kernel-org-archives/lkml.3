Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249Ab3B0QjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:39:23 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:56901 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab3B0QjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:39:21 -0500
MIME-Version: 1.0
In-Reply-To: <20130227111502.GE4832@osiris>
References: <20130226045424.GA3576@osiris>
	<CA+55aFx8pUSHPhC_-ob2i5BbvBkEC4BVYtAbNkf3+FE+=3AmgA@mail.gmail.com>
	<20130226125739.GA3924@osiris>
	<CA+55aFycXwZi-U2uJWWusLGeaV3=BMEBdgcxGN9Lo0QcHHUrDA@mail.gmail.com>
	<CA+55aFzCU3jKDssYj9sDJU-VkugCfy_Cv5+VhMv9renZ94jRdQ@mail.gmail.com>
	<CA+55aFzckUoJGEywgentKT-vQieiuLu-mQtELiA6UotWqBWH7A@mail.gmail.com>
	<CA+55aFz3JW6HnTC-4xqOBsgQNboLbjvZnQ0h7KfaZjQVinAt2g@mail.gmail.com>
	<20130227111502.GE4832@osiris>
Date: Wed, 27 Feb 2013 08:39:20 -0800
X-Google-Sender-Auth: 7LIeujEIW1H78mJj9rP9mARFlHY
Message-ID: <CA+55aFyRbHpvq+QMFG3VgtAxZKPapqGg5r0ZagnvA03_E8XLVw@mail.gmail.com>
Subject: Re: bug in generic strncpy_from_user
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 3:15 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
>
> Tested with 64 bit kernel with 64 bit and 31 bit mode user space as well as
> with 31 bit kernel and 31 bit user space. Each with legacy and flexible
> mmap layout.
> The bug is fixed and everything else still seems to work. Thanks!
>
> Tested-By: Heiko Carstens <heiko.carstens@de.ibm.com>

Ok, committed.

I'm not marking it for stable, because it doesn't seem to matter all
that much, but if there was some application that actually broke and
made you notice it that way (as opposed to you just noticing the odd
memory map), you might want to inform the stable team about commit
09884964335e.

                    Linus
