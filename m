Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbbAKU1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 15:27:16 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:38510 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbbAKU1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 15:27:13 -0500
Message-ID: <1421008017.13233.8.camel@haakon3.risingtidesystems.com>
Subject: [GIT PULL] target fixes for v3.19-rc4
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2015 12:26:57 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the target pending fixes for v3.19-rc4.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

Mostly minor fixes this time, including:

  - Add missing virtio-scsi -> TCM attribute conversion in vhost-scsi.
  - Fix persistent reservations write exclusive handling to allow
    readers for all registered I_T nexuses.
  - Drop arbitrary maximum I/O size limit in order to process I/Os
    larger than 4 MB, required for initiators that don't honor block
    limits EVPD.
  - Drop the now left-over fabric_max_sectors attribute.

Thank you,

--nab

Andy Grover (1):
  iscsi-target: Fix typos in enum cmd_flags_table

Lee Duncan (1):
  target: Allow Write Exclusive non-reservation holders to READ

Nicholas Bellinger (4):
  vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion
  Documentation/target: Update fabric_ops to latest code
  target: Drop arbitrary maximum I/O size limit
  target: Drop left-over fabric_max_sectors attribute

Sagi Grimberg (1):
  MAINTAINERS: Add entry for iSER target driver

 Documentation/target/tcm_mod_builder.py       | 49 ++++++------------------
 MAINTAINERS                                   |  9 +++++
 drivers/target/iscsi/iscsi_target.c           | 12 +++---
 drivers/target/iscsi/iscsi_target_core.h      |  4 +-
 drivers/target/target_core_device.c           | 54 ++-------------------------
 drivers/target/target_core_file.c             | 12 +++++-
 drivers/target/target_core_iblock.c           |  3 +-
 drivers/target/target_core_pr.c               | 12 ++++++
 drivers/target/target_core_rd.c               |  1 -
 drivers/target/target_core_sbc.c              | 15 --------
 drivers/target/target_core_spc.c              |  5 +--
 drivers/target/target_core_user.c             |  1 -
 drivers/vhost/scsi.c                          | 24 ++++++++++--
 include/target/target_core_backend.h          |  1 -
 include/target/target_core_backend_configfs.h |  2 -
 include/target/target_core_base.h             |  3 --
 16 files changed, 78 insertions(+), 129 deletions(-)

