Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3AODjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:39:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42992 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085Ab3AODjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:39:46 -0500
Date: Tue, 15 Jan 2013 12:39:37 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <linus@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap fixes for v3.8
Message-ID: <20130115033935.GE5701@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-debugfs-fixes

for you to fetch changes up to e8d6539c8a94b88fc7ca5d6bdd9eeb0e64b434e4:

  regmap: debugfs: Make sure we store the last entry in the offset cache (2013-01-08 20:52:51 +0000)

----------------------------------------------------------------
regmap: Optimisation fixes for debugfs

The debugfs optimisations merged in v3.8 weren't my finest hour, there
were a number of cases that the more complex algorithm made worse
especially around the error handling. This patch series should address
those issues.

----------------------------------------------------------------
Mark Brown (5):
      regmap: debugfs: Fix attempts to read nonexistant register blocks
      regmap: debugfs: Fix check for block start in cached seeks
      regmap: debugfs: Discard the cache if we fail to allocate an entry
      regmap: debugfs: Ensure a correct return value for empty caches
      regmap: debugfs: Make sure we store the last entry in the offset cache

 drivers/base/regmap/regmap-debugfs.c |   53 +++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 13 deletions(-)
