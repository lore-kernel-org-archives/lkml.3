Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaDDMoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:44:14 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43278 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbaDDMoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:44:11 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH v4 0/8] Introducing (yet again) Device Tree Overlays
Date: Fri,  4 Apr 2014 15:43:53 +0300
Message-Id: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pantelis Antoniou <panto@antoniou-consulting.com>

The following patchset introduces Device Tree overlays, a method
of dynamically altering the kernel's live Device Tree, along with
a generic interface to use it in a board agnostic manner.

It is dependent on Grant Likely's DT kobjectification patches located
in his tree as queued for -next.

It relies on the following previously submitted patches/patchsets:

* OF: Add [__]of_find_node_by_full_name
* OF: Utility helper functions for dynamic nodes

To compile overlays you need the DTC compiler patch

* "dtc: Dynamic symbols & fixup support (v2)"

Changes since V3:
* Added overlay self-tests.
* Fix bug in of_init_overlay_info (wrong sizeof)
* Platform bus handler handles parent_pdev == NULL
* of_resolve fixes according to comments by robh
  + changed if (foo == NULL) to if (!foo)
  + changed if (foo != NULL) to if (foo)
  + drivers/of/Kconfig added dep on OF && !SPARC
  + convert to using be32_to_cpup
  + u32 -> __be32 when modifying property values
  + cosmetic fixes

Changes since V2:
* Use of a configfs board agnostic overlay method
* Use of per bus handlers instead of hardcoded behaviour
* Optional target-path overlay target, which allows one to use standard
DTBs without resolution options.

Changes since V1:

* Removal of any bits related to a specific board (beaglebone).
* Introduced a platform agnostic interface using /proc/device-tree-overlay
* Various bug fixes related to i2c device handling have been squashed in.

Pantelis Antoniou (8):
  OF: Introduce Device Tree resolve support.
  OF: Introduce DT overlay support.
  OF: DT-Overlay configfs interface
  OF: platform: Add overlay bus handler
  of: i2c: Export single device registration method
  OF: i2c: Add overlay bus handler
  OF: spi: Add overlay bus handler
  OF: selftest: Add overlay self-test support.

 .../devicetree/dynamic-resolution-notes.txt        |  25 +
 Documentation/devicetree/overlay-notes.txt         | 187 +++++
 drivers/base/platform.c                            |  98 ++-
 drivers/i2c/i2c-core.c                             | 186 +++--
 drivers/of/Kconfig                                 |  24 +
 drivers/of/Makefile                                |   3 +
 drivers/of/configfs.c                              | 272 +++++++
 drivers/of/overlay.c                               | 895 +++++++++++++++++++++
 drivers/of/resolver.c                              | 368 +++++++++
 drivers/of/selftest.c                              | 368 +++++++++
 drivers/of/testcase-data/testcases.dtsi            |   1 +
 drivers/of/testcase-data/tests-overlay.dtsi        | 125 +++
 drivers/spi/spi.c                                  | 345 +++++---
 include/linux/i2c.h                                |  10 +
 include/linux/of.h                                 | 170 ++++
 15 files changed, 2925 insertions(+), 152 deletions(-)
 create mode 100644 Documentation/devicetree/dynamic-resolution-notes.txt
 create mode 100644 Documentation/devicetree/overlay-notes.txt
 create mode 100644 drivers/of/configfs.c
 create mode 100644 drivers/of/overlay.c
 create mode 100644 drivers/of/resolver.c
 create mode 100644 drivers/of/testcase-data/tests-overlay.dtsi

-- 
1.7.12

