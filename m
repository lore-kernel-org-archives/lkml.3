Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbaF0XKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:10:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:15463 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaF0XKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:10:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,564,1400050800"; 
   d="scan'208";a="562078297"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: eranian@google.com, linux-kernel@vger.kernel.org
Subject: Updated PEBS simplification/fixup patchkit
Date: Fri, 27 Jun 2014 16:10:10 -0700
Message-Id: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchkit is my take on how the PEBS event lists should
be revampled. Plus a fix for the ANY bit.

It is a superset of Stephane's patches and obsoletes them.

I think I discussed nearly everything in there already in some earlier
emails. Basic ideas/fixes:

- Don't list every PEBS event as that's not needed
- Check the flags as the SDM recommends
- Still allow cycles:pp of course
- Fix the counters for memory latency events
- Fix the DataLA handling on Haswell to support all events.
- Allow leaking events with ANY bit.

Also the patchkit removes more code than it adds, so it's a 
simplification. 

-Andi

