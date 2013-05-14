Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3ENGrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 02:47:53 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55967 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3ENGrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 02:47:51 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH RFC v3 0/4] media: davinci: vpif: capture/display support for async subdevice probing
Date: Tue, 14 May 2013 12:17:32 +0530
Message-Id: <1368514056-28859-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch series adds support for vpif capture and display
driver to support asynchronously register subdevices.
The first two patches adds asynchronous probing for adv7343
and tvp514x respectively.

Need for this support:
Currently bridge device drivers register devices for all subdevices
synchronously, typically, during their probing. E.g. if an I2C CMOS sensor
is attached to a video bridge device, the bridge driver will create an I2C
device and wait for the respective I2C driver to probe. This makes linking
of devices straight forward, but this approach cannot be used with
intrinsically asynchronous and unordered device registration systems like
the Flattened Device Tree.

This series is dependent on following patches:
1: https://patchwork.kernel.org/patch/2437111/
2: https://patchwork.linuxtv.org/patch/18096/

Changes for v3:
1: Fixed review comment pointed out by Guennadi.

Changes for v2:
1: added support v4l-async support for vpif display driver.
2: added asynchronous probing for adv7343.


Lad, Prabhakar (4):
  media: i2c: adv7343: add support for asynchronous probing
  media: i2c: tvp514x: add support for asynchronous probing
  media: davinci: vpif: capture: add V4L2-async support
  media: davinci: vpif: display: add V4L2-async support

 drivers/media/i2c/adv7343.c                   |   16 ++-
 drivers/media/i2c/tvp514x.c                   |   23 ++-
 drivers/media/platform/davinci/vpif_capture.c |  151 ++++++++++++------
 drivers/media/platform/davinci/vpif_capture.h |    2 +
 drivers/media/platform/davinci/vpif_display.c |  219 +++++++++++++++----------
 drivers/media/platform/davinci/vpif_display.h |    3 +-
 include/media/davinci/vpif_types.h            |    4 +
 7 files changed, 272 insertions(+), 146 deletions(-)

-- 
1.7.4.1

