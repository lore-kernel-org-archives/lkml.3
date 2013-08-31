Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3HaNhQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 09:37:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:50271 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979Ab3HaNhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 09:37:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,997,1367996400"; 
   d="scan'208";a="354215356"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, acme@infradead.org, linux-kernel@vger.kernel.org
Subject: perf, x86: Add parts of the remaining haswell PMU functionality v4
Date: Sat, 31 Aug 2013 06:37:02 -0700
Message-Id: <1377956226-18594-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[v2: Added Peter's changes to the PEBS handler]
[v3: Addressed Arnaldo's feedback for the perf stat -T change
     and avoid conflict]
[v4: Remove XXX comment in checkpoint patch.
     Add Arnaldo's ack for tools patch]

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
