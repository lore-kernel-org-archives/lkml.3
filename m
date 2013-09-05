Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763419Ab3IEHsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:48:20 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58238 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692Ab3IEHsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:48:18 -0400
MIME-Version: 1.0
In-Reply-To: <5228294E.8050401@ti.com>
References: <5228294E.8050401@ti.com>
Date: Thu, 5 Sep 2013 09:48:18 +0200
Message-ID: <CANq1E4Rd2eEaNnX8b3WAQcQX-T4+fR-4OMAtoSaAp9XwdGLpSg@mail.gmail.com>
Subject: Re: [GIT PULL] fbdev changes for 3.12
From: David Herrmann <dh.herrmann@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi

On Thu, Sep 5, 2013 at 8:48 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> Hi Linus,
>
> Here are the fbdev changes for 3.12.
>
> There's a conflict in drivers/video/simplefb.c, which you can resolve by using
> the version in your tree.

No, both need to be merged. The current version lacks support for
ABGR8888. The fbdev tree lacks the DRM format, which should be:
  { "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {24, 8}, DRM_FORMAT_ABGR8888 }

> I guess the simplefb changes were taken through Ingo's tree because the series
> includes x86 arch changes, but it would have been nice to see the patches in
> the linux-next...

simplefb was in linux-next. I also acked the fixup from Stephen. See
this commit from a pre-3.12 -next tree:
  http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/include/linux/platform_data/simplefb.h?id=44ed8fb588e517a2ef917c6757ee11ee47348978

It was merged through -tip around 1 month ago. It does mainly change
the way x86 provides firmware-fb information to drivers so -tip seemed
fine to me.

On another note, could you have a look at:
  [PATCH] efifb: prevent null dereferences by removing unused array
indices from dmi_list
That somehow didn't make it in your fbdev-next pull.

Thanks
David
