Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaIJS1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:27:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:1929 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbaIJS1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:27:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,500,1406617200"; 
   d="scan'208";a="571294453"
Date: Wed, 10 Sep 2014 11:27:44 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com, tglx@linutronix.de
Subject: Re: [PATCH] perf, x86: Fall back to vmalloc for BTS buffer allocation
Message-ID: <20140910182744.GJ5387@tassilo.jf.intel.com>
References: <1410307401-12401-1-git-send-email-andi@firstfloor.org>
 <20140910075722.GL6758@twins.programming.kicks-ass.net>
 <20140910144012.GI4120@two.firstfloor.org>
 <20140910163556.GE4783@worktop.ger.corp.intel.com>
 <20140910165848.GA11901@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910165848.GA11901@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note that since then we have actually fixed the 'cannot fault from NMI
> context' thing, so we should be able to actually take those faults. I
> suspect we can simply remove those WARNs from the vmalloc fault path,
> but it would need double checking to see if there's no other reasons.

I think we actually need to use vmalloc_sync_all, because the PEBS/DS
microcode may do the first access, and those lose events when
the page is not present.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
