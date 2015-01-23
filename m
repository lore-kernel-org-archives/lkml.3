Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbbAWUWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:22:08 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:54238 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbbAWUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:22:06 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org
Cc: dmidecode-devel@nongnu.org, grant.likely@linaro.org,
        leif.lindholm@linaro.org, matt.fleming@intel.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH 0/2] firmware: dmi-sysfs: add SMBIOS
Date: Fri, 23 Jan 2015 22:21:45 +0200
Message-Id: <1422044507-22982-1-git-send-email-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some utils, like dmidecode and smbios, needs to access SMBIOS entry
table area in order to get information like SMBIOS version, size, etc.
Currently it's done via /dev/mem. But for situation when /dev/mem
usage is disabled, the utils have to use dmi sysfs instead, which
doesn't represent SMBIOS entry. So this patch series adds SMBIOS
area to dmi sysfs in order to allow utils in question to work
correctly with dmi sysfs.

Ivan Khoronzhuk (2):
  firmware: dmi_scan: add symbol to get SMBIOS entry area
  firmware: dmi-sysfs: add SMBIOS entry point area attribute

 drivers/firmware/dmi-sysfs.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/dmi_scan.c  | 34 ++++++++++++++++++++++++++++++++++
 include/linux/dmi.h          |  2 ++
 3 files changed, 78 insertions(+)

-- 
1.9.1

