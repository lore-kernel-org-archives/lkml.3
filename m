Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822Ab3GCXYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:24:44 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:54223 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933113Ab3GCXYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:24:42 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: jonarne@jonarne.no, linux-kernel@vger.kernel.org, mchehab@redhat.com,
        hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        laurent.pinchart@ideasonboard.com, andriy.shevchenko@linux.intel.com
Subject: [RFC v3 0/3] saa7115: Implement i2c_board_info.platform_data
Date: Thu,  4 Jul 2013 01:27:17 +0200
Message-Id: <1372894040-23922-1-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds handling of the i2c_board_info struct to the saa7115 driver.
The main goal of this patch is to give the different devices with the gm7113c
chip an opportunity to configure the chip to their needs.

I've only implemented the overrides I know are necessary to get the stk1160
and the smi2021 drivers to work.

This is the third version of this patch series.
The second version of the RFC was posted on 2013/5/31 and can be found here:
http://lkml.indiana.edu/hypermail/linux/kernel/1305.3/03747.html

The first version of the RFC can be found here:
https://lkml.org/lkml/2013/5/29/558

Jon Arne Jørgensen (3):
  saa7115: Fix saa711x_set_v4lstd for gm7113c
  saa7115: Do not load saa7115_init_misc for gm7113c
  saa7115: Implement i2c_board_info.platform_data

 drivers/media/i2c/saa7115.c      | 183 +++++++++++++++++++++++++++++++--------
 drivers/media/i2c/saa711x_regs.h |  19 ++++
 include/media/saa7115.h          |  65 ++++++++++++++
 3 files changed, 233 insertions(+), 34 deletions(-)

-- 
1.8.3.1

