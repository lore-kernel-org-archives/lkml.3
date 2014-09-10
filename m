Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084AbaIJEjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:39:01 -0400
Received: from bay004-omc1s1.hotmail.com ([65.54.190.12]:50237 "EHLO
	BAY004-OMC1S1.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaIJEi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:38:59 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 00:38:59 EDT
X-TMN: [IRA87PEANCBFkrsL2+k0Ynin1HP7+rSo]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY176-DS113F7C9EFFF3BA8B47782ABDCF0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 00/13] input: cyapa: re-architecture driver to support multi-trackpads in one driver
Date: Wed, 10 Sep 2014 12:33:52 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/Mo5oRDqjb7486SA6e5qA9AyN7og==
Content-Language: zh-cn
X-OriginalArrivalTime: 10 Sep 2014 04:33:54.0195 (UTC) FILETIME=[6D96E630:01CFCCB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This v6 patch set is updated based on cyapa v5 patches, it has below updates:
1) Remove patch 14 of the lid filtering from the cyapa driver.

v5 patch set updates compared with cyapa v4 patches:
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

patch 1/13: re-architecture cyapa driver with core functions,
and applying the device detecting function in async thread to speed
up system boot time.

patch 2/13: add cyapa driver power management interfaces support.

patch 3/13: add cyapa driver runtime power management interfaces support.

patch 4/13: add cyapa key function interfaces in sysfs system.
Including read firmware version, get production ID, read baseline,
re-calibrate trackpad baselines and do trackpad firmware update.

patch 5/13: add read firmware image and read raw trackpad device'
sensors' raw data interface in debugfs system.

patch 6/13: add gen3 trackpad device basic functions support.

patch 7/13: add gen3 trackpad device firmware update function support.

patch 8/13: add gen3 trackpad device report baseline and do force
re-calibrate functions support.

patch 9/13: add gen3 trackpad device read firmware image function support.

patch 10/13: add gen5 trackpad device basic functions support.

patch 11/13: add gen5 trackpad device firmware update function support.

patch 12/13: add gen5 trackpad device report baseline and do force
re-calibrate functions support.

patch 13/13: add gen5 trackpad device read firmware image and report
sensors' raw data values functions support.

