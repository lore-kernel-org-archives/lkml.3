Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbaGPIg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:36:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38519 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756914AbaGPIg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:36:56 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <paul@pwsan.com>, <linux@arm.linux.org.uk>,
        <nsekhar@ti.com>, <j-keerthy@ti.com>, <nm@ti.com>, <rogerq@ti.com>,
        <lokeshvutla@ti.com>
Subject: [PATCH 0/2] ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp interface lists
Date: Wed, 16 Jul 2014 14:06:12 +0530
Message-ID: <1405499774-19770-1-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add seperate ocp interface lists that are specific to dra74x
and dra72x, and moving USB OTG SS4 to dra74x only since its not present
in dra72x. Without this USB OTG SS4 hwmod gives an abort on dra72x.

Adding support for soc_is_dra74x() and soc_is_dra72x() in order to differentiate
between dra74x and dra72x and pass the respective ocp interface lists.

Verified on dra74x evm and dra72x evm using 3.16-rc5 based mainline kernel.

Before:
dra74x : http://paste.ubuntu.com/7802364/ 
dra72x : http://paste.ubuntu.com/7802334/ (Kernel panic)

After-
dra74x : http://paste.ubuntu.com/7802340/
dra72x : http://paste.ubuntu.com/7802338/ (booted)

Rajendra Nayak (2):
  ARM: DRA7: Add support for soc_is_dra74x() and soc_is_dra72x()
    varients
  ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp interface lists

 arch/arm/mach-omap2/omap_hwmod.c          |    3 +++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   22 ++++++++++++++++++++--
 arch/arm/mach-omap2/soc.h                 |    7 +++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

-- 
1.7.9.5

