Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab3CDSVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:21:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35933 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464Ab3CDSSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:18:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org
Cc: dan.magenheimer@oracle.com
Subject: [PATCH] Various fixes for zcache for v3.10
Date: Mon,  4 Mar 2013 13:18:10 -0500
Message-Id: <1362421101-15896-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that v3.9-rc1 is out and you are enjoying your time in Hong Kong
and are probabally fighting with the jet-lag, here are eleven
patches that per your recommendation were deferred to v3.10.

Nothing has changed with them and they just make the code easier
to understand. The bulk of the code is moving the debug counters
to its own file.

This is of course also available on a git tree

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git stable/for-greg-3.10

in case it strikes your fancy to do a git pull.

 drivers/staging/zcache/Kconfig       |   8 +
 drivers/staging/zcache/Makefile      |   1 +
 drivers/staging/zcache/debug.c       |  71 +++++++
 drivers/staging/zcache/debug.h       | 229 ++++++++++++++++++++
 drivers/staging/zcache/zbud.c        |  58 +++--
 drivers/staging/zcache/zcache-main.c | 402 +++++++++--------------------------
 6 files changed, 443 insertions(+), 326 deletions(-)

Konrad Rzeszutek Wilk (11):
      zcache: s/int/bool/ on the various options.
      zcache: Provide accessory functions for counter increase
      zcache: Provide accessory functions for counter decrease.
      zcache: The last of the atomic reads has now an accessory function.
      zcache: Make the debug code use pr_debug
      zcache: Move debugfs code out of zcache-main.c file.
      zcache/debug: Use an array to initialize/use debugfs attributes.
      zcache: Move the last of the debugfs counters out
      zcache: Module license is defined twice.
      zcache/debug: Coalesce all debug under CONFIG_ZCACHE_DEBUG
      zcache/zbud: Add incremental accessory counters

