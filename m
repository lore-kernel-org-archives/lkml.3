Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab3JaBJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 21:09:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:58977 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab3JaBJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 21:09:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,605,1378882800"; 
   d="scan'208";a="420023469"
From: Lv Zheng <lv.zheng@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Lv Zheng <lv.zheng@intel.com>, <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 0/4] ACPICA: Stable material of ACPI executer fixes for linux-3.8.
Date: Thu, 31 Oct 2013 09:07:40 +0800
Message-Id: <cover.1383181113.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are bug-fixes for AML interpreter upstreamed, fixing some serious
issues found in recent platforms.  These fixes make Linux AML interpreter
more ACPI 2.0 ASL concept compliant.  Further AML interpreter fixes should
be based on such improvements, thus they are good materials for stable.

This patch set can be safely applied to linux-3.8:
commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200 upstream.

The patch set has passed build/boot tests on the following machines:
  Dell Inspiron Mini 1010 (i386)
  HP Compaq 8200 Elite SFF PC (x86-64)

Bob Moore (4):
  ACPICA: Interpreter: Fix Store() when implicit conversion is not
    possible.
  ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and
    BufferField refs.
  ACPICA: Return error if DerefOf resolves to a null package element.
  ACPICA: Fix for a Store->ArgX when ArgX contains a reference to a
    field.

 drivers/acpi/acpica/exoparg1.c |   48 +++++++++++--
 drivers/acpi/acpica/exstore.c  |  151 +++++++++++++++++++++++++++-------------
 2 files changed, 146 insertions(+), 53 deletions(-)

Cc: Bob Moore <robert.moore@intel.com>
-- 
1.7.10

