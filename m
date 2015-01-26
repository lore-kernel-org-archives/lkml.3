Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbbAZN24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:28:56 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48670 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbAZN2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:28:54 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org
Cc: dmidecode-devel@nongnu.org, grant.likely@linaro.org,
        leif.lindholm@linaro.org, matt.fleming@intel.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [Patch v2 0/2] firmware: dmi-sysfs: add SMBIOS entry point area raw attribute
Date: Mon, 26 Jan 2015 15:28:36 +0200
Message-Id: <1422278918-31477-1-git-send-email-ivan.khoronzhuk@linaro.org>
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

v1: https://lkml.org/lkml/2015/1/23/643

v2..v1:
  firmware: dmi_scan: add symbol to get SMBIOS entry area
	- used additional static var to hold SMBIOS raw table size
	- changed format of get_smbios_entry_area symbol
	  returned pointer on const smbios table

  firmware: dmi-sysfs: add SMBIOS entry point area attribute
	- adopted to updated get_smbios_entry_area symbol
  	- removed redundant array to save smbios table

Ivan Khoronzhuk (2):
  firmware: dmi_scan: add symbol to get SMBIOS entry area
  firmware: dmi-sysfs: add SMBIOS entry point area attribute

 drivers/firmware/dmi-sysfs.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/dmi_scan.c  | 26 ++++++++++++++++++++++++++
 include/linux/dmi.h          |  3 +++
 3 files changed, 71 insertions(+)

-- 
1.9.1

