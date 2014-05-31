Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbaEaH4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 03:56:32 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:43917 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaEaH4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 03:56:30 -0400
MIME-Version: 1.0
In-Reply-To: <1401480116-1973111-2-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<1401480116-1973111-2-git-send-email-arnd@arndb.de>
Date: Sat, 31 May 2014 09:56:29 +0200
X-Google-Sender-Auth: VzjDMnvWK7DlZCe8yO4D_inpWtg
Message-ID: <CAMuHMdVgch4REGcYWFZXVToX2b8iCinFVV10Bz3VoeiZy_yBtg@mail.gmail.com>
Subject: Re: [RFC 01/32] fs: introduce new 'struct inode_time'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, May 30, 2014 at 10:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> + * The variant using bit fields is less efficient to access, but
> + * small and has a wider range as the 32-bit one, plus it keeps
> + * the signedness of the original timespec.
> + */
> +struct inode_time {
> +       long long       tv_sec  : 34;
> +       int             tv_nsec : 30;
> +};

Don't you need 31 bits for tv_nsec, to accommodate for the sign bit?
I know you won't really store negative numbers there, but storing a large
positive number will become negative on read out, won't it?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
