Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbaHOEgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 00:36:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37459 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbaHOEga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 00:36:30 -0400
Date: Fri, 15 Aug 2014 05:36:27 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes (mostly nouveau)
Message-ID: <alpine.DEB.2.00.1408150535000.21689@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

one doc buidling fixes for a file that moved, along with a bunch of 
nouveau fixes, one a build problem on ARM.

Dave.

The following changes since commit 899552d6e84babd24611fd36ac7051068cb1eb2d:

  Merge branch 'misc' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild (2014-08-14 11:14:29 -0600)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 251964845fbf539781dd2c6406cb2ba1bf9eddd0:

  drm/doc: Refer to proper source file (2014-08-15 09:50:41 +1000)

----------------------------------------------------------------
Alexandre Courbot (2):
      drm/nouveau/gk20a: add LTC device
      drm/nouveau/platform: fix compilation error

Ben Skeggs (9):
      drm/nouveau/nvif: fix a number of notify thinkos
      drm/nouveau: kill unused variable warning if !__OS_HAS_AGP
      drm/nouveau/bar: behave better if ioremap failed
      drm/nvc0-/fb/ram: fix use of non-existant ram if partitions aren't uniform
      drm/nouveau/ltc: fix tag base address getting truncated if above 4GiB
      drm/nouveau/nvif: return null pointers on failure, in addition to ret != 0
      drm/gf100-/gr: fix -ENOSPC detection when allocating zbc table entries
      drm/nouveau/nvif: fix dac load detect method definition
      drm/nouveau: warn if we fail to re-pin fb on resume

Dave Airlie (1):
      Merge branch 'linux-3.17' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

Fengguang Wu (1):
      drm/nouveau/kms: nouveau_fbcon_accel_fini can be static

Thierry Reding (1):
      drm/doc: Refer to proper source file

 Documentation/DocBook/drm.tmpl                     |  2 +-
 drivers/gpu/drm/nouveau/core/core/client.c         |  4 +--
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |  1 +
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |  6 +++++
 drivers/gpu/drm/nouveau/core/include/core/client.h |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c     | 14 ++++++++---
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c   |  4 +--
 drivers/gpu/drm/nouveau/core/subdev/ltc/gf100.c    |  2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c               |  3 +--
 drivers/gpu/drm/nouveau/nouveau_display.c          |  4 ++-
 drivers/gpu/drm/nouveau/nouveau_fbcon.c            |  4 +--
 drivers/gpu/drm/nouveau/nouveau_platform.c         |  3 ++-
 drivers/gpu/drm/nouveau/nvif/class.h               |  4 +--
 drivers/gpu/drm/nouveau/nvif/notify.c              | 29 +++++++++++++++-------
 drivers/gpu/drm/nouveau/nvif/object.c              |  4 ++-
 15 files changed, 58 insertions(+), 28 deletions(-)
