Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaK0Rzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:55:51 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63489 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaK0Rzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:55:49 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, grant.likely@linaro.org, robh+dt@kernel.org,
        plagnioj@jcrosoft.com, ijc@debian.org, andrew@lunn.ch,
        s.hauer@pengutronix.de
Subject: [PATCH v3 0/3] of: support passing console options with stdout-path
Date: Thu, 27 Nov 2014 17:56:04 +0000
Message-Id: <1417110967-16284-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set started its life as a small, self-contained, patch enabling
specifying console options in the stdout-path property, but then
grew into a mahoosive behemoth with one of the patches taking 1m42s
for get_maintainer to process. It has now once again reverted to a
smaller, more pleasant, state of being.

Changes since v2:
- Revert the invasive bit, creating a replacement wrapper function
  for of_get_node_by_path() callers.
- Make the of_get_node_opts_by_path() function return a const pointer
  to the argument.
- Added binding for /chosen node, with a description of stdout-path.

Changes since v1:
- Change interface of of_get_node_by_path() to take an additional
  argument, and update all of its callers to keep working.
- Rework original patch to use this interface.

Leif Lindholm (3):
  devicetree: of: Add bindings for chosen node, stdout-path
  of: add optional options parameter to of_find_node_by_path()
  of: support passing console options with stdout-path

 Documentation/devicetree/bindings/chosen.txt |   42 ++++++++++++++++++++++++++
 drivers/of/base.c                            |   30 ++++++++++++++----
 drivers/of/selftest.c                        |   12 ++++++++
 include/linux/of.h                           |   14 ++++++++-
 4 files changed, 91 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/chosen.txt

-- 
1.7.10.4

