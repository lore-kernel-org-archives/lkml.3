Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3KGRRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:17:49 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52677 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437Ab3KGRRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:17:44 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, catalin.marinas@arm.com, will.deacon@arm.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 0/4] wire up CPU features to udev based module loading
Date: Thu,  7 Nov 2013 18:17:33 +0100
Message-Id: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements automatic module loading based on optional CPU features,
and tries to do so in a generic way. Currently, 32 feature bits are supported,
and how they map to actual CPU features is entirely up to the architecture.

There is some GCC attribute foo in here which people may object to, so any
suggestions on how to implement this in a cleaner way are more than welcome.

Typical usage would look like this:

static struct cpu_feature mod_cpu_feature[] = {
	{ HWCAP_NEON },
	{}
};
MODULE_DEVICE_TABLE(cpu, mod_cpu_feature);

where (on the ARM arch) the module in question would be loaded automatically if
a NEON-capable CPU is detected (and advertised).

Ard Biesheuvel (4):
  x86: move arch_cpu_uevent() to generic code
  cpu: advertise CPU features over udev in a generic way
  scripts/mod: add generic CPU features as module alias
  arm64: advertise CPU features using module aliases

 arch/arm64/Kconfig                |  3 +++
 arch/arm64/kernel/setup.c         |  2 ++
 arch/x86/kernel/cpu/match.c       | 11 -----------
 drivers/base/cpu.c                | 39 ++++++++++++++++++++++++++++++++++++++-
 include/linux/cpu.h               |  1 -
 include/linux/mod_devicetable.h   | 11 +++++++++++
 scripts/mod/devicetable-offsets.c |  3 +++
 scripts/mod/file2alias.c          | 10 ++++++++++
 8 files changed, 67 insertions(+), 13 deletions(-)

-- 
1.8.3.2

