Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3FGIWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:22:32 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:59533 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3FGIWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:22:24 -0400
From: Adam Lee <adam.lee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
Subject: [PATCH 0/3] thinkpad_acpi: avoid ACPI Warning while operating non-exist LEDs
Date: Fri,  7 Jun 2013 16:20:06 +0800
Message-Id: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some new Lenovo or ThinkPad laptops don't have EC controllable LEDs,
they control LEDs by BIOS functions, and return ACPI Warning while
operating LEDs by EC.

These patches set some quirks, optimize led_init() and led_write() to
avoid that warning.

Adam Lee (3):
  thinkpad_acpi: return -NODEV while operating uninitialized LEDs
  thinkpad_acpi: add the ability setting TPACPI_LED_NONE by quirk
  thinkpad_acpi: add LED quirks of models which don't have EC controllable LEDs

 drivers/platform/x86/thinkpad_acpi.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

-- 
1.7.10.4

