Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaJFSSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:18:11 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:65025 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaJFSSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:18:10 -0400
X-CheckPoint: {5432DCE1-A-2100090A-C0000000}
Message-ID: <5432DCE1.10607@tilera.com>
Date: Mon, 6 Oct 2014 14:18:09 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile changes for 3.18
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.18 from:

   git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

The only substantive pieces in this batch are some more vDSO support,
and removing the reference to &platform_bus in tile-srom.c.  The rest
are minor issues reported to me.

Thanks!

Chris Metcalf (4):
       tilegx: Enable ARCH_SUPPORTS_ATOMIC_RMW
       tile gxio: use better string copy primitive
       tile: switch to using seqlocks for the vDSO time code
       tile: add clock_gettime support to vDSO

Geert Uytterhoeven (1):
       tile: Remove tile-specific _sinitdata and _einitdata

Himangi Saraogi (1):
       tile: use ARRAY_SIZE

Kurt McAlpine (1):
       Removed repeated word in comments

Pawel Moll (1):
       char: tile-srom: Add real platform bus parent

  arch/tile/Kconfig                     |   1 +
  arch/tile/gxio/mpipe.c                |  37 ++++++-
  arch/tile/include/asm/sections.h      |   3 -
  arch/tile/include/asm/vdso.h          |  20 ++--
  arch/tile/include/uapi/arch/sim_def.h |  10 +-
  arch/tile/kernel/time.c               |  61 ++++++++----
  arch/tile/kernel/traps.c              |   2 +-
  arch/tile/kernel/vdso/vdso.lds.S      |   2 +
  arch/tile/kernel/vdso/vgettimeofday.c | 176 +++++++++++++++++++++++++---------
  arch/tile/kernel/vmlinux.lds.S        |   2 -
  arch/tile/mm/init.c                   |  12 +--
  drivers/char/tile-srom.c              |  13 ++-
  12 files changed, 245 insertions(+), 94 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

