Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116AbaKNEbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 23:31:10 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33824 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934226AbaKNEbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 23:31:08 -0500
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com, akpm@linux-foundation.org, jkosina@suse.cz,
        horia.geanta@freescale.com, computersforpeace@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 0/2] dma-debug: prevent early callers from crashing
Date: Thu, 13 Nov 2014 20:31:00 -0800
Message-Id: <1415939462-28174-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

This patch series addresses a problem seen on the brcmstb ARM platform where
dma_debug_init is called by the ARM kernel at fs_initcall time, while some of
our callers using the DMA-API were running at arch_initcall time.

Unless CONFIG_DMA_API_DEBUG is set, this is completely silent.

First patch introduces a helper function to check whether a DMA-API debug
implementation is allowed to proceed, while the second patch introduces an
initialization flag and uses the helper. A complete writeup of how and why this
crashes is provided in patch 2.

Thank you!

Florian Fainelli (2):
  dma-debug: introduce dma_debug_disabled
  dma-debug: prevent early callers from crashing

 lib/dma-debug.c | 43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

-- 
1.9.1

