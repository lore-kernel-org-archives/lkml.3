Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaJCSFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:05:51 -0400
Received: from lists.s-osg.org ([54.187.51.154]:39249 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbaJCSFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:05:50 -0400
Date: Fri, 3 Oct 2014 15:05:44 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.17] si2165 firmware changes
Message-ID: <20141003150544.435e323f@recife.lan>
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
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/topic/si2165-v3.17-rc8

For some changes at the si2165 firmware name and the removal of an extra
unneeded header added artificially via the script that extracts it from
the original driver provided by the manufacturer.

The si2165 is a new driver that was added for v3.17. There are two issues
with the current firmware format:

- The firmware only covers one specific revision of the chipset
  (Rev. D). We'll be adding support for another revision for v3.18, so
  it would be better to rename the firmware file to reflect the revision
  on its name:

	-#define SI2165_FIRMWARE "dvb-demod-si2165.fw"
	+#define SI2165_FIRMWARE_REV_D "dvb-demod-si2165-d.fw"

- Instead of containing a single blob with the firmware, the file
  also contains some meta-data that could be determined on some other way
  directly by the driver.

The script that gets the firmware from the Internet was also updated
accordingly to not add the extra header.

Thanks!
Mauro



The following changes since commit 90a5dbef1a66e9f55b76ccb83c0ef27c0bd87c27:

  Revert "[media] media: em28xx - remove reset_resume interface" (2014-09-28 22:25:24 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/topic/si2165-v3.17-rc8

for you to fetch changes up to 3173fbdce9e41fc4fabe0b3dedd99c615f47dbdd:

  [media] [V2,2/2] si2165: do load firmware without extra header (2014-10-02 18:18:52 -0300)

----------------------------------------------------------------
topic/si2165 fixes for v3.17-rc8

----------------------------------------------------------------
Matthias Schwarzott (2):
      [media] [V2, 1/2] get_dvb_firmware: si2165: drop the extra header from the firmware
      [media] [V2,2/2] si2165: do load firmware without extra header

 Documentation/dvb/get_dvb_firmware        |  20 ++----
 drivers/media/dvb-frontends/Kconfig       |   1 +
 drivers/media/dvb-frontends/si2165.c      | 107 ++++++++++++++++++------------
 drivers/media/dvb-frontends/si2165_priv.h |   2 +-
 4 files changed, 71 insertions(+), 59 deletions(-)

	
