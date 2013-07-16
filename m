Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab3GPPxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:53:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:8885 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590Ab3GPPxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:53:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,677,1367996400"; 
   d="scan'208";a="366125725"
Subject: [PATCH] mm: vmstats: tlb flush counters
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-mm@kvack.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 16 Jul 2013 08:53:04 -0700
Message-Id: <20130716155304.AF1A88F8@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was investigating some TLB flush scaling issues and realized
that we do not have any good methods for figuring out how many
TLB flushes we are doing.

It would be nice to be able to do these in generic code, but the
arch-independent calls don't explicitly specify whether we
actually need to do remote flushes or not.  In the end, we really
need to know if we actually _did_ global vs. local invalidations,
so that leaves us with few options other than to muck with the
counters from arch-specific code.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
