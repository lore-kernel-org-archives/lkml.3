Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbaEaNTv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 09:19:51 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:45195 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbaEaNTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 09:19:49 -0400
MIME-Version: 1.0
In-Reply-To: <m2tx86l4ux.fsf@linux-m68k.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<1401480116-1973111-2-git-send-email-arnd@arndb.de>
	<CAMuHMdVgch4REGcYWFZXVToX2b8iCinFVV10Bz3VoeiZy_yBtg@mail.gmail.com>
	<m2tx86l4ux.fsf@linux-m68k.org>
Date: Sat, 31 May 2014 15:19:48 +0200
X-Google-Sender-Auth: 7ck-OTQ1iXJYNFAP2-5tI1gj8w8
Message-ID: <CAMuHMdXPQQpu_6k+Y6o=1u-u9EkkanKdGYp6-=BavyYHUH3AuA@mail.gmail.com>
Subject: Re: [RFC 01/32] fs: introduce new 'struct inode_time'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
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

Hi Andreas,

On Sat, May 31, 2014 at 10:39 AM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>> Hi Arnd,
>>
>> On Fri, May 30, 2014 at 10:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> + * The variant using bit fields is less efficient to access, but
>>> + * small and has a wider range as the 32-bit one, plus it keeps
>>> + * the signedness of the original timespec.
>>> + */
>>> +struct inode_time {
>>> +       long long       tv_sec  : 34;
>>> +       int             tv_nsec : 30;
>>> +};
>>
>> Don't you need 31 bits for tv_nsec, to accommodate for the sign bit?
>> I know you won't really store negative numbers there, but storing a large
>> positive number will become negative on read out, won't it?
>
> Only if the int bitfield is signed.  Bitfields are weird, aren't they? :-)

"int" is signed, right? Or do you mean a bitfield needs an explicit "signed"
keyword to be signed?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
