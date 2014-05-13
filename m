Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaEMUfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:35:15 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:45033 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaEMUfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:35:09 -0400
MIME-Version: 1.0
In-Reply-To: <8399002.IIyBoyEHox@wuerfel>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<6202090.0OtAjefIFT@wuerfel>
	<CAMuHMdVxc3XRanpboWPumvQKbg-qdRBHQvYXwjTKX4CrxXPeAw@mail.gmail.com>
	<8399002.IIyBoyEHox@wuerfel>
Date: Tue, 13 May 2014 22:35:08 +0200
X-Google-Sender-Auth: vye1X-_amGAtlb2cukXj6zOnzAM
Message-ID: <CAMuHMdW5HSVyXpz9HFcrDDYq=zOFrBr6d8jOd8i_FMkXsEpr2Q@mail.gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, May 13, 2014 at 9:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> I think we have three categories:

Thanks for the list!

> a) interfaces that uses relative time_t/timespec/timeval:
> b) interfaces that don't make sense for times in the past:

> c) interfaces that require absolute times:
>    - stat/lstat/fstatat/
>    - utime/utimes/futimesat
>
> These absolutely have to use something better than time_t
> both in user space and in the kernel so we can deal with
> old files. A lot of file systems need to be fixed as well so
> we can actually store the times, regardless of whether we
> are running a 32 or 64 bit kernel.

So these are the ones we have to worry about.
It looks like they all involve I/O? Apart from the case of using block data
from the buffer cache, the 64-bit operations should disappear in the
actual I/O noise, right?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
