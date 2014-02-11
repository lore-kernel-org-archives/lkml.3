Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaBKQ0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:26:33 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46675 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaBKQ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:26:26 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-c6x-dev@linux-c6x.org
Subject: [PATCH 0/8] of_find_matching_node/of_match_node -> of_find_matching_node_and_match
Date: Tue, 11 Feb 2014 10:23:58 -0600
Message-Id: <1392135847-30791-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.8.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset updates users of the of_find_matching_node()/of_match_node() pair
to leverage of_find_matching_node_and_match(), which only requires one walk
through the match table.  This functionality was added by Stephen Warren[1], and
landed in v3.8.

Cc: Stephen Warren <swarren@nvidia.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

1: 50c8af4cf9 (of: introduce for_each_matching_node_and_match())

Josh Cartwright (8):
  bus: arm-cci: make use of of_find_matching_node_and_match
  bus: mvebu-mbus: make use of of_find_matching_node_and_match
  ARM: at91: make use of of_find_matching_node_and_match
  ARM: mvebu: make use of of_find_matching_node_and_match
  ARM: prima2: make use of of_find_matching_node_and_match
  ARM: l2x0: make use of of_find_matching_node_and_match
  C6X: make use of of_find_matching_node_and_match
  cpufreq: ppc: make use of of_find_matching_node_and_match

 arch/arm/mach-at91/setup.c              | 16 ++++------------
 arch/arm/mach-mvebu/system-controller.c |  9 ++++-----
 arch/arm/mach-prima2/l2x0.c             |  7 ++++---
 arch/arm/mm/cache-l2x0.c                |  5 +++--
 arch/c6x/platforms/plldata.c            |  7 +++----
 drivers/bus/arm-cci.c                   |  5 +++--
 drivers/bus/mvebu-mbus.c                |  3 +--
 drivers/cpufreq/ppc-corenet-cpufreq.c   |  3 +--
 8 files changed, 23 insertions(+), 32 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

