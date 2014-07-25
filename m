Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732AbaGYPEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:04:51 -0400
Received: from one.firstfloor.org ([193.170.194.197]:58938 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaGYPEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:04:50 -0400
Date: Fri, 25 Jul 2014 17:04:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, acme@infradead.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS
 buffer
Message-ID: <20140725150445.GG18735@two.firstfloor.org>
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
 <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com>
 <20140725081033.GV3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725081033.GV3935@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You can't.. the events might have different security context.
> 
> Remember, the overflow bit is set from the overflow until the PEBS
> event is generated, this is quite a long time. So if another PEBS event
> gets generated while the other is still pending it will have both bits
> set. Even though the second bit is for another (unrelated) counter.

When an event is not allowed by some policy it should be disabled
in global ctrl right? And disabling makes sure overflow is cleared,
and PEBS will not report it.

When it's not disabled it could happen any time and there
is no isolation.

Or is the concern that the PEBS buffer may not be flushed
on event switch/disable and you see something stale? I believe it is
flushed.

> I think you can unwind and fully correct this trainwreck. But simply
> delivering an even with multiple bits set to all relevant events is
> wrong and might leak sensitive information.

In theory could double check that the event is enabled,
but I don't think it's really needed.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
