Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaFLVMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:12:08 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:36771 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaFLVMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:12:06 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 0/2] thunderbolt: Fix issues with more complex endpoints.
Date: Thu, 12 Jun 2014 23:11:45 +0200
Message-Id: <1402607507-14858-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have got my hand on a slightly more complex Thunderbolt device (a Startech
docking station). This series fixes the following issues that I have observed
with this device:

 - Some ports on this device are disabled. Accessing them results in an error.
 - This device uses both Thunderbolt links which are represented as two ports on
   the switch. We have to ensure that we only scan one of these ports.

Part 1 of the series reads the switch configuration (disabled ports and which
port pairs are "dual link ports") from eeprom. Part 2 uses this information to
avoid scanning these ports.

Andreas Noever (2):
  thunderbolt: Read port configuration from eeprom.
  thunderbolt: Fix nontrivial endpoint devices.

 drivers/thunderbolt/ctl.c    |   2 +-
 drivers/thunderbolt/eeprom.c | 266 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/thunderbolt/switch.c |  44 ++++---
 drivers/thunderbolt/tb.c     |   5 +
 drivers/thunderbolt/tb.h     |   7 +-
 5 files changed, 300 insertions(+), 24 deletions(-)

-- 
2.0.0

