Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968099Ab3DRK1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:27:30 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42810 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964916Ab3DRK13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:27:29 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 0/9] Fix ux500 crypto drivers and init DMA in the correct way  
Date: Thu, 18 Apr 2013 11:26:56 +0100
Message-Id: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These drivers haven't been touched in a while. They didn't even compile
or probe successfully. After these changes, both drivers run just fine.

We also split DMA channel allocation and configuration into separate
invocations, as the API expects.

 arch/arm/mach-ux500/board-mop500.c    |   14 ++------------
 drivers/crypto/ux500/cryp/cryp.h      |    7 ++++++-
 drivers/crypto/ux500/cryp/cryp_core.c |   27 +++++++++++++++++++++++----
 drivers/crypto/ux500/hash/hash_alg.h  |    5 ++++-
 drivers/crypto/ux500/hash/hash_core.c |   20 +++++++++++++++-----
 5 files changed, 50 insertions(+), 23 deletions(-)

