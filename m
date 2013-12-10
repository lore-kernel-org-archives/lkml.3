Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab3LJXnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:43:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38951 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3LJXnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:43:18 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/7] Use regmap+devm in pm8xxx input drivers
Date: Tue, 10 Dec 2013 15:43:09 -0800
Message-Id: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches move the pm8xxx input drivers over to use devm_* APIs
and regmap. This breaks the dependency of these drivers on the pm8xxx
specific read/write calls and also simplifies the probe code a bit.

There was no devm_request_any_context_irq() available, so I've added
it here.

Stephen Boyd (7):
  Input: pmic8xxx-pwrkey - Pass input device directly to interrupt
  Input: pmic8xxx-pwrkey - Migrate to regmap APIs
  Input: pm8xxx-vibrator - Migrate to devm_* APIs
  Input: pm8xxx-vibrator - Migrate to regmap APIs
  genirq: Add devm_request_any_context_irq()
  Input: pmic8xxx-keypad - Migrate to devm_* APIs
  Input: pmic8xxx-keypad - Migrate to regmap APIs

 drivers/input/keyboard/pmic8xxx-keypad.c | 143 ++++++++++---------------------
 drivers/input/misc/pm8xxx-vibrator.c     | 107 ++++++-----------------
 drivers/input/misc/pmic8xxx-pwrkey.c     |  35 ++++----
 include/linux/interrupt.h                |   5 ++
 kernel/irq/devres.c                      |  45 ++++++++++
 5 files changed, 141 insertions(+), 194 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

