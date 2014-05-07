Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaEGVs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:48:29 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51032 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaEGVs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:48:27 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 0/4] DT platform device name collision fixes
Date: Wed,  7 May 2014 16:48:14 -0500
Message-Id: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

This series fixes the device naming collisions that can occur with 
nultiple devices having the same name and non-translatable unit 
addresses. This issue was raised in this thread[1]. I intend to merge 
this regardless of whether or not some hierarchy in sysfs is created. 
That is really a separate issue independent of these fixes.

I found and fix a couple of other issues in the process of testing the 
fix.

Rob

[1] https://lkml.org/lkml/2014/4/23/312

Rob Herring (4):
  of/selftest: add testcase for nodes with same name and address
  of/platform: return error on of_platform_device_create_pdata failure
  of/platform: fix device naming for non-translatable addresses
  of: kill off of_can_translate_address

 drivers/of/address.c                         | 22 +----------------
 drivers/of/platform.c                        | 20 +++++-----------
 drivers/of/selftest.c                        | 23 ++++++++++++++++++
 drivers/of/testcase-data/testcases.dtsi      |  1 +
 drivers/of/testcase-data/tests-platform.dtsi | 35 ++++++++++++++++++++++++++++
 include/linux/of_address.h                   |  1 -
 6 files changed, 66 insertions(+), 36 deletions(-)
 create mode 100644 drivers/of/testcase-data/tests-platform.dtsi

-- 
1.9.1

