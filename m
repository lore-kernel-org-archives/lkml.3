Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3KORqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:46:49 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52263 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3KORql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:46:41 -0500
MIME-Version: 1.0
In-Reply-To: <20131115114306.5d14db66@gandalf.local.home>
References: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
	<20131115045318.27580.69554.stgit@kbuild-fedora.novalocal>
	<20131115114306.5d14db66@gandalf.local.home>
Date: Fri, 15 Nov 2013 18:46:40 +0100
X-Google-Sender-Auth: 4tdvay70Iyxh-FYwCD1r6Ti41i0
Message-ID: <CAMuHMdXw+WGKiQuquQL7XOkbRLNOC_SPddY1irRGQwpvDHLMwA@mail.gmail.com>
Subject: Re: [PATCH -tip RFC v2 01/22] kprobes: Prohibit probing on
 .entry.text code
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 5:43 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 15 Nov 2013 04:53:18 +0000
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>
>> .entry.text is a code area which is used for interrupt/syscall
>> entries, and there are many sensitive codes.
>> Thus, it is better to prohibit probing on all of such codes
>> instead of a part of that.
>> Since some symbols are already registered on kprobe blacklist,
>> this also removes them from the blacklist.
>
> This change only works with x86. On other archs, I get this:
>
> kernel/built-in.o: In function `register_kprobe':
> (.kprobes.text+0x9f4): undefined reference to `__entry_text_start'
> kernel/built-in.o: In function `register_kprobe':
> (.kprobes.text+0x9f8): undefined reference to `__entry_text_end'
> make[1]: *** [vmlinux] Error 1
> make: *** [sub-make] Error 2

X86 is the sole architecture that has ENTRY_TEXT in its
arch/*/kernel/vmlinux.lds.S.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
