Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbaLCJbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:31:12 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56069 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaLCJbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:31:09 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com, dso@cypress.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 00/19] input: cyapa: instruction of cyapa patches
Date: Wed,  3 Dec 2014 17:30:06 +0800
Message-Id: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V12 patches have below main updates compared with v10 patches:
1) Add check that when TP is detected but not operational, do not exit driver
   immediately, but wait and export the update_fw interface for recovering.
2) Re-arrange the function codes, remove unnesseary protype definitions in
   the header file.

V11 patches have below main updates compared with v10 patches:
1) Add add acpi device id supported for old gen3 and new gen5 trackpad devices.
2) Fix the unable to update firmware issue when cyapa_open is not called
   which means the irq for firwmare update process is not enabled. This fix
   by checking if the irq is enabled, if not then enable irq before start to
   do firmware update.

V10 patches have below main updates compared with v9 patches:
1) Modify code to following kernel code style.
   e.g.: correct to use error as return name when there is only error path,
   and fix the checkpatch.sh wanting in the driver.
2) Remove cyapa_remove method and use input open and close interface to
   following device resouse management infrastructure.
3) Modify cyapa_detect method to return tristate issue to make the return value
   much more consistent and clear.
4) Use platform supplied functions as possible instead of driver
   specific rewritten version.

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

patch 1/19: modify code to following kernel code style.

patch 2/19: add device resource management infrastructure support.

patch 3/19: re-design cyapa driver with core functions and interface
to support multi-type trackpad devices.

patch 4/19: add gen5 trackpad device basic functions supported into the
re-design cyapa driver.

patch 5/19: add power management interfaces supported for the deivce.

patch 6/19: add runtime power management interfaces supported for the device.

patch 7/19: add sysfs interfaces supported in the cyapa driver.
Including read firmware version, get production ID, read baseline,
re-calibrate trackpad baselines and do trackpad firmware update.

patch 8/19: add gen3 trackpad device's firmware update function supported.

patch 9/19: add gen3 trackpad device's read baseline function supported.

patch 10/19: add gen3 trackpad device's force re-calibrate function supported.

patch 11/19: add gen5 trackpad device's firmware update function supported.

patch 12/19: add gen5 trackpad device's read baseline function supported.

patch 13/19: add gen5 trackpad device's force re-calibrate function.

patch 14/19: add read firmware image debugfs interface supported
in the cyapa driver.

patch 15/19: add gen3 trackpad device's read firmware image function supported.

patch 16/19: add gen5 trackpad device's read firmware image function supported.

patch 17/19: add read trackpad device's sensors' raw data debugfs interface
supported in the cyapa driver.

patch 18/19: add gen5 trackpad device's read read raw function supported.

patch 19/19: add acpi device id supported.
