Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbaIOXOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:14:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758843AbaIOXMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:12:38 -0400
From: Andy Grover <agrover@redhat.com>
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org,
        shli@kernel.org, linux-kernel@vger.kernel.org, rjones@redhat.com
Subject: [PATCH 0/4] Userspace Passthrough backstore for LIO
Date: Mon, 15 Sep 2014 16:12:26 -0700
Message-Id: <1410822750-10717-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is version three of the userspace passthrough backstore code I've
been working on. I think it's ready to be considered for upstream.

If you are wondering what this is, patch 3 is documentation that
should explain, at both a high- and low-level.

There are other pieces needed for this to work properly -- changes to
targetcli and rtslib to easily configure the new backstore type, plus
the user code that hooks up to the passthrough. I've written some code
to do this, called tcmu-runner
(https://github.com/agrover/tcmu-runner) but the userspace development
naturally is hindered until the kernel code is accepted :)

Changes since version 2:
* Incorporate doc improvements from Richard W. M. Jones
* Correct off-by-1 error in tcmu_get_blocks
* execute_rw must be set in the sbc_ops passed to sbc_parse_cdb

Thanks -- Andy

Andy Grover (4):
  target: Remove unneeded check in sbc_parse_cdb
  uio: Export definition of struct uio_device
  target: Add documentation on the target userspace pass-through driver
  target: Add a user-passthrough backstore

 Documentation/target/tcmu-design.txt   |  239 +++++++
 drivers/target/Kconfig                 |    5 +
 drivers/target/Makefile                |    1 +
 drivers/target/target_core_sbc.c       |    2 +-
 drivers/target/target_core_transport.c |    4 +
 drivers/target/target_core_user.c      | 1169 ++++++++++++++++++++++++++++++++
 drivers/uio/uio.c                      |   12 -
 include/linux/uio_driver.h             |   12 +-
 include/uapi/linux/Kbuild              |    1 +
 include/uapi/linux/target_core_user.h  |  142 ++++
 10 files changed, 1573 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/target/tcmu-design.txt
 create mode 100644 drivers/target/target_core_user.c
 create mode 100644 include/uapi/linux/target_core_user.h

-- 
1.9.3

