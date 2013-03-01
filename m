Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab3CAESg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 23:18:36 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:33856 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab3CAESf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 23:18:35 -0500
MIME-Version: 1.0
In-Reply-To: <1362092093-4839-1-git-send-email-olof@lixom.net>
References: <1362092093-4839-1-git-send-email-olof@lixom.net>
Date: Thu, 28 Feb 2013 20:18:34 -0800
X-Google-Sender-Auth: 3fYko1EXt_pRUTdaaRj7MhsjLvY
Message-ID: <CA+55aFx2Cuuq2YW6mexxZ88TNm=FLYUYPzeLqN=y46oYxZJ3wQ@mail.gmail.com>
Subject: Re: [GIT PULL 0/3] arm-soc: late changes for 3.9
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Olof Johansson <olof@lixom.net>, Chris Ball <cjb@laptop.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ARM SoC <arm@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 2:54 PM, Olof Johansson <olof@lixom.net> wrote:
>
> Final two pull requests are for the same code. As Arnd describes in the
> tags, they are for a set of mvebu patches that depend on contents in
> the MMC tree. We had pulled in part of the MMC branch as a dependency,
> but unfortunately Chris Ball rebased it.

Has Chris Ball been told what an incredible pain this kind of crap is,
and that there's a damn good reason why WE DO NOT REBASE PUBLIC TREES
THAT OTHERS MAY BE BASING THEIR DEVELOPMENT ON!

Chris, can you hear me shouting? Don't do that.

> We're giving you the choice of taking the rebased version, or a
> non-rebased-but-merged-and-fixed-up version to avoid dealing with the
> excessive conflicts. The rebased one has the obvious benefit of not
> having duplicate commits in the tree for the same changes, but, well,
> it's rebased. Actual tree contents is identical though.

I'm taking the rebased one, thanks for the explanation. I really don't
like rebasing, but you did it for a valid reason, and it wasn't your
mistake. And duplicating the commits just to be a pain is not worth
it.

> I've pushed a resolved branch for reference (late-branches-resolved)
> in case you want to compare conflict resolutions.

So Arnd's tag talked about removing the stale gpio.h, but I think it
was the i2c.h that was now also stale. So I removed both - even though
technically, the merge should have left i2c.h since it was in both
parents. You should double-check that, but I don't see how that
<linux/i2c.h> could *possibly* be valid any more, and people had tried
(unsuccessfully) to remove it once already, so...

              Linus
