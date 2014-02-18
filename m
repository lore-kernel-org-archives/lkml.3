Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaBRTaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:30:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:27354 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbaBRTaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:30:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="477225165"
Subject: [RFC][PATCH 0/6] x86: rework tlb range flushing code
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, ak@linux.intel.com, alex.shi@linaro.org,
        kirill.shutemov@linux.intel.com, mgorman@suse.de,
        tim.c.chen@linux.intel.com, x86@kernel.org, peterz@infradead.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 18 Feb 2014 11:30:08 -0800
Message-Id: <20140218193008.CA410E17@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I originally went to look at this becuase I realized that newer
CPUs were not present in the intel_tlb_flushall_shift_set() code.

I went to try to figure out where to stick newer CPUs (do we
consider them more like SandyBridge or IvyBridge), and was not
able to repeat the original experiments.

Instead, this set does:
 1. Rework the code a bit to ready it for tracepoints
 2. Add tracepoints
 3. Add a new tunable and set it to a sane value
