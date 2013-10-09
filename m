Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab3JIKrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:47:01 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34292 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab3JIKq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:46:59 -0400
MIME-Version: 1.0
In-Reply-To: <52552FBA.7040806@suse.cz>
References: <CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
	<20130711135445.GA21500@sepie.suse.cz>
	<CA+55aFyVjugxM7cUDWi0ASWttYthCxa6e7X3CADknBcSFxWgew@mail.gmail.com>
	<20130712105721.GF8731@rric.localhost>
	<20130717160506.GI8731@rric.localhost>
	<CA+55aFx4G5gME3ByqE0Wr-_t2x_6WkP3Ta4k1z4jfW+PrcK0og@mail.gmail.com>
	<20130717165743.GK8731@rric.localhost>
	<CA+55aFzhmV7iq+Pv37trMCmdNzk53ORAoj0a6rV14fzKta3Dhw@mail.gmail.com>
	<51E7B3D0.4060609@suse.cz>
	<20130930084945.GA1963@rric.localhost>
	<20130930163139.GA12450@free.fr>
	<CAMuHMdW-YWGgZjR9ow6FMW7BrOorbbVAEm9sYsVvPkfg-_=jag@mail.gmail.com>
	<52552FBA.7040806@suse.cz>
Date: Wed, 9 Oct 2013 12:46:59 +0200
X-Google-Sender-Auth: DdvbmzMy6u28d8SK_HmuUstME-M
Message-ID: <CAMuHMdXwdYACK_yvH3=OrO+MWkvOXQCzZ6f35hNq-k-7gieFLQ@mail.gmail.com>
Subject: Re: [PATCH] arm, kbuild: make "make install" not depend on vmlinux
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>
Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Robert Richter <rric@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 12:28 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 9.10.2013 09:18, Geert Uytterhoeven wrote:
>> Sorry for chiming in that late, but I didn't think of this when reading the
>> original submission.
>>
>> Just doing "make oldconfig; make install" used to work.
>
> On ARM and maybe other architectures.

Until 2009 it also worked on x86 ;-)

>> Removing the dependency of "make vmlinux" on vmlinux breaks this, doesn't it?
>
>> Not that I'm strongly attached to it, but there may be other users...
>
> We can't eat the cake and have it :). What can be done is to make

Sure.

> arch/arm/boot/install.sh print a friendlier error message, like the x86
> version does:
>
> if [ ! -f "$1" ]; then
>         echo ""                                                   1>&2
>         echo " *** Missing file: $1"                              1>&2
>         echo ' *** You need to run "make" before "make install".' 1>&2
>         echo ""                                                   1>&2
>         exit 1
> fi

Definitely!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
