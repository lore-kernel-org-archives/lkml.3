Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab3CDWnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:43:08 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59259 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440Ab3CDWnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:43:06 -0500
X-IronPort-AV: E=Sophos;i="4.84,783,1355126400"; 
   d="scan'208";a="27654212"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 0/2] Call tracing/debug code in VFP preempt code
Date: Mon,  4 Mar 2013 14:43:01 -0800
Message-Id: <1362436983-28988-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.7.1.ge545
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VFP preempt enable/disable code doesn't call into the tracers
and also doesn't participate in the preempt debugging code. This
patchset fixes that by making calls to the C functions from assembly
when appropriate.

Stephen Boyd (2):
  ARM: Consolidate preempt enable/disable assembly into macros
  ARM: Enable tracing around vfp preemption enable/disable

 arch/arm/kernel/entry-header.S | 31 +++++++++++++++++++++++++++++++
 arch/arm/vfp/entry.S           | 20 +++-----------------
 arch/arm/vfp/vfphw.S           | 14 ++------------
 3 files changed, 36 insertions(+), 29 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

