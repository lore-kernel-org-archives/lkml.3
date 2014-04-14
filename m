Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaDNNG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:06:56 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:63972 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaDNNGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:06:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140414145359.48b7337c@endymion.delvare>
References: <20140414145359.48b7337c@endymion.delvare>
Date: Mon, 14 Apr 2014 09:06:50 -0400
X-Google-Sender-Auth: lEZJYrDU9-ZY_poc69osouJlfSI
Message-ID: <CA+5PVA6aH8ZLQey3QJU9vG6kCrnguZcJ7dSDtntiOLbivt8nAw@mail.gmail.com>
Subject: Re: Hardware dependencies in Kconfig
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 8:53 AM, Jean Delvare <jdelvare@suse.de> wrote:
> Hi all,
>
> Configuring kernels from scratch has become an incredibly long and
> tedious task. The reason is that the number of drivers and options has
> exploded in the past few years. Which in itself is great - Linux is
> successful, yeah! - but the side effects must be dealt with.
> 6000-line .config files are no fun.
>
> Earlier today, I found that NET_CADENCE is set in my x86-64 kernel
> configuration. The two ethernet drivers below this menu are for ARM
> machines. I really shouldn't be asked about that on x86-64. I just sent
> a patch addressing this specific issue, which follows about 50 similar
> patches from me for similar issues in various subsystems. But I can't
> do all of that by myself, this is too much work quantitatively, and I
> am not always the best person to find out the proper hardware
> dependencies that should be added.

I have much the same problem when I'm doing the config changes for
Fedora kernel rebases.  I've gotten to the point where I can somewhat
guess based on the driver name which arch it's for (lately the
majority are for ARM), but that isn't really a great way to handle
things.  Only being asked about options for the arch being configured
is much better than playing guessing games.

> I would like to call for proper hardware dependencies to become a
> general trend: every new hardware-specific driver which is added to the
> kernel should depend on ($hardware || COMPILE_TEST), so as to make it
> clear right away, which type of hardware is expected to need the driver
> in question.
>
> $hardware can be the top-level architecture (e.g. ARM), but can also go
> down to sub-architecture/platform (e.g. ARCH_AT91 or PLATFORM_AT32AP) or
> even machine (e.g. PICOXCELL_PC3X3). The list can always be extended
> later if needed. Ideally we should restrict as much as possible as long
> as the result is easy to maintain, not too complex, and not likely to
> break in a near future.
>
> Thanks to COMPILE_TEST, we don't lose the build test coverage, and it
> also makes it possible for anyone to still build the driver if the
> dependency is too strict (as a temporary workaround until it gets fixed
> upstream, that is.)
>
> Does anyone object to this?

I think this is a great idea.  Thanks for bringing up the suggestion.

josh
