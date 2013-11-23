Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab3KWTD2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 14:03:28 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36078 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3KWTD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 14:03:26 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 0/5] hwmon updates for x86 platform drivers
Date: Sat, 23 Nov 2013 11:03:16 -0800
Message-Id: <1385233401-21517-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common changes:
- Convert to new hwmon API to simplify code and avoid race conditions
  due to late sysfs attribute registration.
  With this change, hwmon sysfs attributes are now always attached
  to the hwmon device and no longer to its parent device (where this
  was the case).
- Replace SENSOR_DEVICE_ATTR with DEVICE_ATTR where appropriate,
  ie if the additional parameter provided by SENSOR_DEVICE_ATTR
  was not used.
- Use devm_kzalloc() instead of kzalloc() where appropriate to reduce
  code size and simplify error path.

All patches were compile tested only. Unfortunately, I don't have
the necessary hardware to test on real systems.
