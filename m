Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbaIZXbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 19:31:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:37102 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940AbaIZXbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 19:31:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,606,1406617200"; 
   d="scan'208";a="597491069"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: dave@sr71.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        eranian@google.com, x86@kernel.org
Subject: Optimize backtrace code for perf PMI handler.
Date: Fri, 26 Sep 2014 16:31:15 -0700
Message-Id: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While doing perf record -g I regularly exceed the time quote for the NMI:

This leads to perf shortening the period, which causes various problems.

This patchkit optimizes two sources of longer latencies in the NMI backtrace
code. There's probably more work needed to fix other sources of latencies
too.

-Andi

