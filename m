Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaHTS2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:28:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbaHTS22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:28:28 -0400
From: Andy Grover <agrover@redhat.com>
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org,
        shli@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFCv2 0/4] Userspace pass-through storage engine (backend)
Date: Wed, 20 Aug 2014 11:28:14 -0700
Message-Id: <1408559298-20037-1-git-send-email-agrover@redhat.com>
In-Reply-To: <1404241875-29164-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is version two of the userspace passthrough backstore code I've
been working on.

You can find some documentation on the design in last patch. Please
let me know what you think about the design and the code.

Thanks -- Andy

Changes since version 1:
* Use netlink for reporting device add/removes to userspace
* Remove pass_level in favor of automatic emulation of commands when
  userspace doesn't support them
* Implemented 'tcmu-runner' daemon to handle the user side of the
  interface and make writing handlers easier (not in this patchset,
  see https://github.com/agrover/tcmu-runner).
* Many bug fixes. Can now successfully partition, format, and use a
  TCMU-backed volume.
* Two small patches added for other changes we need.

Operation:
* Using https://github.com/agrover/targetcli-fb/commits/userback and
  https://github.com/agrover/rtslib-fb/commits/userback, create a user
  storage object and give it a size, and 'file/foo.img' as config
  parameter
* Start tcmu-runner (manually for now)
* Create a loopback fabric and link the above storage object to it

Andy Grover (4):
  target: Remove unneeded check in sbc_parse_cdb
  uio: Export definition of struct uio_device
  target: Add a user-passthrough backstore
  target: Add documentation on the target userspace pass-through driver

 Documentation/target/tcmu-design.txt   |  229 +++++++
 drivers/target/Kconfig                 |    5 +
 drivers/target/Makefile                |    1 +
 drivers/target/target_core_sbc.c       |    2 +-
 drivers/target/target_core_transport.c |    4 +
 drivers/target/target_core_user.c      | 1158 ++++++++++++++++++++++++++++++++
 drivers/uio/uio.c                      |   12 -
 include/linux/uio_driver.h             |   12 +-
 include/uapi/linux/Kbuild              |    1 +
 include/uapi/linux/target_core_user.h  |  142 ++++
 10 files changed, 1552 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/target/tcmu-design.txt
 create mode 100644 drivers/target/target_core_user.c
 create mode 100644 include/uapi/linux/target_core_user.h

-- 
1.9.3

