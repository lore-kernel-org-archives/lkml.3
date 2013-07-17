Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab3GQQ5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:57:51 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:34892 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab3GQQ5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:57:48 -0400
Date: Wed, 17 Jul 2013 18:57:43 +0200
From: Robert Richter <rric@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm, kbuild: make "make install" not depend on vmlinux
Message-ID: <20130717165743.GK8731@rric.localhost>
References: <20130710133742.GA29368@emu.suse.cz>
 <CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
 <20130711135445.GA21500@sepie.suse.cz>
 <CA+55aFyVjugxM7cUDWi0ASWttYthCxa6e7X3CADknBcSFxWgew@mail.gmail.com>
 <20130712105721.GF8731@rric.localhost>
 <20130717160506.GI8731@rric.localhost>
 <CA+55aFx4G5gME3ByqE0Wr-_t2x_6WkP3Ta4k1z4jfW+PrcK0og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx4G5gME3ByqE0Wr-_t2x_6WkP3Ta4k1z4jfW+PrcK0og@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.07.13 09:36:57, Linus Torvalds wrote:
> On Wed, Jul 17, 2013 at 9:05 AM, Robert Richter <rric@kernel.org> wrote:
> >
> > I narrowed this down. The problem is that zinstall on ARCH=arm has a
> > dependency to vmlinux which does a prepare/prepare3 and finally does a
> > forced rebuild of kernel.release even if it exists already.
> >
> > Rebuilding it removes kernel.release first and then recreates it. This
> > might race with another parallel make job running depmod.
> >
> > So on arm and maybe other archs we need the same as for x86:
> >
> >  1648e4f8 x86, kbuild: make "make install" not depend on vmlinux
> >
> > The patch below fixes this for arm. It is build-tested in my
> > environment, but please test it in others too if possible.
> 
> Ack. This looks like the right thing to do.

Thanks for looking at this.

> That said, I think for clarity you might perhaps want to make the
> unrelated change of adding double quotes around $(KERNELRELEASE) a
> separate patch. Not a big deal, but it took me a moment to say "why
> did he do that" (in fact, I'm not sure KERNEL_RELEASE can actually
> validly have spaces in it, but quoting it is certainly not wrong
> either - but it might be unnecessary.

If kernel.release doen't exist KERNEL_RELEASE is empty, thus all args
for install.sh shift one arg left. Putting it in quotes avoids this.
Noticed this since the first verified file in install.sh ($2) should
be the image file but was already System.map ($3).

Will splitt the patches and resend.

-Robert
