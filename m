Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbaEAPlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:41:47 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55125 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaEAPlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:41:45 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 0/5] watchdog: Add reboot API
Date: Thu,  1 May 2014 08:41:28 -0700
Message-Id: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hardware implements reboot through its watchdog hardware, for example
by triggering a watchdog timeout or by writing into its watchdog register
set. Platform specific code starts to spread into watchdog drivers,
typically by setting pointers to a callback function which is then called
from the architecture's reset handler.

While global and exported callback function pointers (such as arm_pm_restart)
may be acceptable as long as they are used from platform and/or architecture
code, using such a mechanism across subsystems and drivers is less than
desirable. Ultimately, we'll need a better solution.

This patch series is an attempt to provide such a solution. It extends
the watchdog subsystem to support reboot functionality, provides an
API function call to trigger reboots, adds support for the new API
to arm and arm64, and converts the drivers providing reboot functionality
to use the new infrastructure.

The first patch in the series implements the new API. The second and third
patch modify the arm and arm64 architecture reset handlers to call the
added API function. The final two patches register the reboot handlers
in the sunxi and moxart watchdog drivers with the watchdog subsystem.

The sunxi patche depends on the most recent patch series sumitted by
Maxime Ripard.

Compile tested only.
