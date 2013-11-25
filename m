Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3KYIzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:55:43 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:50349 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3KYIzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:55:41 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0024] asm-generic: Rename int-ll64.h to types.h
Date: Mon, 25 Nov 2013 09:55:10 +0100
Message-Id: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset aims to rename <asm-generic/int-ll64.h> to
<asm-generic/types.h> in kernelspace, as suggested by Arnd.

While userspace still has both include/uapi/asm-generic/int-l64.h and
include/uapi/asm-generic/int-ll64.h (int-l64.h may still be used on legacy
64-bit systems), kernelspace always uses "(unsigned) long long" for 64-bit
integer values ("u64" and "s64").  Hence there's no longer a need to
distinguish between int-l64 and int-ll64 in kernelspace, and int-ll64.h can
just be called types.h

  - Patch 01 adds a missing _UAPI prefix to <uapi/asm-generic/types.h>
    include guard, to avoid conflicts with the future
    <asm-generic/types.h>,
  - Patches 02-11 switch to using Kbuild logic to provide UAPI
    <asm/types.h> on architectures where possible and not yet done,
  - Patches 12-13 remove unneeded inclusions of <uapi/asm/types.h>,
  - Patches 14-18 switch to using Kbuild logic to provide (kernelspace)
    <asm/types.h> on architectures where possible and not yet done,
    All of these differed from the generic version only by a superfluous
    definition of BITS_PER_LONG.
  - Patch 19 Changes an include to harmonize with other architectures,
  - Patch 20 removes a superfluous definition of BITS_PER_LONG,
  - Patches 21-23 separate the inclusion of <asm-generic/int-ll64.h> in
    kernel- and userspace, as the kernelspace version will be renamed,
  - Patch 24 does the actual rename from <asm-generic/int-ll64.h> to
    <asm-generic/types.h>.
    Note: While arch/alpha/include/asm/types.h just includes
    asm-generic/types.h after this patch, don't be tempted to use Kbuild
    logic to provide it!
    arch/*/include/asm/Kbuild seems to apply to both arch/*/include/asm and
    arch/*/include/uapi/asm, while alpha has its own <uapi/asm/types.h>.
    If you think this is a bug, please discuss this in reply to the last
    patch.

Most patches are trivial, and can be applied in any order. The last one is
the only real sync point.

This has been compile-tested on all architectures that keep their own
<uapi/asm/types.h>, and on a few others.
The result of "make headers_install" for all architectures has been
compared manually before and after.

Thanks for your comments!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

