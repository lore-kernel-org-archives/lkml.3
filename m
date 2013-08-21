Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3HUXrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:47:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:56963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab3HUXra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:47:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,930,1367996400"; 
   d="scan'208";a="384626668"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, acme@infradead.org, linux-kernel@vger.kernel.org
Subject: perf, x86: Add parts of the remaining haswell PMU functionality v3
Date: Wed, 21 Aug 2013 16:47:22 -0700
Message-Id: <1377128846-977-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope this version is ok for everyone now.

[v2: Added Peter's changes to the PEBS handler]
[v3: Addressed Arnaldo's feedback for the perf stat -T change
     and avoid conflict]

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
