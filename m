Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbbAVQwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:52:50 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:33940 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbbAVQwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:52:47 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 0/2] Fix no_console_suspend for PNP serial consoles
Date: Thu, 22 Jan 2015 11:50:23 -0500
Message-Id: <1421945425-5326-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg and Rafael,

This v2 of the earlier series submitted back in Nov addresses Rafael's
comments, specifically:

* Adds PNP_CONSOLE flag, which disables the pnp protocol's suspend() and
  disable() methods.

This greatly simplifies the PNP serial driver patch since the existing
pnp device capabilities does not need to be saved and restored now.

Note that it was necessary to continue to use macros, since
struct pnp_protocol is anonymous.

Regards,

Peter Hurley (2):
  PNP: Allow console to override ACPI device sleep
  serial: 8250_pnp: Enable PNP_CONSOLE for console ports

 drivers/pnp/driver.c               |  2 +-
 drivers/tty/serial/8250/8250_pnp.c |  8 +++++++-
 include/linux/pnp.h                | 12 ++++++++++--
 3 files changed, 18 insertions(+), 4 deletions(-)

-- 
2.2.2

