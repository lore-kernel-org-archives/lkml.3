Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3GJM7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 08:59:51 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58512 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3GJM7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 08:59:49 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, Nishanth Menon <nm@ti.com>,
        Pavel Machek <pavel@ucw.cz>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ivaylo Dimitrov <freemangordon@abv.bg>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 0/2] arm: omap: RX-51: ARM errata 430973 workaround
Date: Wed, 10 Jul 2013 14:59:03 +0200
Message-Id: <1373461145-9812-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
References: <1362044548-5398-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds RX-51 specific SMC support and sets IBE bit in ACTLR during
board init code for ARM errata 430973 workaround.

This is second version of patch which simplifing API and moving all board
functions to one file board-rx51.c. Wrapper around smc #1 instruction is in
omap-smc.S file because some other board may use it too.

Pali Rohár (2):
  ARM: OMAP: Add secure function omap_smc3() which calling instruction
    smc #1
  RX-51: ARM errata 430973 workaround

 arch/arm/mach-omap2/board-rx51.c  |   78 +++++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/omap-secure.h |    1 +
 arch/arm/mach-omap2/omap-smc.S    |   22 ++++++++++-
 3 files changed, 100 insertions(+), 1 deletion(-)

-- 
1.7.10.4

