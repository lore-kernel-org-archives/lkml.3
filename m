Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab3ENSUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:20:45 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35557 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3ENSUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:20:44 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: bob.liu@oracle.com, dan.magenheimer@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-mm@kvack.org, xen-devel@lists.xensource.com
Subject: [PATCH] Fixes, cleanups, compile warning fixes, and documentation update for Xen tmem driver (v2).
Date: Tue, 14 May 2013 14:09:17 -0400
Message-Id: <1368554966-30469-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heya,

These nine patches fix the tmem driver to:
 - not emit a compile warning anymore (reported by 0 day test compile tool)
 - remove the various nofrontswap, nocleancache, noselfshrinking, noselfballooning,
   selfballooning, selfshrinking bootup options.
 - said options are now folded in the tmem driver as module options and are
   much shorter (and also there are only four of them now).
 - add documentation to explain these parameters in kernel-parameters.txt
 - And lastly add some logic to not enable selfshrinking and selfballooning
   if frontswap functionality is off.

That is it. Tested and ready to go. If nobody objects will put on my queue
for Linus on Monday.

 Documentation/kernel-parameters.txt |   21 ++++++++
 drivers/xen/Kconfig                 |    7 +--
 drivers/xen/tmem.c                  |   87 ++++++++++++++++-------------------
 drivers/xen/xen-selfballoon.c       |   47 ++----------------
 4 files changed, 69 insertions(+), 93 deletions(-)

(oh nice, more deletions!)

Konrad Rzeszutek Wilk (9):
      xen/tmem: Cleanup. Remove the parts that say temporary.
      xen/tmem: Move all of the boot and module parameters to the top of the file.
      xen/tmem: Split out the different module/boot options.
      xen/tmem: Fix compile warning.
      xen/tmem: s/disable_// and change the logic.
      xen/tmem: Remove the boot options and fold them in the tmem.X parameters.
      xen/tmem: Remove the usage of 'noselfshrink' and use 'tmem.selfshrink' bool instead.
      xen/tmem: Remove the usage of '[no|]selfballoon' and use 'tmem.selfballooning' bool instead.
      xen/tmem: Don't use self[ballooning|shrinking] if frontswap is off.

