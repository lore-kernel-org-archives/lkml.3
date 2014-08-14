Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaHNHVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:21:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:21052 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbaHNHVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:21:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="372236695"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: x86, MCE: MCE event ring management
Date: Thu, 14 Aug 2014 02:49:41 -0400
Message-Id: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have too many rings for different H/W error events management.
All of them can be merged into one kind of unified mechanism.
Furthermore, this management mechanism should be reliable enough
even in MCE context to avoid deadlock like calling printk in MCE
context. This patch series is used for this purpose.

[PATCH v2 1/5] x86, MCE: Provide a lock-less memory pool to save
[PATCH v2 2/5] x86, MCE: Don't use percpu for MCE workqueue/irq_work
[PATCH v2 3/5] x86, MCE: Remove mce_ring for SRAO error
[PATCH v2 4/5] x86/mce: Simplify flow when handling recoverable
[PATCH v2 5/5] x86, MCE: Avoid potential deadlock in MCE context

