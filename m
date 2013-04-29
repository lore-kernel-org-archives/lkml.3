Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212Ab3D2UM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:12:57 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:57683 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064Ab3D2UMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:12:55 -0400
MIME-Version: 1.0
In-Reply-To: <201304292154.15920.arnd@arndb.de>
References: <20130429162115.GA6893@kroah.com>
	<CA+55aFwU-bXZ7wn2dOcLNfPMcjDv3Jvqx_LTt7B+-tj4WcP8Mg@mail.gmail.com>
	<CA+55aFzLtBwsvVrnT2DrUOU+eYrQ5eiKeamRb4Y5+-TVgbuM5Q@mail.gmail.com>
	<201304292154.15920.arnd@arndb.de>
Date: Mon, 29 Apr 2013 13:12:54 -0700
X-Google-Sender-Auth: bvuxXIwmyR9AeyY-s0HLMLg3YLo
Message-ID: <CA+55aFzefpRz2Y8oW9q0ArrR=XW0POBhy8NSNJ3DrCh9EowLqg@mail.gmail.com>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, David Brown <davidb@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 12:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> I think there are good reasons for most of the drivers we have moved out
> of arch/arm to stay out of there: we have added subdirectories for a lot
> of drivers that are alike:

Maybe. But this one is NOT such a case, and I saw Nico making excuses
for it on lkml.

There are other things wrong with that whole SSBI driver crap that you
seem to be ignoring:

 - it's not a bus, it's just a driver. Just because some people call
it "serial bus" doesn't make it magically about a "bus". I can call an
ethernet driver an "ethernet bus driver", and it may be technically
correct, but it is still bullshit. And ethernet is damn more a real
bus than that SSBI driver is. That's just a pure serial driver for a
very specific piece of embedded hardware. Stop calling it a bus.

 - The whole Kconfig thing is complete and utter garbage. There is no
excuse what-so-ever for ever asking the user about it. Not on x86, not
on ARM. The drivers that actually *use* that magical serial line
driver should just have selected it.

 - I'm not seeing what commonalities this thing can have with anything
else. Did anybody look at the code? There's nothing generic there.

So move it to a saner place, fix the kconfig idiocy, and don't make
noises as if it's some generic driver, much less some generic bus.
It's not.

                Linus
