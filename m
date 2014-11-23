Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaKWPJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 10:09:45 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61844 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaKWPJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 10:09:43 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, Darren Hart <dvhart@infradead.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Alex Hung <alex.hung@canonical.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 0/3] Dell Airplane Mode Switch driver
Date: Sun, 23 Nov 2014 16:09:18 +0100
Message-Id: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add new acpi Dell Airplane Mode Switch driver (DELLABCE and
DELRBTN acpi devices). It provides radio HW switch events (together with current
state of radio devices) and export them via rfkill interface. These events are
also used in dell-laptop driver instead i8042 filter hook function (when acpi
device is available).

Pali Rohár (3):
  platform: x86: dell-rbtn: Dell Airplane Mode Switch driver
  platform: x86: dell-rbtn: Export notifier for other kernel modules
  platform: x86: dell-laptop: Use dell-rbtn instead i8042 filter when
    possible

 drivers/platform/x86/Kconfig       |   14 ++
 drivers/platform/x86/Makefile      |    1 +
 drivers/platform/x86/dell-laptop.c |   67 +++++++++-
 drivers/platform/x86/dell-rbtn.c   |  260 ++++++++++++++++++++++++++++++++++++
 drivers/platform/x86/dell-rbtn.h   |   35 +++++
 5 files changed, 372 insertions(+), 5 deletions(-)
 create mode 100644 drivers/platform/x86/dell-rbtn.c
 create mode 100644 drivers/platform/x86/dell-rbtn.h

-- 
1.7.9.5

