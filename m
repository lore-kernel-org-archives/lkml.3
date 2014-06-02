Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaFBHJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:09:28 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:52686 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaFBHJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:09:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140602022211.GN6677@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<538995D4.9050702@zytor.com>
	<alpine.LFD.2.11.1405311055410.17310@knanqh.ubzr>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
	<20140602022211.GN6677@dastard>
Date: Mon, 2 Jun 2014 09:09:23 +0200
X-Google-Sender-Auth: ucJLYpLDnEBNYh8KUivO1xla42g
Message-ID: <CAMuHMdX=5WEpySgtd5xvt=4ZVNesonJc7k3=GJmuVS9KEiwrMA@mail.gmail.com>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 4:22 AM, Dave Chinner <david@fromorbit.com> wrote:
> Filesystems place all sorts of userspace visible limits on storage -
> ever tried to create a file >16TB on ext4? The on-disk format
> doesn't support it, so it returns an out of range error (E2BIG, I
> think) if you try. XFS, OTOH, handles this just fine and so it
> continues to work. It's exactly the same with timestamps - there's a
> physical limit to what can sanely be stored in any given filesystem
> and it's an *error condition* to go beyond that limit....

This comparison doesn't fly.
File sizes do not depend on the current time (except for the increase of
megapixels in your new camera ;-).
Writing a 15 GiB file to ext4 is not something that magically stops working
tomorrow.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
