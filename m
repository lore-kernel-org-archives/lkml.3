Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbaDVUBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:01:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:56021 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbaDVT6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:58:30 -0400
Date: Tue, 22 Apr 2014 10:15:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [Bugfix] sched: fix possible invalid memory access caused by CPU
 hot-addition
Message-ID: <20140422081515.GF11182@twins.programming.kicks-ass.net>
References: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 01:27:15PM +0800, Jiang Liu wrote:
> When calling kzalloc_node(size, flags, node), we should first check
> whether node is onlined, otherwise it may cause invalid memory access
> as below.

But this is only for memory less node crap, right? 
