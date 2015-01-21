Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbbAUTs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:48:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51972 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbbAUTsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:48:20 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 0/2] Fix secondary CPU boot for thumb2 kernels
Date: Wed, 21 Jan 2015 11:48:16 -0800
Message-Id: <1421869698-27341-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.3.0.rc0.46.gbe498cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently I can't boot up secondary CPUs on qcom platforms when I
compile the kernel for THUMB2 mode. This is because we always enter
the kernel in ARM mode regardless of what mode the kernel is compiled
for. This patchset adds a small wrapper to secondary_startup() called
secondary_startup_arm() that allows us to switch into THUMB2 mode if
we need to. If the kernel is compiled for ARM mode it shouldn't have
any effect.

Stephen Boyd (2):
  ARM: Add a secondary_startup that assumes ARM mode
  ARM: qcom: Use secondary_startup_arm()

 arch/arm/kernel/head.S       | 7 +++++++
 arch/arm/mach-qcom/platsmp.c | 4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

