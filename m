Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaAZVU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:20:56 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:59607 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaAZVUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:20:53 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Revamp randomize_range()
Date: Sun, 26 Jan 2014 22:20:37 +0100
Message-Id: <cover.1390770607.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please find two patches to remove unused/unwanted behavor
on randomize_range() function.

The first one remove the last option (len) which is unused
in current kernel. The second one rewrite the function to not
fail, allowing to remove the error handling code from the
calling functions.

I've not added the maintainers of the various arch modified
by the patches, wanted first to have your opinion about the
changes.

Regards.

Yann Droneaud (2):
  random: remove unused len argument in randomize_range() function
  random: don't return 0 in randomize_range()

 arch/arm/kernel/process.c       |  2 +-
 arch/arm64/kernel/process.c     |  2 +-
 arch/tile/mm/mmap.c             |  2 +-
 arch/unicore32/kernel/process.c |  2 +-
 arch/x86/kernel/process.c       |  2 +-
 arch/x86/kernel/sys_x86_64.c    |  5 +----
 drivers/char/random.c           | 19 ++++++++-----------
 include/linux/random.h          |  2 +-
 8 files changed, 15 insertions(+), 21 deletions(-)

-- 
1.8.5.3

