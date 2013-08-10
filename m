Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316Ab3HJMnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 08:43:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48155 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932634Ab3HJMnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 08:43:07 -0400
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Lior Amsalem <alior@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: [PATCH 0/3] Introduce atomic MMIO register clear-set
Date: Sat, 10 Aug 2013 09:42:59 -0300
Message-Id: <1376138582-7550-1-git-send-email-ezequiel.garcia@free-electrons.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following a suggestion from Sebastian Hesselbarth and Russell King
here's some work to introduce a generic thread-safe clear-set register
access.

The original motivation for this comes from the need to access the same
register from a clocksource driver and a watchdog driver as we find
in Kirkwood, Armada 370/XP SoCs.

Since this sort of design is expected to appear in other platforms,
instead of exporting platform-specific {mvebu,orion}_clear_set() functions
for the thread-safe access, this patchset implements a system-wide API.

Although this is placed in arm/kernel/io.c, there's nothing
ARM-specific in the API and should probably me moved somewhere else.

Suggestions on where to put it are appreciated.

Using this API it's possible -for instance- to add support for Armada 370/XP
in the orion_wdt driver. That work is ready, and it's been hold until we
decide a proper solution for shared-register access.

Based in v3.11-rc4.

Ezequiel Garcia (3):
  ARM: Introduce atomic MMIO clear/set
  clocksource: orion: Use atomic access for shared registers
  watchdog: orion: Use atomic access for shared registers

 arch/arm/include/asm/io.h        |  5 +++++
 arch/arm/kernel/io.c             | 24 ++++++++++++++++++++++++
 drivers/clocksource/time-orion.c |  9 ++-------
 drivers/watchdog/orion_wdt.c     |  8 ++------
 4 files changed, 33 insertions(+), 13 deletions(-)

-- 
1.8.1.5

