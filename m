Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3FFWrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 18:47:48 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:61559 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3FFWrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 18:47:46 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.BSM.4.64L.1306050936200.18048@herc.mirbsd.org>
References: <51A71E49.1000707@asianux.com>
	<CAMuHMdUz8o4d=RiAMW8-pCrnZyfoH9EETVqjcb7E1GqCgYmQ7g@mail.gmail.com>
	<51A93FA0.1050203@biophys.uni-duesseldorf.de>
	<51A94281.7050708@biophys.uni-duesseldorf.de>
	<51AC6472.3060606@asianux.com>
	<CAMuHMdVLA_zgeGxTTzfXnBYZiihH3w+LLcW0cRzVk_dvkFojgg@mail.gmail.com>
	<51AE87DF.5000301@asianux.com>
	<51AEE7C0.9060206@biophys.uni-duesseldorf.de>
	<Pine.BSM.4.64L.1306050936200.18048@herc.mirbsd.org>
Date: Fri, 7 Jun 2013 10:47:45 +1200
Message-ID: <CAOmrzkKROD5gkLdme7C2wF4NVMCB=i4_Tr+MVWt0DoVh9E5biw@mail.gmail.com>
Subject: Re: [PATCH] arch: m68k: include: asm: the 3rd parameter of 'insl' and
 'outsl' need '<< 2'
From: Michael Schmitz <schmitzmic@gmail.com>
To: Thorsten Glaser <tg@mirbsd.de>
Cc: Chen Gang <gang.chen@asianux.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>, schmitz@debian.org,
        Sam Ravnborg <sam@ravnborg.org>, Greg KH <gregkh@linuxfoundation.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thorsten,

>> No need for the #ifdef CONFIG_Q40 - Q40 is the only m68k subarch that builds
>> the parport_pc module (which includes parport.h), IIRC. Is that correct,
>> Thorsten?
>
> The header is included outside of Q40. There is no Q40 kernel
> in Debian (yet). So, no.

OK, so it's the Amiga use of parport_pc that you had issues with. I
really should stop
relying on my increasingly fuzzy memory.

Looking at the arch defconfigs, neither Amiga or Atari defines
CONFIG_PARPORT_PC.
Is this driver used on any m68k subarch at all? At this stage I'm not
even certain it is
in fact used on Q40.

Anyway, back to the patch at hand: any change to parport_pc.h should
not affect m68k at all,
so you're free to patch this any way you please.

Changes to m68k asm/io.h should be avoided unless shown to cause no
harm to existing drivers.
I can't see direct use of insl/outsl in Atari m68k drivers I checked,
but due to the slightly tangled
nature of m68k io.h, these may get pulled in through macros yet. I'd
prefer the code stays as-is.

Regards,

   Michael


2013/6/6 Thorsten Glaser <tg@mirbsd.de>:
> schmitz dixit:
>
>> No need for the #ifdef CONFIG_Q40 - Q40 is the only m68k subarch that builds
>> the parport_pc module (which includes parport.h), IIRC. Is that correct,
>> Thorsten?
>
> The header is included outside of Q40. There is no Q40 kernel
> in Debian (yet). So, no.
>
> bye,
> //mirabilos
> --
> 17:08⎜«Vutral» früher gabs keine packenden smartphones und so
> 17:08⎜«Vutral» heute gibts frauen die sind facebooksüchtig
> 17:10⎜«Vutral» aber auch traurig; früher warst du als nerd voll am arsch
> 17:10⎜«Vutral» heute bist du als nerd der einzige der wirklich damit klarkommt
