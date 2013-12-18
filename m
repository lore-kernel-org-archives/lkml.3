Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3LRIsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 03:48:24 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38799 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3LRIsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 03:48:22 -0500
MIME-Version: 1.0
In-Reply-To: <s5hfvpqk0p8.wl%tiwai@suse.de>
References: <s5hlhzik3kk.wl%tiwai@suse.de>
	<CANq1E4TFKDduy71jCXy+8CMS1_OFxWEpsHY3AA0RUJPW4VE8hg@mail.gmail.com>
	<s5hfvpqk0p8.wl%tiwai@suse.de>
Date: Wed, 18 Dec 2013 09:48:21 +0100
X-Google-Sender-Auth: fpwnZuSdX17Zm31iBm-RVxRX3ec
Message-ID: <CAMuHMdXk6EVdKGH5qq2qeT4b_ZvVxoqsYhBUv+cL2uAeFbpzRw@mail.gmail.com>
Subject: Re: cirrusdrmfb broken with simplefb
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 9:44 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> That bug always existed, simplefb is just the first driver to hit it
>> (vesafb/efifb didn't use resources).
>
> Heh, the bug didn't "exist" because no other grabbed the resource
> before.  The way the cirrus driver allocates the resource is no bug,
> per se.  But the proper resource takeover is missing.
>
>> I'm aware of the issue but as a
>> workaround you can simply disable CONFIG_X86_SYSFB. That restores the
>> old behavior.
>
> Yes, but CONFIG_X86_SYSFB breaks things as of now.  Shouldn't it be
> mentioned or give some kconfig hints instead of silently giving a
> broken output, if any quick fix isn't possible?

Indeed. That's called a "regression" in distro/allmodconfig kernels.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
