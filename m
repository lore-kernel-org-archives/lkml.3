Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaH2Iii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:38:38 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33081 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaH2Iif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:38:35 -0400
Message-ID: <54003c0a.69a0420a.034a.ffffe286@mx.google.com>
X-Google-Original-Message-ID: <000e01cfc364$9cea7230$d6bf5690$@dulixin@gmail.com>
From: "Dudley Du" <dudley.dulixin@gmail.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
Cc: <bleung@google.com>, <patrik@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V5 0/14] input: cyapa: re-architecture driver to support multi-trackpads in one driver
Date: Fri, 29 Aug 2014 16:38:22 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/DWE4C9eKIGEqHTPmSlLiaWpIS5Q==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This v5 patch set is updated based on cyapa v4 patches, it has below updates:
1) Uses get_device()/put_device() instead of kobject_get()/kobject_put();
2) Fix memories freed before debugfs entries issue;
3) Make cyapa_debugs_root valid in driver module level
   in module_init()/moudle_exit() ;
4) Fix i2c_transfer() may return partial transfer issues.
5) Add cyapa->removed flag to avoid detecting thread may still running
   when driver module is removed.
6) Fix the meanings of some comments and return error code not clear issue.


This patch set is aimed to re-architecture the cyapa driver to support
old gen3 trackpad device and new gen5 trackpad device in one
cyapa driver for easily productions support based on
customers' requirements, and add sysfs functions and interfaces
supported that required by users and customers.
Because the earlier gen3 and the latest gen5 trackpad devies using
two different chipsets, and have different protocol and interfaces.
If supported these two trackpad devices in two different drivers, then
it will be difficult to manage productions and later firmware updates.
it will cause customer don't know which one to use and update
because these two trackpad devices have been used and integrated
in same one productions at a time, so must to support these two trackpad
devices in same on driver.

The new architecture is made of:
cyapa.c - the core of the architecture, supply interfaces and
functions to system and read trackpad devices.
cyapa_gen3.c - functions support for gen3 trackpad devices,
cyapa_gen5.c - functions support for gen5 trackpad devices.

Beside this introduction patch, it has 14 patches listed as below.
For these patches each one is patched based on previous one.

patch 1/14: re-architecture cyapa driver with core functions,
and applying the device detecting function in async thread to speed
up system boot time.

patch 2/14: add cyapa driver power management interfaces support.

patch 3/14: add cyapa driver runtime power management interfaces support.

patch 4/14: add cyapa key function interfaces in sysfs system.
Including read firmware version, get production ID, read baseline,
re-calibrate trackpad baselines and do trackpad firmware update.

patch 5/14: add read firmware image and read raw trackpad device'
sensors' raw data interface in debugfs system.

patch 6/14: add gen3 trackpad device basic functions support.

patch 7/14: add gen3 trackpad device firmware update function support.

patch 8/14: add gen3 trackpad device report baseline and do force
re-calibrate functions support.

patch 9/14: add gen3 trackpad device read firmware image function support.

patch 10/14: add gen5 trackpad device basic functions support.

patch 11/14: add gen5 trackpad device firmware update function support.

patch 12/14: add gen5 trackpad device report baseline and do force
re-calibrate functions support.

patch 13/14: add gen5 trackpad device read firmware image and report
sensors' raw data values functions support.

patch 14/14: add function to monitor LID close event to off trackpad device.

