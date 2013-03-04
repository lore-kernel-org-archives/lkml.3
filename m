Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3CDCzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:55:04 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:49154 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab3CDCzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:55:02 -0500
MIME-Version: 1.0
In-Reply-To: <513407AC.8060009@infradead.org>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
	<alpine.LRH.2.00.1303040213590.11934@twin.jikos.cz>
	<CA+55aFxA1pH_aKJc85DXuS2-Q=7b4pP-h_ms6XQiSzQcpWaO6Q@mail.gmail.com>
	<513407AC.8060009@infradead.org>
Date: Sun, 3 Mar 2013 18:55:01 -0800
X-Google-Sender-Auth: KZfIl30tHdWuzWtWIFl6YbzOpng
Message-ID: <CA+55aFx7s_-Cv6Qa89CSyyMEESyGO_vbR1N42pOxRgkuCWf8mg@mail.gmail.com>
Subject: Re: Linux 3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 3, 2013 at 6:32 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>
> I suppose that this omits individual contributor patches by design?
> I had 3 patches merged, but they are hidden by this method.

Absolutely.

We had over ten thousand commits in between 3.8 and 3.9-rc1 (10942 if
you count merges, 10265 if you don't). So the whole shortlog format
(that gives authorship for individual commits) is simply not very
useful. It's over half a megabyte of data.

You show up in the shortlog:

  Randy Dunlap (5):
        lguest: select CONFIG_TTY to build properly.
        i2c: fix i2c-ismt.c printk format warning
        [SCSI] scsi: fix lpfc build when wmb() is defined as mb()
        watchdog: da9055_wdt needs to select WATCHDOG_CORE
        hsi: fix kernel-doc warnings

but it's *so* much data that it's not worth posting in lkml. Nobody
would read it, and more importantly, it's so much that there's no feel
for any kind of overview.

The *mergelog* I post is literally just a list of merges I do, and the
names that get credited are neither the authors nor the committers,
but literally just the people who send me the pull request. Now,
*often* that has high correlation with committers, but not always. For
example, David Miller is who asks me to pull the networking tree, but
in reality, that hides not just all the authors, but also all the
submaintainers who he in turn pulls from. Similarly, most of the x86
tree pull requests come from Ingo, even though there are other people
involved as maintainers.

So the mergelog really only gives you an idea of which *subsystems*
got merged, and generally the top-level maintainer for that subsystem.
And even then, the "top-level maintainer" can be just "one of several
top-level maintainers", so even that particular data point is not
really completely unambiguous.

                   Linus
