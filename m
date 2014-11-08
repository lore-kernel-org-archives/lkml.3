Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaKHMOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 07:14:06 -0500
Received: from lists.s-osg.org ([54.187.51.154]:44055 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbaKHMOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 07:14:04 -0500
Date: Sat, 8 Nov 2014 10:13:57 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.18-rc4] media fixes
Message-ID: <20141108101357.74a10248@recife.lan>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media master

For:
  - Some regression fixes at the Remote Controller core and imon driver;
  - A build fix for certain randconfigs with ir-hix5hd2;
  - Don't feed power to satellite system at ds3000 driver init.

It also contains some fixes for drivers added for Kernel 3.18:
  - Some fixes at the new ISDB-S driver, and the corresponding bits to fix
    some descriptors for this Japanese TV standard at the DVB core;
  - Two warning cleanups for sp2 driver if PM is disabled;
  - Change the default mode for the new vivid driver;

Thanks,
Mauro

The following changes since commit f7e87a44ef60ad379e39b45437604141453bf0ec:

  Merge tag 'media/v3.18-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2014-10-27 15:05:40 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media master

for you to fetch changes up to 167921cb0ff2bdbf25138dad799fec88c99ed316:

  [media] sp2: sp2_init() can be static (2014-11-03 19:08:06 -0200)

----------------------------------------------------------------
media fixes for v3.18-rc4

----------------------------------------------------------------
Akihiro Tsukada (3):
      [media] dvb:tc90522: fix stats report
      [media] dvb-core: set default properties of ISDB-S
      [media] dvb:tc90522: fix always-false expression

Fengguang Wu (1):
      [media] sp2: sp2_init() can be static

Hans Verkuil (1):
      [media] vivid: default to single planar device instances

Mauro Carvalho Chehab (1):
      [media] rc5-decoder: BZ#85721: Fix RC5-SZ decoding

Tomas Melin (1):
      [media] rc-core: fix protocol_change regression in ir_raw_event_register

Ulrich Eckhardt (2):
      [media] ds3000: fix LNB supply voltage on Tevii S480 on initialization
      [media] imon: fix other RC type protocol support

Zhangfei Gao (1):
      [media] ir-hix5hd2 fix build warning

 Documentation/video4linux/vivid.txt       | 12 +++++-------
 drivers/media/dvb-core/dvb_frontend.c     |  6 ++++++
 drivers/media/dvb-frontends/ds3000.c      |  7 +++++++
 drivers/media/dvb-frontends/sp2.c         |  4 ++--
 drivers/media/dvb-frontends/tc90522.c     | 18 ++++++++----------
 drivers/media/platform/vivid/vivid-core.c | 11 +++--------
 drivers/media/rc/imon.c                   |  3 ++-
 drivers/media/rc/ir-hix5hd2.c             |  2 +-
 drivers/media/rc/ir-rc5-decoder.c         |  2 +-
 drivers/media/rc/rc-ir-raw.c              |  1 -
 drivers/media/rc/rc-main.c                |  2 ++
 11 files changed, 37 insertions(+), 31 deletions(-)

