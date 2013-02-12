Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab3BLLuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 06:50:21 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55880 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758399Ab3BLLuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 06:50:19 -0500
From: sjur.brandeland@stericsson.com
To: Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc: sjur@brendeland.net, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 vringh 0/3] Introduce CAIF Virtio driver
Date: Tue, 12 Feb 2013 12:49:50 +0100
Message-Id: <1360669793-6921-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

This driver depends on Rusty's new host virtio ring implementation,
so this patch-set is based on the vringh branch in Rusty's git.

Changes since V1:
- Use the new iov helper functions, and simplify iov handling.
  However this triggers compile warnings, as it takes struct iov
  while kernel api uses struct kiov
- Introduced the module_virtio_driver macro
- Pass NULL as wiov to vringh_getdesc_kern() 

Regards,
Sjur

Sjur Brændeland (2):
  remoteproc: Add support for vringh (Host vrings)
  virtio: Add module driver macro for virtio drivers.

Vikram ARV (1):
  caif_virtio: Introduce caif over virtio

 drivers/net/caif/Kconfig               |    8 +
 drivers/net/caif/Makefile              |    3 +
 drivers/net/caif/caif_virtio.c         |  547 ++++++++++++++++++++++++++++++++
 drivers/remoteproc/Kconfig             |    3 +
 drivers/remoteproc/remoteproc_virtio.c |  127 +++++++-
 include/linux/remoteproc.h             |   14 +
 include/linux/virtio.h                 |    9 +
 include/linux/virtio_caif.h            |   24 ++
 include/uapi/linux/virtio_ids.h        |    1 +
 9 files changed, 729 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/caif/caif_virtio.c
 create mode 100644 include/linux/virtio_caif.h

-- 
1.7.5.4

