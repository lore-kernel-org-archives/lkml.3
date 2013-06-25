Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3FYPR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:17:57 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54842 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3FYPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:17:56 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] media: davinci: vpif: capture/display support for async subdevice probing
Date: Tue, 25 Jun 2013 20:47:33 +0530
Message-Id: <1372173455-509-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch series adds support for vpif capture and display
driver to support asynchronously register subdevices.

Need for this support:
Currently bridge device drivers register devices for all subdevices
synchronously, typically, during their probing. E.g. if an I2C CMOS sensor
is attached to a video bridge device, the bridge driver will create an I2C
device and wait for the respective I2C driver to probe. This makes linking
of devices straight forward, but this approach cannot be used with
intrinsically asynchronous and unordered device registration systems like
the Flattened Device Tree.

This is the NON RFC version, following are previous RFC versions,
RFC V1: http://us.generation-nt.com/answer/patch-rfc-0-3-vpif-capture-support-async-subdevice-probing-help-210037922.html
RFC V2: https://lkml.org/lkml/2013/4/22/159
RFC V3: http://lkml.indiana.edu/hypermail/linux/kernel/1305.1/03180.html

Lad, Prabhakar (2):
  media: davinci: vpif: capture: add V4L2-async support
  media: davinci: vpif: display: add V4L2-async support

 drivers/media/platform/davinci/vpif_capture.c |  151 ++++++++++++------
 drivers/media/platform/davinci/vpif_capture.h |    2 +
 drivers/media/platform/davinci/vpif_display.c |  210 +++++++++++++++----------
 drivers/media/platform/davinci/vpif_display.h |    3 +-
 include/media/davinci/vpif_types.h            |    4 +
 5 files changed, 239 insertions(+), 131 deletions(-)

-- 
1.7.9.5

