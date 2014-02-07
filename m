Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaBGN5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:57:51 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:24019 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaBGN5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:57:49 -0500
X-AuditID: cbfec373-b7f4a6d000005e0a-a1-52f4e65c023e
Date: Fri, 07 Feb 2014 11:57:43 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.14-rc2] media fixes
Message-id: <20140207115743.477b8e91@samsung.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42I5/e9wiG7Msy9BBstXqVnMWb+GzeLyrjls
	Fj0btrJaPOp7y+7A4nFixm8Wj8+b5AKYorhsUlJzMstSi/TtErgyur6/YCq4q1ix+tcmtgbG
	V1JdjJwcEgImEvtnvGCDsMUkLtxbD2RzcQgJLGGUOHnyJzOE08MksXnRYqAMBweLgKrE0ZUl
	IA1sAkYSrxpbWEFsESD784srrCD1zAKLGSU+Pl/PDpIQFtCV+N37jQnE5hUwlHi3qBlqm5PE
	q9eToeKCEj8m32MBsZkFtCQ2b2tihbDlJTavecs8gZFvFpKyWUjKZiEpW8DIvIpRtLQ4uaA4
	KT3XSK84Mbe4NC9dLzk/dxMjJPSKdzC+2GB1iFGAg1GJh1dhxecgIdbEsuLK3EOMEhzMSiK8
	Nx5/CRLiTUmsrEotyo8vKs1JLT7EyMTBKdXAmLJRQiK63MBqhvTjslT+ou2ndpmX7kjeYNJn
	Kb/u7VmxhVX2zMsiEp8kyi+Wn/Uhc/sxB8sTVm4HF8jc1GQpPbNhj0vEjt7t1UYbb9/7brN2
	5ZZbG2I51mj4zWJZsOzdK3d72UoVr+orKlqbHvOkPX40IaA9+eq1Nem3vJQ3qD+e77Ovg0V6
	gxJLcUaioRZzUXEiAMzMvUsbAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media 

For a series of small fixes. Mostly driver ones. There is one core
regression fix on a patch that was meant to fix some race issues on
vb2, but that actually caused more harm than good. So, we're just
reverting it for now.

Thanks!
Mauro

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media 

for you to fetch changes up to 57f0547fbc1e925f5e58c76f311a6632c3f37740:

  [media] adv7842: Composite free-run platfrom-data fix (2014-02-04 06:46:10 -0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      [media] go7007-loader: fix usb_dev leak

Andi Shyti (2):
      [media] cx24117: remove dead code in always 'false' if statement
      [media] cx24117: use a valid dev pointer for dev_err printout

Andrzej Hajda (1):
      [media] s5k5baf: allow to handle arbitrary long i2c sequences

Antti Palosaari (1):
      [media] af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2

Dave Jones (2):
      [media] mxl111sf: Fix unintentional garbage stack read
      [media] mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset

Hans Verkuil (1):
      [media] Revert "[media] videobuf_vm_{open,close} race fixes"

Jacek Anaszewski (1):
      [media] s5p-jpeg: Fix wrong NV12 format parameters

Levente Kurusa (1):
      [media] media: bt8xx: add missing put_device call

Martin Bugge (2):
      [media] v4l2-dv-timings: fix GTF calculation
      [media] adv7842: Composite free-run platfrom-data fix

Masanari Iida (1):
      [media] hdpvr: Fix memory leak in debug

Mauro Carvalho Chehab (1):
      Merge tag 'v3.14-rc1' into patchwork

Michael Krufky (1):
      [media] update Michael Krufky's email address

Ricardo Ribalda (1):
      [media] vb2: Check if there are buffers before streamon

Sylwester Nawrocki (3):
      [media] exynos4-is: Fix error paths in probe() for !pm_runtime_enabled()
      [media] exynos4-is: Compile in fimc runtime PM callbacks conditionally
      [media] exynos4-is: Compile in fimc-lite runtime PM callbacks conditionally

 Documentation/dvb/contributors.txt            |  2 +-
 drivers/media/dvb-frontends/cx24117.c         | 10 +--------
 drivers/media/dvb-frontends/nxt200x.c         |  2 +-
 drivers/media/i2c/adv7842.c                   |  2 +-
 drivers/media/i2c/s5k5baf.c                   | 30 +++++++++++++++++----------
 drivers/media/pci/bt8xx/bttv-cards.c          |  2 +-
 drivers/media/pci/bt8xx/bttv-gpio.c           |  2 +-
 drivers/media/pci/saa7134/saa7134-cards.c     |  2 +-
 drivers/media/platform/exynos4-is/fimc-core.c |  5 ++++-
 drivers/media/platform/exynos4-is/fimc-lite.c |  7 +++++--
 drivers/media/platform/s5p-jpeg/jpeg-core.c   |  8 +++----
 drivers/media/usb/dvb-usb-v2/af9035.c         |  2 ++
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.c |  4 ++--
 drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.c  |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-gpio.h  |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c   |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.h   |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.c   |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-phy.h   |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-reg.h   |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c |  4 ++--
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h |  4 ++--
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |  6 +++---
 drivers/media/usb/dvb-usb-v2/mxl111sf.h       |  2 +-
 drivers/media/usb/hdpvr/hdpvr-core.c          |  4 +++-
 drivers/media/v4l2-core/v4l2-dv-timings.c     |  1 +
 drivers/media/v4l2-core/videobuf-dma-contig.c | 12 +++++------
 drivers/media/v4l2-core/videobuf-dma-sg.c     | 10 ++++-----
 drivers/media/v4l2-core/videobuf-vmalloc.c    | 10 ++++-----
 drivers/media/v4l2-core/videobuf2-core.c      |  5 +++++
 drivers/staging/media/go7007/go7007-loader.c  |  4 +++-
 32 files changed, 84 insertions(+), 72 deletions(-)



-- 

Cheers,
Mauro
