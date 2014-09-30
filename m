Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaI3Rsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:48:45 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39018 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaI3Rsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:48:42 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-pm@vger.kernel.org, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 00/10] power/reset: Register drivers with restart handler
Date: Tue, 30 Sep 2014 10:48:26 -0700
Message-Id: <1412099316-23167-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert drivers to use the kernel restart handler instead of setting
arm_pm_restart directly.

This patch set depends on the kernel restart handler patchset submitted
earlier.

Patch 01/10 was tested with qemu. All other patches were compile tested only.

Some of the restart handlers loop forever after the reset instruction was
executed. It might makes sense to use mdelay() instead and return if resetting
the system failed. I did not implement that since I do not know what reasonable
delays would be.

The series does not include drivers to be introduced in the next commit window
(at91, versatile, st-poweroff). Those can be converted later. I also did not
convert the sun6i driver, in the assumption that it will be removed since the
sunxi watchdog driver will register a restart handler for the architecture.

v2: Added Tested-by: and Acked-by: tags where received.
    Return error if restart handler registration fails.
