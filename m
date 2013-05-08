Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab3EHVdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:33:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29971 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab3EHVbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:31:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: akpm@linux-foundation.org, bob.liu@oracle.com, dan.magenheimer@oracle.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Fixes and cleanups to the tmem driver. (v1)
Date: Wed,  8 May 2013 17:31:00 -0400
Message-Id: <1368048668-8140-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are RFC - I hadn't yet completly tested them. But they
fix the annoying:
 drivers/xen/tmem.c:365:13: warning: 'disable_frontswap_selfshrinking' defined but not used [-Wunused-variable]

(patch #4: [PATCH 4/8] xen/tmem: Fix compile warning. does it).

The rest are cleanups and removes some of the #ifdef machinary.

I hadn't yet the full testing and I am sure I am missing some
other documentation I should update.

 Documentation/kernel-parameters.txt | 20 ++++++++++
 drivers/xen/Kconfig                 |  7 ++--
 drivers/xen/tmem.c                  | 79 +++++++++++++++----------------------
 drivers/xen/xen-selfballoon.c       | 36 +----------------
 4 files changed, 56 insertions(+), 86 deletions(-)

(Yeey! More deletions!)

Konrad Rzeszutek Wilk (8):
      xen/tmem: Cleanup. Remove the parts that say temporary.
      xen/tmem: Move all of the boot and module parameters to the top of the file.
      xen/tmem: Split out the different module/boot options.
      xen/tmem: Fix compile warning.
      xen/tmem: s/disable_// and change the logic.
      xen/tmem: Remove the boot options and fold them in the tmem.X parameters.
      xen/tmem: Remove the usage of 'noselfshrink' and use 'tmem.selfshrink' bool instead.
      xen/tmem: Remove the usage of 'noselfballoon','selfballoon' and use 'tmem.selfballon' bool instead.

