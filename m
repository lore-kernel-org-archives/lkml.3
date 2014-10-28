Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaJ1L1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:27:11 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:27961 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaJ1L1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:27:08 -0400
From: Qais Yousef <qais.yousef@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Qais Yousef <qais.yousef@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: [PATCH 00/11] Add AXD Audio Processing IP driver
Date: Tue, 28 Oct 2014 11:26:18 +0000
Message-ID: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AXD Audio Processing IP performs audio decoding, encoding, mixing, equalisation,
synchronisation and playback. This series adds the driver and DT binding
document.

I tried to split it into 'logical' units as there are many files and some of them
are big (necessarily I believe). If it is still difficult to review as is I'd
be happy to take on any suggestion to make things easier.

I added it to drivers/char as this is the best location I could think of at the
moment. It doesn't fit in alsa subsystem but I Cced them to confirm.
Also I'm not sure if new drivers should go to staging first then get promoted or
they can be accepted directly.

This is based on Linus' 3.18-rc2

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <devicetree@vger.kernel.org>
Cc: <alsa-devel@alsa-project.org>

Qais Yousef (11):
  MAINTANERS: Add AXD as a supported driver
  dt: bindings: add AXD Audio Processing IP binding document
  drivers: char: add AXD Audio Processing IP driver
  drivers: char: axd: add fw binary header manipulation files
  drivers: char: axd: add buffers manipulation files
  drivers: char: axd: add basic files for sending/receiving axd cmds
  drivers: char: axd: add cmd interfce helper functions
  drivers: char: axd: add low level AXD platform setup files
  drivers: char: axd: add sysfs setup files
  drivers: char: axd: add ts interface file
  drivers: char: axd: add Kconfig and Makefile

 Documentation/devicetree/bindings/axd.txt  |   39 +
 MAINTAINERS                                |    6 +
 drivers/char/Kconfig                       |    2 +
 drivers/char/Makefile                      |    2 +
 drivers/char/axd/Kconfig                   |   19 +
 drivers/char/axd/Makefile                  |   20 +
 drivers/char/axd/axd_api.h                 |  641 ++++++
 drivers/char/axd/axd_buffers.c             |  245 +++
 drivers/char/axd/axd_buffers.h             |   70 +
 drivers/char/axd/axd_cmds.c                |   98 +
 drivers/char/axd/axd_cmds.h                |  531 +++++
 drivers/char/axd/axd_cmds_codec_internal.c |   58 +
 drivers/char/axd/axd_cmds_codec_internal.h |   28 +
 drivers/char/axd/axd_cmds_config.c         | 1194 ++++++++++
 drivers/char/axd/axd_cmds_decoder_config.c | 1806 ++++++++++++++++
 drivers/char/axd/axd_cmds_encoder_config.c |  519 +++++
 drivers/char/axd/axd_cmds_info.c           | 1409 ++++++++++++
 drivers/char/axd/axd_cmds_internal.c       | 3237 ++++++++++++++++++++++++++++
 drivers/char/axd/axd_cmds_internal.h       |  306 +++
 drivers/char/axd/axd_cmds_pipes.c          | 1368 ++++++++++++
 drivers/char/axd/axd_hdr.c                 |   69 +
 drivers/char/axd/axd_hdr.h                 |   20 +
 drivers/char/axd/axd_module.c              | 1064 +++++++++
 drivers/char/axd/axd_module.h              |   99 +
 drivers/char/axd/axd_platform.h            |   31 +
 drivers/char/axd/axd_platform_mips.c       |  270 +++
 drivers/char/axd/axd_sysfs.h               |   37 +
 drivers/char/axd/axd_sysfs_ctrl.c          |  539 +++++
 drivers/char/axd/axd_sysfs_input.c         |  406 ++++
 drivers/char/axd/axd_sysfs_output.c        | 1373 ++++++++++++
 drivers/char/axd/axd_ts_driver.h           |   24 +
 include/linux/axd.h                        |   32 +
 32 files changed, 15562 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/axd.txt
 create mode 100644 drivers/char/axd/Kconfig
 create mode 100644 drivers/char/axd/Makefile
 create mode 100644 drivers/char/axd/axd_api.h
 create mode 100644 drivers/char/axd/axd_buffers.c
 create mode 100644 drivers/char/axd/axd_buffers.h
 create mode 100644 drivers/char/axd/axd_cmds.c
 create mode 100644 drivers/char/axd/axd_cmds.h
 create mode 100644 drivers/char/axd/axd_cmds_codec_internal.c
 create mode 100644 drivers/char/axd/axd_cmds_codec_internal.h
 create mode 100644 drivers/char/axd/axd_cmds_config.c
 create mode 100644 drivers/char/axd/axd_cmds_decoder_config.c
 create mode 100644 drivers/char/axd/axd_cmds_encoder_config.c
 create mode 100644 drivers/char/axd/axd_cmds_info.c
 create mode 100644 drivers/char/axd/axd_cmds_internal.c
 create mode 100644 drivers/char/axd/axd_cmds_internal.h
 create mode 100644 drivers/char/axd/axd_cmds_pipes.c
 create mode 100644 drivers/char/axd/axd_hdr.c
 create mode 100644 drivers/char/axd/axd_hdr.h
 create mode 100644 drivers/char/axd/axd_module.c
 create mode 100644 drivers/char/axd/axd_module.h
 create mode 100644 drivers/char/axd/axd_platform.h
 create mode 100644 drivers/char/axd/axd_platform_mips.c
 create mode 100644 drivers/char/axd/axd_sysfs.h
 create mode 100644 drivers/char/axd/axd_sysfs_ctrl.c
 create mode 100644 drivers/char/axd/axd_sysfs_input.c
 create mode 100644 drivers/char/axd/axd_sysfs_output.c
 create mode 100644 drivers/char/axd/axd_ts_driver.h
 create mode 100644 include/linux/axd.h

-- 
2.1.0

