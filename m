Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3GQQg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:36:59 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:44513 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab3GQQg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:36:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130717160506.GI8731@rric.localhost>
References: <20130710133742.GA29368@emu.suse.cz>
	<CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
	<20130711135445.GA21500@sepie.suse.cz>
	<CA+55aFyVjugxM7cUDWi0ASWttYthCxa6e7X3CADknBcSFxWgew@mail.gmail.com>
	<20130712105721.GF8731@rric.localhost>
	<20130717160506.GI8731@rric.localhost>
Date: Wed, 17 Jul 2013 09:36:57 -0700
X-Google-Sender-Auth: 5PuEzVqsPN724q7wJHEvmEikRbI
Message-ID: <CA+55aFx4G5gME3ByqE0Wr-_t2x_6WkP3Ta4k1z4jfW+PrcK0og@mail.gmail.com>
Subject: Re: [PATCH] arm, kbuild: make "make install" not depend on vmlinux
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Richter <rric@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 9:05 AM, Robert Richter <rric@kernel.org> wrote:
>
> I narrowed this down. The problem is that zinstall on ARCH=arm has a
> dependency to vmlinux which does a prepare/prepare3 and finally does a
> forced rebuild of kernel.release even if it exists already.
>
> Rebuilding it removes kernel.release first and then recreates it. This
> might race with another parallel make job running depmod.
>
> So on arm and maybe other archs we need the same as for x86:
>
>  1648e4f8 x86, kbuild: make "make install" not depend on vmlinux
>
> The patch below fixes this for arm. It is build-tested in my
> environment, but please test it in others too if possible.

Ack. This looks like the right thing to do.

That said, I think for clarity you might perhaps want to make the
unrelated change of adding double quotes around $(KERNELRELEASE) a
separate patch. Not a big deal, but it took me a moment to say "why
did he do that" (in fact, I'm not sure KERNEL_RELEASE can actually
validly have spaces in it, but quoting it is certainly not wrong
either - but it might be unnecessary.

              Linus
