Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaLDQp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:45:58 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40701 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaLDQp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:45:57 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v3 0/3] hwmon: tmp401: support for TMP435 and fix for a probe issue
Date: Thu,  4 Dec 2014 17:45:50 +0100
Message-Id: <1417711553-21311-1-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the TI TMP435 chip and fixes an issue similar
to the one we observed for ina2xx - ignoring the write errors when probing the
device.

v3:
- remove the copyright notice from tmp401.c
- preinitialize status and skip an 'if'

v2:
- changed 'static const char *names' to 'static const char * const names'
  as checkpatch.pl still complained about this one,
- updated Documentation and Kconfig on TMP435,
- added missing error check in tmp401_init_client(),
- removed the redundant "Initialization failed" string since we'll get
  'tmp401: probe of X-00XX failed with error -121' anyway in dmesg,

v1:
https://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg781930.html

Bartosz Golaszewski (2):
  hwmon: tmp401: add TMP435 to the list of supported chips in docs and Kconfig
  hwmon: tmp401: bail-out from tmp401_probe() in case of write errors

Patrick Titiano (1):
  hwmon: tmp401: add support for TI TMP435

 Documentation/hwmon/tmp401 |  7 +++++--
 drivers/hwmon/Kconfig      |  2 +-
 drivers/hwmon/tmp401.c     | 45 ++++++++++++++++++++++++++++++++-------------
 3 files changed, 38 insertions(+), 16 deletions(-)

-- 
2.1.3

