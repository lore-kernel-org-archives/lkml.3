Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaJJXZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 19:25:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:54655 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbaJJXZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 19:25:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398494488"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Updated perf backtrace improvement patchkit
Date: Fri, 10 Oct 2014 16:25:13 -0700
Message-Id: <1412983517-12419-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reworked the patchkit to speed up perf backtracing based on
the feedback. It now uses a new method to determine the kernel
addresses using the page tables, and also avoids using copy_*_user
in the backtrace at all.

The goal is to avoid perf exceeding the NMI handler CPU time quota.

In addition this patchkit also optimizes the generic fault handling
for one case in copy_*_user (running on systems with enhanced copy
string)

Hopefully this version is more acceptable.

-Andi

