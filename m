Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaG1Dgc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:36:32 -0400
Received: from one.firstfloor.org ([193.170.194.197]:39549 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaG1Dgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:36:31 -0400
Date: Mon, 28 Jul 2014 05:36:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, acme@infradead.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v3 6/9] perf, x86: handle multiple records in PEBS
 buffer
Message-ID: <20140728033629.GJ18735@two.firstfloor.org>
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
 <1406016602-31845-7-git-send-email-zheng.z.yan@intel.com>
 <20140725081033.GV3935@laptop>
 <53D216A4.3090600@intel.com>
 <20140725140652.GA6758@twins.programming.kicks-ass.net>
 <53D5B45E.4030403@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53D5B45E.4030403@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think this method works for interrupt threshold > 1 case. When collision
> happens, the hardware only create one PEBS record. The status in next record has
> nothing to do with the collision record.
>
Not even for the threshold == 1 case, because the same could happen with
a different PEBS event. Of course in any case it's very unlikely ...

 > 
> > So typically we'd have one event set and no problem, but in case there's
> > more we can reconstruct with such a backwards pass from a known good
> > state.
> > 
> > But when in doubt, we should drop the record, its the safest choice.
> 
> The problem is that, in some cases, each PEBS record has more than one events
> set, so we will drop all records.

Just dropping is fine imho, this should be rare.

-Andi
