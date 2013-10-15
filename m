Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890Ab3JOUiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:38:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:9130 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933711Ab3JOUfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:35:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,502,1378882800"; 
   d="scan'208";a="308205403"
Subject: [RFC][PATCH 0/8] mm: freshen percpu pageset code
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, cl@gentwo.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 15 Oct 2013 13:35:36 -0700
Message-Id: <20131015203536.1475C2BE@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The percpu pageset (pcp) code is looking a little old and
neglected these days.  This set does a couple of these things (in
order of importance, not order of implementation in the series):

1. Change the default pageset pcp->high value from 744kB
   to 512k.  (see "consolidate high-to-batch ratio code")
2. Allow setting of vm.percpu_pagelist_fraction=0, which
   takes you back to the boot-time behavior
3. Resolve inconsistencies in the way the boot-time and
   sysctl pcp code works.
4. Clarify some function names and code comments.

