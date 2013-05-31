Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab3EaLhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:37:43 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:37525 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756017Ab3EaLhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:37:33 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mchehab@redhat.com, hans.verkuil@cisco.com,
        prabhakar.csengg@gmail.com, g.liakhovetski@gmx.de,
        ezequiel.garcia@free-electrons.com, timo.teras@iki.fi
Subject: [RFC v2 0/2] saa7115: Implement i2c_board_info.platform_data
Date: Fri, 31 May 2013 13:40:24 +0200
Message-Id: <1370000426-3324-1-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.2.3
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

This is the second version of this patch series.
The first version of the RFC can be found here:
https://lkml.org/lkml/2013/5/29/558

In this version I've added a new init table for saa7113 chips.
This new table is only used by drivers that set the i2c_board_info.platform data.
I've also tried to give the different overrides some less obscure names.

Jon Arne Jørgensen (2):
  saa7115: Implement i2c_board_info.platform_data
  saa7115: Remove gm7113c video_std register change

 drivers/media/i2c/saa7115.c      | 127 ++++++++++++++++++++++++++++++---------
 drivers/media/i2c/saa711x_regs.h |   8 +++
 include/media/saa7115.h          |  39 ++++++++++++
 3 files changed, 145 insertions(+), 29 deletions(-)

-- 
1.8.2.3

