Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3GFRXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 13:23:18 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38347 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3GFRXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 13:23:11 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] Introduce and use device_create_groups
Date: Sat,  6 Jul 2013 10:23:02 -0700
Message-Id: <1373131387-13342-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces the new driver core API function
device_create_groups().

device_create_groups() lets callers create devices as well as associated
sysfs attributes with a single call. This avoids potential race conditions
seen if sysfs attributes on new devices are created later.

The rationale for the new API is that sysfs attributes should be created
synchronously with device creation to avoid race conditions, as outlined in
http://www.linuxfoundation.org/news-media/blogs/browse/2013/06/how-create-sysfs-file-correctly.

Unfortunately, the only API function to create a device dynamically is
device_create, which does not support the notion of adding sysfs attributes
when creating a device. The new API call is similar but lets the caller provide
a list of sysfs attribute groups.

The first patch in the series introduces the new driver core API function.

The second patch introduces hwmon_device_register_groups(), which uses the new
API call.

The remaining patches convert some hwmon drivers to use the new API to show and
test its use.
