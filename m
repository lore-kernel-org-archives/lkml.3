Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab3KSKVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:21:50 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:39771 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3KSKVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:21:48 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 0/3] Add support for charging battery in Nokia RX-51
Date: Tue, 19 Nov 2013 11:18:02 +0100
Message-Id: <1384856285-19593-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series finally bringing support for charging battery on
Nokia N900 (RX-51) without any proprietary Nokia bits in userspace.

I removed hook function from bq2415x_charger driver and replaced it
by Jenny TC power_supply notifier code. This simplify usage of
bq2415x driver and also allow adding DT support in future because
driver does not need board specific function anymore (only static data).

I tested this series with linux 3.12-rc5 on Nokia N900.

Pali Rohár (3):
  power_supply: Add power_supply notifier
  bq2415x_charger: Use power_supply notifier for automode
  RX-51: Add platform data for bq24150a charger

 arch/arm/mach-omap2/board-rx51-peripherals.c |   17 +++++-
 drivers/power/bq2415x_charger.c              |   77 ++++++++++++++++++++------
 drivers/power/power_supply_core.c            |   17 ++++++
 include/linux/power/bq2415x_charger.h        |   48 ++--------------
 include/linux/power_supply.h                 |   10 ++++
 5 files changed, 108 insertions(+), 61 deletions(-)

-- 
1.7.9.5

