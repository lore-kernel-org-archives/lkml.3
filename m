Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288Ab3GWVHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:07:08 -0400
Received: from dupo.coraid.com ([208.71.232.133]:37803 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933768Ab3GWVHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:07:06 -0400
Message-Id: <cover.1374610591.git.ecashin@coraid.com>
Subject: [PATCH 0/6] aoe: add debugfs-based export of debug counters
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Tue, 23 Jul 2013 17:06:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series applies to today's linux-next/akpm, commit
0c2f52fa9a7cb139617078568c48026c49927617.

It adds the debugging information that the coraid.com-distributed aoe
driver exports via sysfs, but instead of sysfs, it uses debugfs.

With these patches applied, even without AoE targets on the network,
KEDR reports new possible memory leaks, but these are from callers
outside the aoe driver that have used aoe_devnode to get the name of
the character devices through the aoe_class->devnode callback, and I
believe they're responsible for freeing that memory.

Ed L. Cashin (6):
  aoe: create and destroy debugfs directory for aoe
  aoe: add AoE-target files to debugfs
  aoe: provide file operations for debugfs files
  aoe: fill in per-AoE-target information for debugfs file
  aoe: update copyright date
  aoe: update internal version number to 85

 drivers/block/aoe/aoe.h    |    4 +-
 drivers/block/aoe/aoeblk.c |  101 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/block/aoe/aoedev.c |    1 +
 3 files changed, 103 insertions(+), 3 deletions(-)

