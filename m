Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbaEaQPd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 12:15:33 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39079 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbaEaQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 12:15:31 -0400
MIME-Version: 1.0
In-Reply-To: <5507335.AOOTyGEum3@wuerfel>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<CAMuHMdVgch4REGcYWFZXVToX2b8iCinFVV10Bz3VoeiZy_yBtg@mail.gmail.com>
	<m2tx86l4ux.fsf@linux-m68k.org>
	<5507335.AOOTyGEum3@wuerfel>
Date: Sat, 31 May 2014 18:15:30 +0200
X-Google-Sender-Auth: oqNKIEU8z-wttahMSI4C4egPkB0
Message-ID: <CAMuHMdVQJfaghsVqJJnsFahu6FGhXm2-DtOQbJTEDd7f=TO_NQ@mail.gmail.com>
Subject: Re: [RFC 01/32] fs: introduce new 'struct inode_time'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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

On Sat, May 31, 2014 at 4:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 31 May 2014 10:39:02 Andreas Schwab wrote:
>> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>>
>> > Hi Arnd,
>> >
>> > On Fri, May 30, 2014 at 10:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >> + * The variant using bit fields is less efficient to access, but
>> >> + * small and has a wider range as the 32-bit one, plus it keeps
>> >> + * the signedness of the original timespec.
>> >> + */
>> >> +struct inode_time {
>> >> +       long long       tv_sec  : 34;
>> >> +       int             tv_nsec : 30;
>> >> +};
>> >
>> > Don't you need 31 bits for tv_nsec, to accommodate for the sign bit?
>> > I know you won't really store negative numbers there, but storing a large
>> > positive number will become negative on read out, won't it?
>>
>> Only if the int bitfield is signed.  Bitfields are weird, aren't they?

According to 6.7.2#5 (thanks for the reference), this is implementation defined.

> It was a mistake on my side, as I didn't know about that rule and
> meant write 'unsigned int' really. Also, I always have a bad feeling

IC, but the comment said "plus it keeps the signedness".
So it doesn't keep the signedness for the tv_nsec field.

> about using bitfields in general.

Hehe...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
