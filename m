Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3HBMGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:06:24 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:41649 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3HBMGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:06:22 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH RESEND 0/8] x86 platform framebuffers
Date: Fri,  2 Aug 2013 14:05:19 +0200
Message-Id: <1375445127-15480-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I cut down my previous series to no longer include the SimpleDRM driver. If
anyone is interested, you can find it here:
  http://lwn.net/Articles/558104/
I will resend it once these preparation patches are in.

Changes since v2:
 - added common x86 formats (reported by hpa) (patch #5)

This whole series (including simpledrm) is tested by Stephen and me. I would be
glad if maintainers could ack/nack this so I can continue my work.

This series is pretty small and just converts x86 to use platform-devices
instead of global objects to pass framebuffer data to drivers. The commit
messages explain everything in detail.
The idea is to create a "platform-framebuffer" device which drivers can bind to.
If x86 boot code detectes efi or vesa framebuffers, it creates efi-framebuffer
or vesa-framebuffer devices instead.

Additionally, if the modes are compatible, "simple-framebuffer" devices are
created so simplefb can be used on x86. This feature is only enabled if
CONFIG_X86_SYSFB is selected (off by default) so users without simplefb still
get boot logs.

 @Stephen: I wasn't sure whether you tested the efi/vesa framebuffer changes,
too, so I didn't add your tested-by there. And I changed patch #5 so I dropped
it there, too. Thanks for testing!

Thanks
David

David Herrmann (8):
  fbdev: simplefb: add init through platform_data
  fbdev: simplefb: mark as fw and allocate apertures
  x86: provide platform-devices for boot-framebuffers
  x86: sysfb: move EFI quirks from efifb to sysfb
  fbdev: simplefb: add common x86 RGB formats
  fbdev: vesafb: bind to platform-framebuffer device
  fbdev: efifb: bind to efi-framebuffer
  fbdev: fbcon: select VT_HW_CONSOLE_BINDING

 arch/x86/Kconfig                       |  26 +++
 arch/x86/include/asm/sysfb.h           |  98 +++++++++++
 arch/x86/kernel/Makefile               |   3 +
 arch/x86/kernel/sysfb.c                |  74 ++++++++
 arch/x86/kernel/sysfb_efi.c            | 214 +++++++++++++++++++++++
 arch/x86/kernel/sysfb_simplefb.c       |  95 +++++++++++
 drivers/video/Kconfig                  |   5 +-
 drivers/video/console/Kconfig          |   3 +-
 drivers/video/efifb.c                  | 302 ++++-----------------------------
 drivers/video/simplefb.c               |  58 +++++--
 drivers/video/vesafb.c                 |  55 ++----
 include/linux/platform_data/simplefb.h |  63 +++++++
 12 files changed, 666 insertions(+), 330 deletions(-)
 create mode 100644 arch/x86/include/asm/sysfb.h
 create mode 100644 arch/x86/kernel/sysfb.c
 create mode 100644 arch/x86/kernel/sysfb_efi.c
 create mode 100644 arch/x86/kernel/sysfb_simplefb.c
 create mode 100644 include/linux/platform_data/simplefb.h

-- 
1.8.3.4

