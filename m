Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaKCIeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:34:36 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58367 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaKCIed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:34:33 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 01/18] input: cyapa: instruction of cyapa patches
Date: Mon,  3 Nov 2014 16:32:52 +0800
Message-Id: <1415003590-30485-1-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V9 patches have below updates compared with v8 patches:
1) Removed all async thread stuff from the driver.
2) Split driver into 18 patches for each function change one patch.

V8 patches have below updates compared with v7 patches:
1) [PATCH v8 01/13] - Remove the async thread for device detect in
   probe routine, now the device detect process is completely done within
   the device probe routine.
2) [PATCH v8 01/13] - Split the irq cmd hander function to separated
   function cyapa_default_irq_cmd_handler() and set it to interface
   cyapa_default_ops.irq_cmd_handler.
3) [PATCH v8 06/13] - Add cyapa->gen check in cyapa_gen3_irq_cmd_handler()
   to avoid miss-enter when device protocol is still in detecting.

V7 patches have below updates compared with v6 patches:
1) [PATCH v7 01/13] - Split the irq cmd hander function to separated
   function cyapa_default_irq_cmd_handler() and set it to interface
   cyapa_default_ops.irq_cmd_handler.
2) [PATCH v7 06/13] - Add cyapa->gen check in cyapa_gen3_irq_cmd_handler()
   to avoid miss-enter when device protocol is still in detecting.


V6 patches have below updates compared with v5 patches:
1) Remove patch 14 of the lid filtering from the cyapa driver.

V5 patches have below updates compared with v4 patches:
1) Uses get_device()/put_device() instead of kobject_get()/kobject_put();
2) Fix memories freed before debugfs entries issue;
3) Make cyapa_debugs_root valid in driver module level
   in module_init()/moudle_exit() ;
4) Fix i2c_transfer() may return partial transfer issues.
5) Add cyapa->removed flag to avoid detecting thread may still running
   when driver module is removed.
6) Fix the meanings of some comments and return error code not clear issue.

This patch set is aimed to re-design the cyapa driver to support
old gen3 trackpad devices and new gen5 trackpad devices in one
cyapa driver, it's for easily productions support based on
customers' requirements. And add sysfs functions and interfaces
supported that required by users and customers.

Since the earlier gen3 and the latest gen5 trackpad devices using
two different chipsets, and have different protocols and interfaces,
so if supported these two type trackpad devices in two different drivers,
then it will be difficult to manage productions and later firmware updates.
e.g.: It will cause customer don't know which one trackpad device firmware
image to use and update when it has been used and integrated
in same one productions, so here we support these two trackpad
devices in same on driver.

The new design cyapa driver contains:
cyapa.c - the core of the re-design, supply interfaces and
functions to system and read trackpad devices.
cyapa.h - header file including macros and data structure definitions.
cyapa_gen3.c - functions support for gen3 trackpad devices,
cyapa_gen5.c - functions support for gen5 trackpad devices.

Beside this introduction patch, it has 18 patches listed as below.
For these patches each one is patched based on previous one.

patch 1/18: add device resource management infrastructure supported.

patch 2/18: re-design cyapa driver with core functions and interface
to support multi-type trackpad devices.

patch 3/18: add gen3 trackpad device basic functions supported into the
re-design cyapa driver.

patch 4/18: add gen5 trackpad device basic functions supported into the
re-design cyapa driver.

patch 5/18: add power management interfaces supported for the deivce.

patch 6/18: add runtime power management interfaces supported for the device.

patch 7/18: add sysfs interfaces supported in the cyapa driver.
Including read firmware version, get production ID, read baseline,
re-calibrate trackpad baselines and do trackpad firmware update.

patch 8/18: add gen3 trackpad device's firmware update function supported.

patch 9/18: add gen3 trackpad device's read baseline function supported.

patch 10/18: add gen3 trackpad device's force re-calibrate function supported.

patch 11/18: add gen5 trackpad device's firmware update function supported.

patch 12/18: add gen5 trackpad device's read baseline function supported.

patch 13/18: add gen5 trackpad device's force re-calibrate function.

patch 14/18: add read firmware image debugfs interface supported
in the cyapa driver.

patch 15/18: add gen3 trackpad device's read firmware image function supported.

patch 16/18: add gen5 trackpad device's read firmware image function supported.

patch 17/18: add read trackpad device's sensors' raw data debugfs interface
supported in the cyapa driver.

patch 18/18: add gen5 trackpad device's read read raw function supported.
