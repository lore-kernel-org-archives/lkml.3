Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab3CaNxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 09:53:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267Ab3CaNxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 09:53:00 -0400
Date: Sun, 31 Mar 2013 10:52:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.9-rc4] media fixes
Message-ID: <20130331105252.3e7e9367@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a some fixes for Kernel 3.9:
	- A subsystem build fix when VIDEO_DEV=y, VIDEO_V4L2=m and I2C=m.
	- A compilation fix for arm multiarch preventing IR_RX51 to be
	  selected;
	- a regression fix at bttv crop logic;
	- s5p-mfc/m5mols/exynos: a few fixes for cameras on exynos hardware.

Thanks!
Mauro

-

The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 35ccecef6ed48a5602755ddf580c45a026a1dc05:

  [media] [REGRESSION] bt8xx: Fix too large height in cropcap (2013-03-26 08:37:00 -0300)

----------------------------------------------------------------
Andrzej Hajda (1):
      [media] m5mols: Fix bug in stream on handler

Arnd Bergmann (1):
      [media] ir: IR_RX51 only works on OMAP2

Arun Kumar K (2):
      [media] s5p-mfc: Fix frame skip bug
      [media] s5p-mfc: Fix encoder control 15 issue

Hans de Goede (1):
      [media] [REGRESSION] bt8xx: Fix too large height in cropcap

Mauro Carvalho Chehab (2):
      Merge tag 'v3.9-rc3' into v4l_for_linus
      [media] fix compilation with both V4L2 and I2C as 'm'

Shaik Ameer Basha (4):
      [media] fimc-lite: Initialize 'step' field in fimc_lite_ctrl structure
      [media] fimc-lite: Fix the variable type to avoid possible crash
      [media] exynos-gsc: send valid m2m ctx to gsc_m2m_job_finish
      [media] s5p-fimc: send valid m2m ctx to fimc_m2m_job_finish

Sylwester Nawrocki (1):
      [media] s5p-fimc: Do not attempt to disable not enabled media pipeline

 drivers/media/i2c/m5mols/m5mols_core.c          |  2 +-
 drivers/media/pci/bt8xx/bttv-driver.c           | 20 +++++++++----
 drivers/media/platform/exynos-gsc/gsc-core.c    |  8 +++--
 drivers/media/platform/s5p-fimc/fimc-core.c     |  6 ++--
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c |  8 ++---
 drivers/media/platform/s5p-fimc/fimc-lite.c     |  1 +
 drivers/media/platform/s5p-fimc/fimc-mdevice.c  | 39 ++++++++++++-------------
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  1 +
 drivers/media/rc/Kconfig                        |  2 +-
 drivers/media/v4l2-core/Makefile                |  2 +-
 11 files changed, 53 insertions(+), 38 deletions(-)

