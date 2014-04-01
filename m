Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaDAUgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:36:08 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:43749 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaDAUgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:36:05 -0400
From: stefan@agner.ch
To: chris@printf.net, linux-mmc@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [RFC 0/2] fixed order for mmc devices/mmc block devices
Date: Tue,  1 Apr 2014 22:35:50 +0200
Message-Id: <cover.1396384101.git.stefan@agner.ch>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

Nowadays SoCs usually have multiple SD/MMC host adapters. Often
the first is connected to an internal eMMC, however sometimes it
is the second controller that is connected to the eMMC.

If the second controller is connected to the eMMC, the number
assigned to the eMMC block device varies depending on whether the
external SD-Card is present or not.
The boot device could be specified using partition UUIDs, but
those can change when recreating the partition table. Especially
for embedded devices it would be preferable to have a reliable
assigned block device number.

The first patch aims to give a way to specify the logical SD/MMC
host order. This is achieved by extending the device tree using
aliases:

aliases {
        mmc0 = "/sdhci@78000600";
        mmc1 = "/sdhci@78000200";
};

The second patch then uses the SD/MMC host index as preferred id
for the block device.

In theory, one SD/MMC host could control multiple cards. For this
case, this patch is somewhat ugly. It would only assign the first
host/card combination with a predictable block number. However,
for the case at hand this would be sufficient. 

Stefan Agner (2):
  mmc: read mmc alias from device tree
  mmc: use SD/MMC host ID for block device name ID

 drivers/mmc/card/block.c |  3 ++-
 drivers/mmc/core/host.c  | 24 +++++++++++++++++++-----
 2 files changed, 21 insertions(+), 6 deletions(-)

-- 
1.9.1

