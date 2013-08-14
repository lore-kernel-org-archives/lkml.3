Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236Ab3HNSej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:34:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:5091 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758617Ab3HNSeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:34:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,878,1367996400"; 
   d="scan'208";a="387159950"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, acme@infradead.org, linux-kernel@vger.kernel.org
Subject: perf, x86: Add parts of the remaining haswell PMU functionality v2
Date: Wed, 14 Aug 2013 11:34:23 -0700
Message-Id: <1376505267-8902-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[v2: Added Peter's changes to the PEBS handler]

Add some more TSX functionality to the basic Haswell PMU.

A lot of the infrastructure needed for these patches has
been merged earlier, so it is all quite straight forward
now.

- Add the checkpointed counter workaround.
(Parts of this have been already merged earlier)
- Add support for reporting PEBS transaction abort cost as weight.
This is useful to judge the cost of aborts and concentrate
on expensive ones first.
(Large parts of this have been already merged earlier,
this is just adding the final few lines to the PEBS handler)
- Add TSX event aliases, needed for perf stat -T and general
usability.
(Infrastructure also already in)
- Add perf stat -T support to give a user friendly highlevel
counting frontend for transaction..
This version should also be usable for POWER8 eventually.

Not included:

Support for transaction flags and TSX LBR flags.

-Andi
