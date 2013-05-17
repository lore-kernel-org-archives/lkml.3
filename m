Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3EQBw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 21:52:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49931 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab3EQBw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 21:52:56 -0400
Date: Fri, 17 May 2013 02:52:54 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1305170250100.15866@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Fix for radeon nomodeset regression, old radeon interface cliprects fix, 2 
qxl crasher fixes, and a couple of minor cleanups.

I may have a new AMD hw support branch next week, its one of those doesn't 
affect anything existing just adds new support, I'll see how it 
shapes up and I might ask you to take it, just thought I'd warn in 
advance.

Dave.

The following changes since commit 9f1d036648c1c5ed81b0e98d7a06d55df972701e:

  drm/mgag200: Fix framebuffer base address programming (2013-05-13 12:17:32 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-next

for you to fetch changes up to e9ced8e040ebe40e9953db90acbe7d0b58702ebb:

  drm/radeon: restore nomodeset operation (v2) (2013-05-17 11:47:07 +1000)

----------------------------------------------------------------
Dave Airlie (6):
      drm: remove unused wrapper macros
      drm/qxl: fix ioport interactions for kernel submitted commands.
      qxl: drop unused variable.
      drm/qxl: drop active_user_framebuffer as its unneeded
      qxl: fix bug with object eviction and update area
      drm/radeon: restore nomodeset operation (v2)

Kees Cook (1):
      drm/radeon: check incoming cliprects pointer

 drivers/gpu/drm/qxl/qxl_cmd.c        | 29 +++++++++++++++++++----------
 drivers/gpu/drm/qxl/qxl_display.c    | 17 ++++-------------
 drivers/gpu/drm/qxl/qxl_drv.h        |  7 -------
 drivers/gpu/drm/qxl/qxl_ioctl.c      |  1 +
 drivers/gpu/drm/radeon/r300_cmdbuf.c |  2 +-
 drivers/gpu/drm/radeon/radeon_drv.c  | 12 +++++++++++-
 include/drm/drm_os_linux.h           |  9 ---------
 7 files changed, 36 insertions(+), 41 deletions(-)
